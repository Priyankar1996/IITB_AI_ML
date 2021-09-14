#include "convolutionTranspose.h"
#include <inttypes.h>
uint32_t computeDilatedTensorOffset(uint32_t offset, TensorDescriptor *td_in,
                                    TensorDescriptor *td_out, uint32_t *k_dims, 
                                    uint32_t *stride)
{
    int i,p; uint32_t indices[3],output_indices[3],output_offset = 0;

    for(p=td_in->number_of_dimensions-1;p>=0;p--) // Change 2 to 1 while handling 3-channels.
    {
        indices[p] = ((offset % td_in->dimensions[p])? (offset % td_in->dimensions[p]):td_in->dimensions[p])-1;
        offset = CEILING(offset,td_in->dimensions[p]);
    }
    indices[td_in->number_of_dimensions-1] = td_in->dimensions[td_in->number_of_dimensions-1]-1;
    
    /*for(i=0;i< td_in->number_of_dimensions;i++)
        printf("%d ",indices[i]);
    printf("\t");*/
    
    for(i = 0;i < td_out->number_of_dimensions-1;i++)
    {
        output_indices[i] = (indices[i] * stride[i]) + k_dims[i] -1; // - padding
    }
    output_indices[td_out->number_of_dimensions-1] = td_out->dimensions[td_out->number_of_dimensions-1]-1;
    
    /*for(i=0;i< td_out->number_of_dimensions;i++)
        printf("%d ",output_indices[i]);
    printf("\n");*/
    
    output_offset = getTensorEntryIndexOffset(td_out,output_indices);
    return output_offset;
}

int checkPadding(uint32_t offset, TensorDescriptor *td_in,
                TensorDescriptor *td_out,  uint32_t padding)
{
    int i,p; int indices[3],output_indices[3],output_offset = 0, flag = 0;

    for(p=td_in->number_of_dimensions-1;p>=0;p--) // Change 2 to 1 while handling 3-channels.
    {
        indices[p] = ((offset % td_in->dimensions[p])? (offset % td_in->dimensions[p]):td_in->dimensions[p])-1;
        offset = CEILING(offset,td_in->dimensions[p]);
    }
    indices[td_in->number_of_dimensions-1] = td_in->dimensions[td_in->number_of_dimensions-1]-1;
    
    /*for(i=0;i< td_in->number_of_dimensions;i++)
        printf("%d\t",indices[i]);
    printf("\t\t");*/
    
    for(i = 0;i < td_out->number_of_dimensions-1;i++)
    {
        output_indices[i] = indices[i] - padding;
    }
    output_indices[td_out->number_of_dimensions-1] = td_out->dimensions[td_out->number_of_dimensions-1]-1;
    
    /*for(i=0;i< td_out->number_of_dimensions;i++)
        printf("%d\t",output_indices[i]);*/
    
    
    for(i=0;i< td_out->number_of_dimensions-1;i++)
    {
        if (output_indices[i] < 0 || (output_indices[i] == (td_in->dimensions[i] - padding - 1) && padding !=0))
            flag = 1;
    }

    output_offset = flag ? -1 : 1;
    //printf("\t\t%d",output_offset);
    //printf("\t");
    return output_offset;
}

int dilateTensor(Tensor *input, Tensor *kernel, uint32_t *stride, Tensor *output)
{
    TensorDescriptor td_input, td_kernel, td_output;
    td_input = input->descriptor;
    td_kernel = kernel->descriptor;
    td_output = output->descriptor;
    MemPoolRequest mp_req1,mp_req2;
    MemPoolResponse mp_resp1,mp_resp2;

    int iter = -1,iter_write=1;
    uint32_t datasize = sizeofTensorDataInBytes(td_input.data_type),
             num_elems_input = numberOfElementsInTensor(input),
             num_elems_output = numberOfElementsInTensor(output);
    int input_words_left = CEILING(num_elems_input*datasize,8),
        output_words_left = CEILING(num_elems_output*datasize,8),
        i,k,count = 0,flag = 0,output_offset=0;

    void *array;
    array = mp_req2.write_data;
    for(i=0;i<1024*8/datasize;i++)
        *((uint8_t*)mp_req2.write_data + i) = 0;

    for(; input_words_left > 0; input_words_left -= MAX_SIZE_OF_REQUEST_IN_WORDS)
    {
        iter++;
        int elements_to_read = MIN(input_words_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
        mp_req1.request_type = READ;
        mp_req1.arguments[0] = elements_to_read;
        mp_req1.arguments[1] = input->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
        mp_req1.arguments[2] = 1;

        memPoolAccess((MemPool *)(input->mem_pool_identifier),&mp_req1,&mp_resp1);
            for(i=0;i<elements_to_read;i++)
            {
                uint64_t v= mp_resp1.read_data[i];
                switch (input->descriptor.data_type)
                {
                    case u8: {
                                //printf("READ VALUE:0X%"PRIx64"\n",mp_resp1.read_data[i]);
                                uint8_t g=0,bytesu8[8];
                                for(k=0;k<8;k++)
                                    bytesu8[i] = 0;
                                do bytesu8[g++]= v & 0xFF; while (v>>=8);
                                g=0;

                                for(k=0;k<8/datasize;k++)
                                {
                                    count++;
                                    output_offset = computeDilatedTensorOffset(count,&td_input,&td_output,&td_kernel.number_of_dimensions,stride);
                                    if(count<=num_elems_output)
                                    {
                                        int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                        if(output_offset/iter_write >= elements_to_write*8/datasize || (count == num_elems_input))
                                        {
                                            if(output_offset/iter_write > elements_to_write*8/datasize)
                                            {
                                                // Write the array back to mempool, intialise it and then write the incoming value.
                                                mp_req2.request_type = WRITE;
                                                mp_req2.arguments[0] = elements_to_write;
                                                mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                if(mp_resp2.status != OK)
                                                {
                                                    fprintf(stderr,"WRITE FAILURE.");
                                                    flag = flag || 1;
                                                }
                                                else
                                                {
                                                    fprintf(stderr,"SUCCESS: Wrote dilated tensor.");
                                                    output_words_left-= elements_to_write;
                                                    for(i=0;i<1024*8/datasize;i++)
                                                        *((uint8_t*)mp_req2.write_data + i) = 0;
                                                    *((uint8_t*)array + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                                }
                                            }
                                            else
                                            {
                                                // Store the incoming value into the array and then write it in the mempool.
                                                *((uint8_t*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                                mp_req2.request_type = WRITE;
                                                mp_req2.arguments[0] = elements_to_write;
                                                mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                if (mp_resp2.status != OK)
                                                {
                                                    fprintf(stderr,"WRITE FAILURE.\n");
                                                    flag = flag || 1;
                                                }
                                                else
                                                {
                                                    fprintf(stderr,"SUCCESS: Wrote dilated tensor.\n");
                                                    output_words_left-= elements_to_write;
                                                    for(i=0;i<1024;i++)
                                                        *((uint64_t*)array + i) = 0;
                                                }
                                                if(count == num_elems_input)
                                                    break;
                                            }
                                        }
                
                                        else
                                            *((uint8_t*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                    }
                                }
                                break;
                            } 
                    case u16:{
                                //printf("READ VALUE:0X%"PRIx64"\n",mp_resp1.read_data[i]);
                                uint16_t g=0,bytesu16[4];
                                for(k=0;k<4;k++)
                                    bytesu16[i] = 0;
                                do bytesu16[g++]= v & 0xFFFF; while (v>>=16);
                                g=0;

                                for(k=0;k<8/datasize;k++)
                                {
                                    count++;
                                    output_offset = computeDilatedTensorOffset(count,&td_input,&td_output,&td_kernel.number_of_dimensions,stride);
                                    if(count<=num_elems_output)
                                    {
                                        int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                        if(output_offset/iter_write >= elements_to_write*8/datasize || (count == num_elems_input))
                                        {
                                            if(output_offset/iter_write > elements_to_write*8/datasize)
                                            {
                                                // Write the array back to mempool, intialise it and then write the incoming value.
                                                mp_req2.request_type = WRITE;
                                                mp_req2.arguments[0] = elements_to_write;
                                                mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                if(mp_resp2.status != OK)
                                                {
                                                    fprintf(stderr,"WRITE FAILURE.");
                                                    flag = flag || 1;
                                                }
                                                else
                                                {
                                                    fprintf(stderr,"SUCCESS: Wrote dilated tensor.");
                                                    output_words_left-= elements_to_write;
                                                    for(i=0;i<1024*8/datasize;i++)
                                                        *((uint16_t*)mp_req2.write_data + i) = 0;
                                                    *((uint16_t*)array + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu16[k];
                                                }
                                            }
                                            else
                                            {
                                                // Store the incoming value into the array and then write it in the mempool.
                                                *((uint16_t*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu16[k];
                                                mp_req2.request_type = WRITE;
                                                mp_req2.arguments[0] = elements_to_write;
                                                mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                if (mp_resp2.status != OK)
                                                {
                                                    fprintf(stderr,"WRITE FAILURE.\n");
                                                    flag = flag || 1;
                                                }
                                                else
                                                {
                                                    fprintf(stderr,"SUCCESS: Wrote dilated tensor.\n");
                                                    output_words_left-= elements_to_write;
                                                    for(i=0;i<1024;i++)
                                                        *((uint64_t*)array + i) = 0;
                                                }
                                                if(count == num_elems_input)
                                                    break;
                                            }
                                        }
                
                                        else
                                            *((uint16_t*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu16[k];
                                    }
                                }
                                break;
                            }     
                            case u32:{
                                        uint32_t g=0,bytesu32[2];
                                        for(k=0;k<2;k++)
                                            bytesu32[i] = 0;
                                        do bytesu32[g++]= v & 0xFFFFFFFF; while (v>>=32);
                                        g=0;

                                        for(k=0;k<8/datasize;k++)
                                        {
                                            count++;
                                            output_offset = computeDilatedTensorOffset(count,&td_input,&td_output,&td_kernel.number_of_dimensions,stride);
                                            if(count<=num_elems_output)
                                            {
                                                int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                                if(output_offset/iter_write >= elements_to_write*8/datasize || (count == num_elems_input))
                                                {
                                                    if(output_offset/iter_write > elements_to_write*8/datasize)
                                                    {
                                                // Write the array back to mempool, intialise it and then write the incoming value.
                                                        mp_req2.request_type = WRITE;
                                                        mp_req2.arguments[0] = elements_to_write;
                                                        mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                        memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                        if(mp_resp2.status != OK)
                                                        {
                                                            fprintf(stderr,"WRITE FAILURE.");
                                                            flag = flag || 1;
                                                        }
                                                        else
                                                        {
                                                            fprintf(stderr,"SUCCESS: Wrote dilated tensor.");
                                                            output_words_left-= elements_to_write;
                                                            for(i=0;i<1024*8/datasize;i++)
                                                                *((uint32_t*)mp_req2.write_data + i) = 0;
                                                            *((uint32_t*)array + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu32[k];
                                                        }
                                                    }
                                                    else
                                                    {
                                                        // Store the incoming value into the array and then write it in the mempool.
                                                        *((uint32_t*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu32[k];
                                                        mp_req2.request_type = WRITE;
                                                        mp_req2.arguments[0] = elements_to_write;
                                                        mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                        memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                        if (mp_resp2.status != OK)
                                                        {
                                                            fprintf(stderr,"WRITE FAILURE.\n");
                                                            flag = flag || 1;
                                                        }
                                                        else
                                                        {
                                                            fprintf(stderr,"SUCCESS: Wrote dilated tensor.\n");
                                                            output_words_left-= elements_to_write;
                                                            for(i=0;i<1024;i++)
                                                                *((uint64_t*)array + i) = 0;
                                                        }
                                                        if(count == num_elems_input)
                                                            break;
                                                    }
                                                }
                
                                                else
                                                    *((uint32_t*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu32[k];
                                            }
                                        }                                
                                        break;
                                    }
                            case u64:{break;}
                            case i8:{break;}
                            case i16:{break;}
                            case i32:{break;}
                            case i64:{break;}
                            case float8:{break;}
                            case float16:{break;}
                            case float32:{
                                            uint16_t g=0;float bytes[2];
                                            for(k=0;k<2;k++)
                                                bytes[i] = 0.0;
                                            do bytes[g++]= v & 0xFFFFFFFF; while (v>>=32);
                                            g=0;

                                            for(k=0;k<8/datasize;k++)
                                            {
                                                count++;
                                                output_offset = computeDilatedTensorOffset(count,&td_input,&td_output,&td_kernel.number_of_dimensions,stride);
                                                if(count<=num_elems_output)
                                                {
                                                    int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                                    if(output_offset/iter_write >= elements_to_write*8/datasize || (count == num_elems_input))
                                                    {
                                                        if(output_offset/iter_write > elements_to_write*8/datasize)
                                                        {
                                                            // Write the array back to mempool, intialise it and then write the incoming value.
                                                            mp_req2.request_type = WRITE;
                                                            mp_req2.arguments[0] = elements_to_write;
                                                            mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                            memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                            if(mp_resp2.status != OK)
                                                            {
                                                                fprintf(stderr,"WRITE FAILURE.");
                                                                flag = flag || 1;
                                                            }
                                                            else
                                                            {
                                                                fprintf(stderr,"SUCCESS: Wrote dilated tensor.");
                                                                output_words_left-= elements_to_write;
                                                                for(i=0;i<1024*8/datasize;i++)
                                                                    *((float*)mp_req2.write_data + i) = 0;
                                                                *((float*)array + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytes[k];
                                                            }
                                                        }
                                                        else
                                                        {
                                                            // Store the incoming value into the array and then write it in the mempool.
                                                            *((float*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytes[k];
                                                            mp_req2.request_type = WRITE;
                                                            mp_req2.arguments[0] = elements_to_write;
                                                            mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                            memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                            if (mp_resp2.status != OK)
                                                            {
                                                                fprintf(stderr,"WRITE FAILURE.\n");
                                                                flag = flag || 1;
                                                            }
                                                            else
                                                            {
                                                                fprintf(stderr,"SUCCESS: Wrote dilated tensor.\n");
                                                                output_words_left-= elements_to_write;
                                                                for(i=0;i<1024;i++)
                                                                    *((uint64_t*)array + i) = 0;
                                                            }
                                                            if(count == num_elems_input)
                                                                break;
                                                        }
                                                    }
                
                                                    else
                                                        *((float*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytes[k];
                                                }
                                            }
                                            break;
                                        }
                            case float64:{
                                            count++;
                                            output_offset = computeDilatedTensorOffset(count,&td_input,&td_output,&td_kernel.number_of_dimensions,stride);
                                            if(count<=num_elems_output)
                                            {
                                                int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                                if(output_offset/iter_write >= elements_to_write*8/datasize || (count == num_elems_input))
                                                {
                                                    if(output_offset/iter_write > elements_to_write*8/datasize)
                                                    {
                                                        // Write the array back to mempool, intialise it and then write the incoming value.
                                                        mp_req2.request_type = WRITE;
                                                        mp_req2.arguments[0] = elements_to_write;
                                                        mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                        memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                        if(mp_resp2.status != OK)
                                                        {
                                                            fprintf(stderr,"WRITE FAILURE.");
                                                            flag = flag || 1;
                                                        }
                                                        else
                                                        {
                                                            fprintf(stderr,"SUCCESS: Wrote dilated tensor.");
                                                            output_words_left-= elements_to_write;
                                                            for(i=0;i<1024*8/datasize;i++)
                                                                *((double*)mp_req2.write_data + i) = 0;
                                                                *((double*)array + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = v;
                                                            }
                                                        }
                                                        else
                                                        {
                                                            // Store the incoming value into the array and then write it in the mempool.
                                                            *((double*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = v;
                                                            mp_req2.request_type = WRITE;
                                                            mp_req2.arguments[0] = elements_to_write;
                                                            mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                            memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                            if (mp_resp2.status != OK)
                                                            {
                                                                fprintf(stderr,"WRITE FAILURE.\n");
                                                                flag = flag || 1;
                                                            }
                                                            else
                                                            {
                                                                fprintf(stderr,"SUCCESS: Wrote dilated tensor.\n");
                                                                output_words_left-= elements_to_write;
                                                                for(i=0;i<1024;i++)
                                                                    *((uint64_t*)array + i) = 0;
                                                            }
                                                            if(count == num_elems_input)
                                                                break;
                                                        }
                                                    }
                
                                                    else
                                                        *((double*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = v;
                                            }    
                                            break;
                                        }
                                            
                }
            }  
        }
        return flag;
    }

int dePadTensor(Tensor *input, uint32_t padding, Tensor *output)
{
    TensorDescriptor td_input, td_output;
    td_input = input->descriptor;
    td_output = output->descriptor;
    MemPoolRequest mp_req1,mp_req2;
    MemPoolResponse mp_resp1,mp_resp2;

    int iter = -1,iter_write=1;
    uint32_t datasize = sizeofTensorDataInBytes(td_input.data_type),
             num_elems_input = numberOfElementsInTensor(input),
             num_elems_output = numberOfElementsInTensor(output);
    int input_words_left = CEILING(num_elems_input*datasize,8),
        output_words_left = CEILING(num_elems_output*datasize,8),
        i,k,count = 0,flag = 0,check_depad=0,output_offset=-1;

    void *array;
    array = mp_req2.write_data;
    for(i=0;i<1024*8/datasize;i++)
        *((uint8_t*)mp_req2.write_data + i) = 0;

    for(; input_words_left > 0; input_words_left -= MAX_SIZE_OF_REQUEST_IN_WORDS)
    {
        iter++;
        int elements_to_read = MIN(input_words_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
        mp_req1.request_type = READ;
        mp_req1.arguments[0] = elements_to_read;
        mp_req1.arguments[1] = input->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
        mp_req1.arguments[2] = 1;

        memPoolAccess((MemPool *)(input->mem_pool_identifier),&mp_req1,&mp_resp1);
            for(i=0;i<elements_to_read;i++)
            {
                uint64_t v= mp_resp1.read_data[i];
                switch (input->descriptor.data_type)
                {
                    case u8: {
                                //printf("READ VALUE:0X%"PRIx64"\n",mp_resp1.read_data[i]);
                                uint8_t g=0,bytesu8[8];
                                for(k=0;k<8;k++)
                                    bytesu8[k] = 0;
                                do bytesu8[g++]= v & 0xFF; while (v>>=8);
                                g=0;

                                for(k=0;k<8/datasize;k++)
                                {
                                    count++;
                                    check_depad = checkPadding(count,&td_input,&td_output,padding);
                                    if(check_depad >0)
                                    {
                                        ++output_offset;
                                        if(output_offset<num_elems_output)
                                        {
                                            //printf("%d,%u\n",output_offset,bytesu8[k]);
                                            int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                            if(output_offset/iter_write >= elements_to_write*8/datasize || (output_offset == num_elems_output-1))
                                            {
                                                if(output_offset/iter_write > elements_to_write*8/datasize)
                                                {
                                                    // Write the array back to mempool, intialise it and then write the incoming value.
                                                    mp_req2.request_type = WRITE;
                                                    mp_req2.arguments[0] = elements_to_write;
                                                    mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                    memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                    if(mp_resp2.status != OK)
                                                    {
                                                        fprintf(stderr,"WRITE FAILURE.");
                                                        flag = flag || 1;
                                                    }
                                                    else
                                                    {
                                                        fprintf(stderr,"SUCCESS: Wrote depadded tensor.\n");
                                                        output_words_left-= elements_to_write;
                                                        for(i=0;i<1024*8/datasize;i++)
                                                            *((uint8_t*)mp_req2.write_data + i) = 0;
                                                        *((uint8_t*)array + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                                    }
                                                }
                                                else
                                                {
                                                    // Store the incoming value into the array and then write it in the mempool.
                                                    //printf("WROTE\t%d\t%d\n",output_offset,bytesu8[k]);
                                                    *((uint8_t*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                                    mp_req2.request_type = WRITE;
                                                    mp_req2.arguments[0] = elements_to_write;
                                                    mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                    /*for(p=0;p<elements_to_write;p++)
                                                        printf("WRITING VALUE:0X%"PRIx64"\n",mp_req2.write_data[p]);*/
                                                    memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                    if (mp_resp2.status != OK)
                                                    {
                                                        fprintf(stderr,"WRITE FAILURE.\n");
                                                        flag = flag || 1;
                                                    }
                                                    else
                                                    {
                                                        fprintf(stderr,"SUCCESS: Wrote depadded tensor.\n");
                                                        output_words_left-= elements_to_write;
                                                        for(i=0;i<1024;i++)
                                                            *((uint64_t*)array + i) = 0;
                                                    }
                                                    if(output_offset == num_elems_output)
                                                        break;
                                                }
                                        }
                
                                        else
                                        {
                                            //printf("WROTE\t%d\t%d\n",output_offset,bytesu8[k]);
                                            *((uint8_t*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                        }
                                    }
                                    }
                                    else
                                    {
                                        //printf("NEGATIVE\n");
                                    }
                                }
                                break;
                            }

                    case u16:{
                                uint8_t g=0;uint16_t bytesu8[4];
                                for(k=0;k<4;k++)
                                    bytesu8[k] = 0;
                                do bytesu8[g++]= v & 0xFFFF; while (v>>=16);
                                g=0;

                                for(k=0;k<8/datasize;k++)
                                {
                                    count++;
                                    check_depad = checkPadding(count,&td_input,&td_output,padding);
                                    if(check_depad >0)
                                    {
                                        ++output_offset;
                                        if(output_offset<num_elems_output)
                                        {
                                            //printf("%d,%u\n",output_offset,bytesu8[k]);
                                            int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                            if(output_offset/iter_write >= elements_to_write*8/datasize || (output_offset == num_elems_output-1))
                                            {
                                                if(output_offset/iter_write > elements_to_write*8/datasize)
                                                {
                                                    // Write the array back to mempool, intialise it and then write the incoming value.
                                                    mp_req2.request_type = WRITE;
                                                    mp_req2.arguments[0] = elements_to_write;
                                                    mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                    memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                    if(mp_resp2.status != OK)
                                                    {
                                                        fprintf(stderr,"WRITE FAILURE.");
                                                        flag = flag || 1;
                                                    }
                                                    else
                                                    {
                                                        fprintf(stderr,"SUCCESS: Wrote depadded tensor.\n");
                                                        output_words_left-= elements_to_write;
                                                        for(i=0;i<1024*8/datasize;i++)
                                                            *((uint16_t*)mp_req2.write_data + i) = 0;
                                                        *((uint16_t*)array + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                                    }
                                                }
                                                else
                                                {
                                                    // Store the incoming value into the array and then write it in the mempool.
                                                    //printf("WROTE\t%d\t%d\n",output_offset,bytesu8[k]);
                                                    *((uint16_t*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                                    mp_req2.request_type = WRITE;
                                                    mp_req2.arguments[0] = elements_to_write;
                                                    mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                    /*for(p=0;p<elements_to_write;p++)
                                                        printf("WRITING VALUE:0X%"PRIx64"\n",mp_req2.write_data[p]);*/
                                                    memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                    if (mp_resp2.status != OK)
                                                    {
                                                        fprintf(stderr,"WRITE FAILURE.\n");
                                                        flag = flag || 1;
                                                    }
                                                    else
                                                    {
                                                        fprintf(stderr,"SUCCESS: Wrote depadded tensor.\n");
                                                        output_words_left-= elements_to_write;
                                                        for(i=0;i<1024;i++)
                                                            *((uint64_t*)array + i) = 0;
                                                    }
                                                    if(output_offset == num_elems_output)
                                                        break;
                                                }
                                        }
                
                                        else
                                        {
                                            //printf("WROTE\t%d\t%d\n",output_offset,bytesu8[k]);
                                            *((uint16_t*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                        }
                                    }
                                    }
                                    else
                                    {
                                        //printf("NEGATIVE\n");
                                    }
                                }
                                break;
                            }

                    case u32:{
                                uint8_t g=0;uint32_t bytesu8[2];
                                for(k=0;k<2;k++)
                                    bytesu8[k] = 0;
                                do bytesu8[g++]= v & 0xFFFFFFFF; while (v>>=32);
                                g=0;

                                for(k=0;k<8/datasize;k++)
                                {
                                    count++;
                                    check_depad = checkPadding(count,&td_input,&td_output,padding);
                                    if(check_depad >0)
                                    {
                                        ++output_offset;
                                        if(output_offset<num_elems_output)
                                        {
                                            //printf("%d,%u\n",output_offset,bytesu8[k]);
                                            int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                            if(output_offset/iter_write >= elements_to_write*8/datasize || (output_offset == num_elems_output-1))
                                            {
                                                if(output_offset/iter_write > elements_to_write*8/datasize)
                                                {
                                                    // Write the array back to mempool, intialise it and then write the incoming value.
                                                    mp_req2.request_type = WRITE;
                                                    mp_req2.arguments[0] = elements_to_write;
                                                    mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                    memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                    if(mp_resp2.status != OK)
                                                    {
                                                        fprintf(stderr,"WRITE FAILURE.");
                                                        flag = flag || 1;
                                                    }
                                                    else
                                                    {
                                                        fprintf(stderr,"SUCCESS: Wrote depadded tensor.\n");
                                                        output_words_left-= elements_to_write;
                                                        for(i=0;i<1024*8/datasize;i++)
                                                            *((uint32_t*)mp_req2.write_data + i) = 0;
                                                        *((uint32_t*)array + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                                    }
                                                }
                                                else
                                                {
                                                    // Store the incoming value into the array and then write it in the mempool.
                                                    //printf("WROTE\t%d\t%d\n",output_offset,bytesu8[k]);
                                                    *((uint32_t*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                                    mp_req2.request_type = WRITE;
                                                    mp_req2.arguments[0] = elements_to_write;
                                                    mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                    /*for(p=0;p<elements_to_write;p++)
                                                        printf("WRITING VALUE:0X%"PRIx64"\n",mp_req2.write_data[p]);*/
                                                    memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                    if (mp_resp2.status != OK)
                                                    {
                                                        fprintf(stderr,"WRITE FAILURE.\n");
                                                        flag = flag || 1;
                                                    }
                                                    else
                                                    {
                                                        fprintf(stderr,"SUCCESS: Wrote depadded tensor.\n");
                                                        output_words_left-= elements_to_write;
                                                        for(i=0;i<1024;i++)
                                                            *((uint64_t*)array + i) = 0;
                                                    }
                                                    if(output_offset == num_elems_output)
                                                        break;
                                                }
                                            }
                
                                            else
                                            {
                                                //printf("WROTE\t%d\t%d\n",output_offset,bytesu8[k]);
                                                *((uint32_t*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                            }
                                        }
                                    }
                                    else
                                    {
                                        //printf("NEGATIVE\n");
                                    }
                                }
                                break;
                            }     
                    case u64:{
                                break;
                            }
                    
                    case i8:{
                                break;
                            }
                    case i16:{
                                break;
                            }
                    case i32:{  
                                break;
                            }
                    case i64:{
                                break;
                            }
                    case float8:{break;}
                    case float16:{break;}
                    case float32:{
                                    uint8_t g=0; float bytesu8[2];
                                    for(k=0;k<2;k++)
                                        bytesu8[k] = 0;
                                    do bytesu8[g++]= v & 0xFFFFFFFF; while (v>>=32);
                                    g=0;

                                    for(k=0;k<8/datasize;k++)
                                    {
                                        count++;
                                        check_depad = checkPadding(count,&td_input,&td_output,padding);
                                        if(check_depad >0)
                                        {
                                            ++output_offset;
                                            if(output_offset<num_elems_output)
                                            {
                                                //printf("%d,%u\n",output_offset,bytesu8[k]);
                                                int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                                if(output_offset/iter_write >= elements_to_write*8/datasize || (output_offset == num_elems_output-1))
                                                {
                                                    if(output_offset/iter_write > elements_to_write*8/datasize)
                                                    {
                                                        // Write the array back to mempool, intialise it and then write the incoming value.
                                                        mp_req2.request_type = WRITE;
                                                        mp_req2.arguments[0] = elements_to_write;
                                                        mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                        memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                        if(mp_resp2.status != OK)
                                                        {
                                                            fprintf(stderr,"WRITE FAILURE.");
                                                            flag = flag || 1;
                                                        }
                                                        else
                                                        {
                                                            fprintf(stderr,"SUCCESS: Wrote depadded tensor.\n");
                                                            output_words_left-= elements_to_write;
                                                            for(i=0;i<1024*8/datasize;i++)
                                                                *((float*)mp_req2.write_data + i) = 0;
                                                            *((float*)array + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                                        }
                                                    }
                                                    else
                                                    {
                                                        // Store the incoming value into the array and then write it in the mempool.
                                                        //printf("WROTE\t%d\t%d\n",output_offset,bytesu8[k]);
                                                        *((float*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                                        mp_req2.request_type = WRITE;
                                                        mp_req2.arguments[0] = elements_to_write;
                                                        mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                        /*for(p=0;p<elements_to_write;p++)
                                                            printf("WRITING VALUE:0X%"PRIx64"\n",mp_req2.write_data[p]);*/
                                                        memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                        if (mp_resp2.status != OK)
                                                        {
                                                            fprintf(stderr,"WRITE FAILURE.\n");
                                                            flag = flag || 1;
                                                        }
                                                        else
                                                        {
                                                            fprintf(stderr,"SUCCESS: Wrote depadded tensor.\n");
                                                            output_words_left-= elements_to_write;
                                                            for(i=0;i<1024;i++)
                                                                *((uint64_t*)array + i) = 0;
                                                        }
                                                        if(output_offset == num_elems_output)
                                                            break;
                                                    }
                                                }
                                                else
                                                {
                                                    //printf("WROTE\t%d\t%d\n",output_offset,bytesu8[k]);
                                                    *((float*)mp_req2.write_data + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                                }
                                            }
                                        }
                                        else
                                        {
                                            //printf("NEGATIVE\n");
                                        }
                                    }
                                    break;
                                }   
                    case float64:{
                                    break;
                                }
                }
            }  
        }
        return flag;

}