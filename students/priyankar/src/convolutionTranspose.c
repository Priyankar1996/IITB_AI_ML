#include "convolutionTranspose.h"
#include <inttypes.h>
uint32_t computeDilatedTensorOffset(uint32_t offset, TensorDescriptor *td_in,
                                    TensorDescriptor *td_out, uint32_t *k_dims, 
                                    uint32_t *stride, uint32_t padding)
{
    int i,p; uint32_t indices[3],output_indices[3],output_offset = 0;

    for(p=td_in->number_of_dimensions-2;p>=0;p--) // Change 2 to 1 while handling 3-channels.
    {
        indices[p] = ((offset % td_in->dimensions[p])? (offset % td_in->dimensions[p]):td_in->dimensions[p])-1;
        offset = CEILING(offset,td_in->dimensions[p]);
    }
    indices[td_in->number_of_dimensions-1] = td_in->dimensions[td_in->number_of_dimensions-1]-1;
    for(i = 0;i < td_in->number_of_dimensions-1;i++)
    {
        indices[i] = indices[i] * stride[i] + k_dims[i] -1 - padding; 
    }
    indices[td_in->number_of_dimensions-1] = td_in->dimensions[td_in->number_of_dimensions-1]-1;
    output_offset = getTensorEntryIndexOffset(td_out,indices);
    return output_offset;
}

int convTranspose(Tensor *input, Tensor *kernel,Tensor *intermediate, uint32_t *stride, 
                  uint32_t *output_padding, uint32_t padding,Tensor *output)
{
    MemPoolRequest mp_req1,mp_req2;
    MemPoolResponse mp_resp1,mp_resp2;

    uint32_t datasize = sizeofTensorDataInBytes(input->descriptor.data_type);
    uint32_t i,w,p,y,num_elems_input = 1,num_elems_intermediate = 1, flag = 0,k, count = 0, output_offset = 0, iter_write = 1;
    uint32_t tensor_pos_in_pool = 0, SCALE_FACTOR = 1;
    uint32_t indices[3] = {3.3,1};
    uint32_t *index;
    index = indices;
    num_elems_input = numberOfElementsInTensor(input);
    num_elems_intermediate = numberOfElementsInTensor(intermediate);


    int iter = -1;
    int input_words_left = CEILING(num_elems_input*datasize,8);
    int intermediate_words_left = CEILING(num_elems_intermediate*datasize,8);
    void *array;
    array = mp_req2.write_data;
    for(i=0;i<1024;i++)
        *((uint64_t*)array + i) = 0;
    
    for(; input_words_left > 0; input_words_left -=MAX_SIZE_OF_REQUEST_IN_WORDS)
    {
        iter ++;
        int elements_to_read = MIN(input_words_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
        
        mp_req1.request_type = READ;
        mp_req1.arguments[0] = elements_to_read;
        mp_req1.arguments[1] = input->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
        mp_req1.arguments[2] = 1;

        memPoolAccess((MemPool *)(input->mem_pool_identifier),&mp_req1,&mp_resp1);
        if(mp_resp1.status != OK)
        {
            fprintf(stderr,"READ UNSUCCESSFUL\n");
            flag = flag || 1;
        }
        else
            fprintf(stderr,"READ SUCCESSFULL\n");
        //Extracts elements from words
        for(i=0;i<elements_to_read;i++)
        {
            uint64_t v= mp_resp1.read_data[i];
            switch (input->descriptor.data_type)
            {
                case u8: {
                            printf("READ VALUE:0X%"PRIx64"\n",mp_resp1.read_data[i]);
                            uint8_t g,bytesu8[8]={0};
                            do bytesu8[g++]=v&0xFF; while (v>>=8);
                            
                            //uint8_t (*bytesu8)[8] = (void *) &mp_resp1.read_data[i];
                            for(k=0;k<8;k++)
                            {
                                count++;
                                // Computes the dilated position of an element in a tensor.
                                if(count<=num_elems_input)
                                {
                                    output_offset = computeDilatedTensorOffset(count,&input->descriptor,&intermediate->descriptor,
                                                                kernel->descriptor.dimensions,stride,padding);
                                    printf("OFFSET:%u\n",output_offset);
                                    int elements_to_write = MIN(MAX_SIZE_OF_REQUEST_IN_WORDS,intermediate_words_left);
                                    if(output_offset/iter_write >= elements_to_write*8/datasize || (count == num_elems_input))
                                    {
                                        if(output_offset/iter_write > elements_to_write*8/datasize)
                                        {
                                            // Write the array back to mempool, intialise it and then write the incoming value.
                                            mp_req2.request_type = WRITE;
                                            mp_req2.arguments[0] = elements_to_write;
                                            mp_req2.arguments[1] = intermediate->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                            memPoolAccess((MemPool*)intermediate->mem_pool_identifier,&mp_req2,&mp_resp2);
                                            if(mp_resp2.status != OK)
                                            {
                                                fprintf(stderr,"WRITE FAILURE.");
                                                flag = flag || 1;
                                            }
                                            else
                                            {
                                                fprintf(stderr,"WRITE SUCCESSFULL.");
                                                intermediate_words_left-= elements_to_write;
                                                for(i=0;i<1024;i++)
                                                    *((uint64_t*)array + i) = 0;
                                                *((uint8_t*)array + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8)) = bytesu8[k];
                                            }
                                        }
                                        else
                                        {
                                            // Store the incoming value into the array and then write it in the mempool.
                                            *((uint8_t*)array + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8)) = bytesu8[k];
                                            mp_req2.request_type = WRITE;
                                            mp_req2.arguments[0] = elements_to_write;
                                            mp_req2.arguments[1] = intermediate->mem_pool_buffer_pointer + MAX_SIZE_OF_REQUEST_IN_WORDS*(iter_write++ - 1);
                                            memPoolAccess((MemPool*)intermediate->mem_pool_identifier,&mp_req2,&mp_resp2);
                                            if (mp_resp2.status != OK)
                                            {
                                                fprintf(stderr,"WRITE FAILURE.\n");
                                                flag = flag || 1;
                                            }
                                            else
                                            {
                                                fprintf(stderr,"WRITE SUCCESSFULL.\n");
                                                intermediate_words_left-= elements_to_write;
                                                for(i=0;i<1024;i++)
                                                    *((uint64_t*)array + i) = 0;
                                            }
                                        }
                                    }
                                    else
                                        *((uint8_t*)array + output_offset%(MAX_SIZE_OF_REQUEST_IN_WORDS*8/datasize)) = bytesu8[k];
                                }
                            }
                            break;
                        }    

                case u16:{
                            uint16_t (*bytesu16)[4] = (void *) &mp_resp1.read_data[i];
                            break;
                        }
                    
                case u32:{
                            uint32_t (*bytesu32)[2] = (void*) &mp_resp1.read_data[i];
                            break;
                        }
                    
                case u64:{
                            break;
                        }
                    
                case i8:{
                            int8_t (*bytes8)[8] = (void*) &mp_resp1.read_data[i];
                            break;
                        }
            
                case i16:{
                            int16_t (*bytes16)[4] = (void*) &mp_resp1.read_data[i];
                            break;
                        }

                case i32:{
                            int32_t (*bytes32)[2] = (void*) &mp_resp1.read_data[i];
                            break;
                        }
                    
                case i64: {
                                break;
                        }
                    //case float8:
                    //case float16:
                case float32:{
                                float (*bytes32)[2] = (void*) &mp_resp1.read_data[i];
                                break;
                            }

                case float64:{
                                double *dvalue = (void*) &mp_resp1.read_data[i];
                                break;
                            }
            default:
                break;
            }

        }
    }
    // Convolve the intermediate tensor with the kernel
    uint32_t stride_conv[2] = {1,1};
    /*switch (output->descriptor.data_type)
    {
    case u8: flag = flag || convTensors(intermediate,kernel,output,stride_conv,output_padding); 
        break;
    
    default:
        break;
    }*/
    return flag;
}