#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <inttypes.h>
#include "tensor.h"
#include "mempool.h"
#include "createTensor.h"
#include "convolutionTranspose.h"

void updateOutputSDescriptorDilateTensors(Tensor *src, Tensor *kernel, 
                                          uint32_t *stride, Tensor *output)
{
    TensorDescriptor* td_src = &(src->descriptor);
    TensorDescriptor* td_kernel = &(kernel->descriptor);
    TensorDescriptor* td_output = &(output->descriptor);

    td_output->data_type = td_src->data_type;
    td_output->number_of_dimensions = td_src->number_of_dimensions;
    td_output->row_major_form = td_src->row_major_form;

    for(int i=0;i<td_output->number_of_dimensions-1;i++)
        td_output->dimensions[i] = (td_src->dimensions[i])*stride[i] + td_kernel->dimensions[i+1] - 1;
    td_output->dimensions[td_output->number_of_dimensions-1] = td_src->dimensions[td_src->number_of_dimensions-1];

}

void updateOutputSDescriptorDepadTensors(Tensor *src, uint32_t padding, Tensor *output)
{
    TensorDescriptor* td_src = &(src->descriptor);
    TensorDescriptor* td_output = &(output->descriptor);

    td_output->data_type = td_src->data_type;
    td_output->number_of_dimensions = td_src->number_of_dimensions;
    td_output->row_major_form = td_src->row_major_form;

    for(int i=0;i<td_output->number_of_dimensions-1;i++)
    {
        td_output->dimensions[i] = td_src->dimensions[i] - (2*padding);
    }
    td_output->dimensions[td_output->number_of_dimensions-1] = td_src->dimensions[td_src->number_of_dimensions-1];
}

uint32_t computeDilatedTensorOffset(uint32_t offset, TensorDescriptor *td_in,
                                    TensorDescriptor *td_out, TensorDescriptor *td_k, 
                                    uint32_t *stride)
{
    int i,p; uint32_t indices[3],output_indices[3],output_offset = 0;

    for(p=td_in->number_of_dimensions-1;p>=0;p--) // Change 2 to 1 while handling 3-channels.
    {
        indices[p] = ((offset % td_in->dimensions[p])? (offset % td_in->dimensions[p]):td_in->dimensions[p])-1;
        offset = CEILING(offset,td_in->dimensions[p]);
    }
    //indices[td_in->number_of_dimensions-1] = td_in->dimensions[td_in->number_of_dimensions-1]-1;
    
    //for(i=0;i< td_in->number_of_dimensions;i++)
    //    printf("%d ",indices[i]);
    //printf("\t");
    
    for(i = 0;i < td_out->number_of_dimensions-1;i++)
    {
        //printf("I:%d,S:%d,K:%d\t",indices[i],stride[i],td_k->dimensions[i]);
        output_indices[i] = indices[i] * stride[i] + td_k->dimensions[i+1] -1; // - padding
    }
    output_indices[td_out->number_of_dimensions-1] = indices[td_out->number_of_dimensions-1];
    
    //for(i=0;i< td_out->number_of_dimensions;i++)
    //    printf("%d ",output_indices[i]);
    //printf("\n");
    
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
    //indices[td_in->number_of_dimensions-1] = td_in->dimensions[td_in->number_of_dimensions-1]-1;
    
    //for(i=0;i< td_in->number_of_dimensions;i++)
    //    printf("%d ",indices[i]);
    //printf("\t\t");
    
    for(i = 0;i < td_out->number_of_dimensions-1;i++)
    {
        output_indices[i] = indices[i] - padding;
    }
    output_indices[td_out->number_of_dimensions-1] = indices[td_out->number_of_dimensions-1];
    
    //for(i=0;i< td_out->number_of_dimensions;i++)
    //    printf("%d ",output_indices[i]);
    //printf("\t");
    
    for(i=0;i< td_out->number_of_dimensions-1;i++)
    {
        if(output_indices[i] < 0 || output_indices[i] >= td_out->dimensions[i])
        //if ((output_indices[i] < 0) || ((output_indices[i] == (td_in->dimensions[i] - padding - 1) && padding !=0)))
            flag = 1;
    }

    output_offset = flag ? -1 : 1;
    //printf("\t%d",output_offset);
    //printf("\t\t\n");
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
    for(i=0;i<1024;i++)
        *((uint64_t*)mp_req2.write_data + i) = 0;
    printf("Input Words:%d\n",input_words_left);
    for(; input_words_left > 0; input_words_left -= MAX_SIZE_OF_REQUEST_IN_WORDS)
    {
        iter++;
        int elements_to_read = MIN(input_words_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
        printf("Elements to read:%d\n",elements_to_read);
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
                                 uint8_t (*bytes32)[8] = ((void*)&v);
                                for(k=0;k<8/datasize;k++)
                                {
                                    count++;
                                    output_offset = computeDilatedTensorOffset(count,&td_input,&td_output,&td_kernel,stride);
                                    if(count<=num_elems_input)
                                    {
                                        int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                        uint32_t position, iter_value;
                                        position = output_offset % (MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize);
                                        iter_value = CEILING(output_offset ,(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
                                        if(iter_value == iter_write)
                                        {
                                            *((uint8_t*)array + position) = (*bytes32)[k]; 
                                            if(count == num_elems_input)
                                            {
                                                mp_req2.request_type = WRITE;
                                                mp_req2.arguments[0] = elements_to_write;
                                                mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                output_words_left-=elements_to_write;
                                                printf("WROTE AND DILATE COMPLETE\n");
                                            }
                                        }
                                        else if(iter_value > iter_write)
                                        {
                                                        //Write into mempool and then store.
                                            printf("WROTE DILATED INTO MEMPOOL\n");
                                            mp_req2.request_type = WRITE;
                                            mp_req2.arguments[0] = elements_to_write;
                                            mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                            memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                            output_words_left-=elements_to_write;
                                            for(int ii=0;ii<1024*8/datasize;ii++)
                                                *((uint8_t*)mp_req2.write_data + ii) = 0;
                                            *((uint8_t*)array + position) = (*bytes32)[k];
                                        }
                                        //printf("Input_size:%d, Count:%d, Output Offset:%d, Iter_value:%d, Iter_Write:%d, Position:%d\n",num_elems_input,count,output_offset,iter_value,iter_write,output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
                                    }
                                }
                                break;
                            }
                                
                    case u16:{
                                uint16_t (*bytes32)[4] = ((void*)&v);
                                for(k=0;k<8/datasize;k++)
                                {
                                    count++;
                                    output_offset = computeDilatedTensorOffset(count,&td_input,&td_output,&td_kernel,stride);
                                    if(count<=num_elems_input)
                                    {
                                        int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                        uint32_t position, iter_value;
                                        position = output_offset % (MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize);
                                        iter_value = CEILING(output_offset ,(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
                                        if(iter_value == iter_write)
                                        {
                                            *((uint16_t*)array + position) = (*bytes32)[k]; 
                                            if(count == num_elems_input)
                                            {
                                                mp_req2.request_type = WRITE;
                                                mp_req2.arguments[0] = elements_to_write;
                                                mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                output_words_left-=elements_to_write;
                                                printf("WROTE AND DILATE COMPLETE\n");
                                            }
                                        }
                                        else if(iter_value > iter_write)
                                        {
                                                        //Write into mempool and then store.
                                            printf("WROTE DILATED INTO MEMPOOL\n");
                                            mp_req2.request_type = WRITE;
                                            mp_req2.arguments[0] = elements_to_write;
                                            mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                            memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                            output_words_left-=elements_to_write;
                                            for(int ii=0;ii<1024*8/datasize;ii++)
                                                *((uint16_t*)mp_req2.write_data + ii) = 0;
                                            *((uint16_t*)array + position) = (*bytes32)[k];
                                        }
                                        //printf("Input_size:%d, Count:%d, Output Offset:%d, Iter_value:%d, Iter_Write:%d, Position:%d\n",num_elems_input,count,output_offset,iter_value,iter_write,output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
                                    }
                                }
                                break;
                            }
                            
                    case u32:{
                                uint32_t (*bytes32)[2] = ((void*)&v);
                                for(k=0;k<8/datasize;k++)
                                {
                                    count++;
                                    output_offset = computeDilatedTensorOffset(count,&td_input,&td_output,&td_kernel,stride);
                                    if(count<=num_elems_input)
                                    {
                                        int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                        uint32_t position, iter_value;
                                        position = output_offset % (MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize);
                                        iter_value = CEILING(output_offset ,(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
                                        if(iter_value == iter_write)
                                        {
                                            *((uint32_t*)array + position) = (*bytes32)[k]; 
                                            if(count == num_elems_input)
                                            {
                                                mp_req2.request_type = WRITE;
                                                mp_req2.arguments[0] = elements_to_write;
                                                mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                output_words_left-=elements_to_write;
                                                //printf("WROTE AND DILATE COMPLETE\n");
                                            }
                                        }
                                        else if(iter_value > iter_write)
                                        {
                                            //Write into mempool and then store.
                                            printf("WROTE DILATED INTO MEMPOOL\n");
                                            mp_req2.request_type = WRITE;
                                            mp_req2.arguments[0] = elements_to_write;
                                            mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                            memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                            output_words_left-=elements_to_write;
                                            for(int ii=0;ii<1024*8/datasize;ii++)
                                                *((uint32_t*)mp_req2.write_data + ii) = 0;
                                            *((uint32_t*)array + position) = (*bytes32)[k];
                                        }
                                        //printf("Input_size:%d, Count:%d, Output Offset:%d, Iter_value:%d, Iter_Write:%d, Position:%d\n",num_elems_input,count,output_offset,iter_value,iter_write,output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
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
                                            float (*bytes32)[2] = ((void*)&v);
                                            for(k=0;k<8/datasize;k++)
                                            {
                                                count++;
                                                output_offset = computeDilatedTensorOffset(count,&td_input,&td_output,&td_kernel,stride);
                                                if(count<=num_elems_input)
                                                {
                                                    int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                                    uint32_t position, iter_value;
                                                    position = output_offset % (MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize);
                                                    iter_value = CEILING(output_offset ,(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
                                                    if(iter_value == iter_write)
                                                    {
                                                        *((float*)array + position) = (*bytes32)[k]; 
                                                        if(count == num_elems_input)
                                                        {
                                                            mp_req2.request_type = WRITE;
                                                            mp_req2.arguments[0] = elements_to_write;
                                                            mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                            memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                            output_words_left-=elements_to_write;
                                                            printf("WROTE AND DILATE COMPLETE\n");
                                                        }
                                                    }
                                                    else if(iter_value > iter_write)
                                                    {
                                                        //Write into mempool and then store.
                                                        printf("WROTE DILATED INTO MEMPOOL\n");
                                                        mp_req2.request_type = WRITE;
                                                        mp_req2.arguments[0] = elements_to_write;
                                                        mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                        memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                        output_words_left-=elements_to_write;
                                                        for(int ii=0;ii<1024*8/datasize;ii++)
                                                            *((float*)mp_req2.write_data + ii) = 0;
                                                        *((float*)array + position) = (*bytes32)[k];
                                                    }
                                                    //printf("Input_size:%d, Count:%d, Output Offset:%d, Iter_value:%d, Iter_Write:%d, Position:%d\n",num_elems_input,count,output_offset,iter_value,iter_write,output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
                                                }
                                            }

                                            break;
                                        }
                            case float64:{
                                            double (*bytes32)[1] = ((void*)&v);
                                            for(k=0;k<8/datasize;k++)
                                            {
                                                count++;
                                                output_offset = computeDilatedTensorOffset(count,&td_input,&td_output,&td_kernel,stride);
                                                if(count<=num_elems_input)
                                                {
                                                    int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                                    uint32_t position, iter_value;
                                                    position = output_offset % (MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize);
                                                    iter_value = CEILING(output_offset ,(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
                                                    if(iter_value == iter_write)
                                                    {
                                                        *((double*)array + position) = (*bytes32)[k]; 
                                                        if(count == num_elems_input)
                                                        {
                                                            mp_req2.request_type = WRITE;
                                                            mp_req2.arguments[0] = elements_to_write;
                                                            mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                            memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                            output_words_left-=elements_to_write;
                                                            printf("WROTE AND DILATE COMPLETE\n");
                                                        }
                                                    }
                                                    else if(iter_value > iter_write)
                                                    {
                                                        //Write into mempool and then store.
                                                        //printf("WROTE DILATED INTO MEMPOOL\n");
                                                        mp_req2.request_type = WRITE;
                                                        mp_req2.arguments[0] = elements_to_write;
                                                        mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                        memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                        output_words_left-=elements_to_write;
                                                        for(int ii=0;ii<1024*8/datasize;ii++)
                                                            *((double*)mp_req2.write_data + ii) = 0;
                                                        *((double*)array + position) = (*bytes32)[k];
                                                    }
                                                    //printf("Input_size:%d, Count:%d, Output Offset:%d, Iter_value:%d, Iter_Write:%d, Position:%d\n",num_elems_input,count,output_offset,iter_value,iter_write,output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
                                                }
                                            }

                                    break;
                               }
            }
                                            
        }
        //return flag;
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
                                uint8_t (*bytes8)[8] = ((void*)&v);
                                for(k=0;k<8/datasize;k++)
                                {
                                    count++;
                                    check_depad = checkPadding(count,&td_input,&td_output,padding);
                                    if(check_depad >0)
                                    {
                                        ++output_offset;
                                        int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                        uint32_t position, iter_value;
                                        position = output_offset % (MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize);
                                        iter_value = CEILING(output_offset ,(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
                                        if(iter_value == iter_write)
                                        {
                                            *((uint8_t*)array + position) = (*bytes8)[k]; 
                                            if(count == num_elems_output)
                                            {
                                                mp_req2.request_type = WRITE;
                                                mp_req2.arguments[0] = elements_to_write;
                                                mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                output_words_left-=elements_to_write;
                                            }
                                        }
                                        else if(iter_value > iter_write)
                                        {
                                            //Write into mempool and then store.
                                            //printf("WROTE DILATED INTO MEMPOOL\n");
                                            mp_req2.request_type = WRITE;
                                            mp_req2.arguments[0] = elements_to_write;
                                            mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                            memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                            output_words_left-=elements_to_write;
                                            for(int ii=0;ii<1024*8/datasize;ii++)
                                                *((uint8_t*)mp_req2.write_data + ii) = 0;
                                            *((uint8_t*)array + position) = (*bytes8)[k];
                                        }
                                        //printf("Input_size:%d, Count:%d, Output Offset:%d, Iter_value:%d, Iter_Write:%d, Position:%d\n",num_elems_input,count,output_offset,iter_value,iter_write,output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
                                    }
                                }
                                break;
                            }

                    case u16:{
                                    uint16_t (*bytes8)[4] = ((void*)&v);
                                    for(k=0;k<8/datasize;k++)
                                    {
                                        count++;
                                        check_depad = checkPadding(count,&td_input,&td_output,padding);
                                        if(check_depad >0)
                                        {
                                            ++output_offset;
                                            //printf("Output Offset:%d,Value:%f\n",output_offset,(*bytes8)[k]);
                                            int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                            uint32_t position, iter_value;
                                            position = output_offset % (MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize);
                                            iter_value = output_offset ? CEILING(output_offset ,(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)): 1;
                                            if(iter_value == iter_write)
                                            {
                                               
                                                *((uint16_t*)array + position) = (*bytes8)[k]; 
                                                if(output_offset == num_elems_output-1)
                                                {
                                                    //printf("WRITE SUCCESSFUL\n");
                                                    mp_req2.request_type = WRITE;
                                                    mp_req2.arguments[0] = elements_to_write;
                                                    mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                    memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                    output_words_left-=elements_to_write;
                                                }
                                            }
                                            else if(iter_value > iter_write)
                                            {
                                                //Write into mempool and then store.
                                                //printf("WROTE DILATED INTO MEMPOOL\n");
                                                mp_req2.request_type = WRITE;
                                                mp_req2.arguments[0] = elements_to_write;
                                                mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                output_words_left-=elements_to_write;
                                                for(int ii=0;ii<1024*8/datasize;ii++)
                                                    *((uint16_t*)mp_req2.write_data + ii) = 0;
                                                *((uint16_t*)array + position) = (*bytes8)[k];
                                            }
                                            //printf("Input_size:%d, Count:%d, Output Offset:%d, Iter_value:%d, Iter_Write:%d, Position:%d\n",num_elems_input,count,output_offset,iter_value,iter_write,output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
                                        }
                                    }
                                    break;
                                }
                    case u32:{
                                    uint32_t (*bytes8)[2] = ((void*)&v);
                                    for(k=0;k<8/datasize;k++)
                                    {
                                        count++;
                                        check_depad = checkPadding(count,&td_input,&td_output,padding);
                                        if(check_depad >0)
                                        {
                                            ++output_offset;
                                            //printf("Output Offset:%d,Value:%f\n",output_offset,(*bytes8)[k]);
                                            int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                            uint32_t position, iter_value;
                                            position = output_offset % (MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize);
                                            iter_value = output_offset ? CEILING(output_offset ,(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)): 1;
                                            if(iter_value == iter_write)
                                            {
                                                
                                                *((uint32_t*)array + position) = (*bytes8)[k]; 
                                                if(output_offset == num_elems_output-1)
                                                {
                                                    printf("SUCCESS: WRITE SUCCESSFUL\n");
                                                    mp_req2.request_type = WRITE;
                                                    mp_req2.arguments[0] = elements_to_write;
                                                    mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                    memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                    output_words_left-=elements_to_write;
                                                }
                                            }
                                            else if(iter_value > iter_write)
                                            {
                                                //Write into mempool and then store.
                                                //printf("WROTE DILATED INTO MEMPOOL\n");
                                                mp_req2.request_type = WRITE;
                                                mp_req2.arguments[0] = elements_to_write;
                                                mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                output_words_left-=elements_to_write;
                                                for(int ii=0;ii<1024*8/datasize;ii++)
                                                    *((uint32_t*)mp_req2.write_data + ii) = 0;
                                                *((uint32_t*)array + position) = (*bytes8)[k];
                                            }
                                            //printf("Input_size:%d, Count:%d, Output Offset:%d, Iter_value:%d, Iter_Write:%d, Position:%d\n",num_elems_input,count,output_offset,iter_value,iter_write,output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
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
                                    float (*bytes8)[2] = ((void*)&v);
                                    for(k=0;k<8/datasize;k++)
                                    {
                                        count++;
                                        check_depad = checkPadding(count,&td_input,&td_output,padding);
                                        if(check_depad >0)
                                        {
                                            ++output_offset;
                                            //printf("Output Offset:%d,Value:%f\n",output_offset,(*bytes8)[k]);
                                            int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,output_words_left);
                                            uint32_t position, iter_value;
                                            position = output_offset % (MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize);
                                            iter_value = output_offset ? CEILING(output_offset ,(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)): 1;
                                            if(iter_value == iter_write)
                                            {
                                                
                                                *((float*)array + position) = (*bytes8)[k]; 
                                                if(output_offset == num_elems_output-1)
                                                {
                                                    printf("SUCCESS: WRITE SUCCESSFUL\n");
                                                    mp_req2.request_type = WRITE;
                                                    mp_req2.arguments[0] = elements_to_write;
                                                    mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                    memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                    output_words_left-=elements_to_write;
                                                }
                                            }
                                            else if(iter_value > iter_write)
                                            {
                                                //Write into mempool and then store.
                                                //printf("WROTE DILATED INTO MEMPOOL\n");
                                                mp_req2.request_type = WRITE;
                                                mp_req2.arguments[0] = elements_to_write;
                                                mp_req2.arguments[1] = output->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                                memPoolAccess((MemPool*)output->mem_pool_identifier,&mp_req2,&mp_resp2);
                                                output_words_left-=elements_to_write;
                                                for(int ii=0;ii<1024*8/datasize;ii++)
                                                    *((float*)mp_req2.write_data + ii) = 0;
                                                *((float*)array + position) = (*bytes8)[k];
                                            }
                                            //printf("Input_size:%d, Count:%d, Output Offset:%d, Iter_value:%d, Iter_Write:%d, Position:%d\n",num_elems_input,count,output_offset,iter_value,iter_write,output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize));
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