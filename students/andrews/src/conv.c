#include "../include/conv.h"

void convHelper(const int64_t *ker_data, const int64_t *img_data, 
                const TensorDataType dtype,
                const int32_t *ker_start_ds_offset, 
				const int32_t *img_start_ds_offset, 
                const uint32_t *num_ele_to_operate,
                union ConvResult *res){
    switch (dtype)
    {
        case u8: 
            for(int i = 0; i < *num_ele_to_operate; i++){
                res->res_u8 += *((uint8_t*)ker_data+*ker_start_ds_offset+i)
                    * *((uint8_t*)img_data+*img_start_ds_offset+i);
            }
            break;

        case u16: 
        	for(int i = 0; i < *num_ele_to_operate; i++){
                res->res_u16 += *((uint16_t*)ker_data+*ker_start_ds_offset+i)
                    * *((uint16_t*)img_data+*img_start_ds_offset+i);
            }
            break;
            
        case u32: 
        	for(int i = 0; i < *num_ele_to_operate; i++){
                res->res_u32 += *((uint32_t*)ker_data+*ker_start_ds_offset+i)
                    * *((uint32_t*)img_data+*img_start_ds_offset+i);
            }
            break;
            
        case u64: 
        	for(int i = 0; i < *num_ele_to_operate; i++){
                res->res_u64 += *(ker_data+*ker_start_ds_offset+i)
                    * *(img_data+*img_start_ds_offset+i);
            }
            break;
            

        case i8:
        	for(int i = 0; i < *num_ele_to_operate; i++){
                res->res_i8 += *((int8_t*)ker_data+*ker_start_ds_offset+i)
                    * *((int8_t*)img_data+*img_start_ds_offset+i);
            }
            break;
            
        case i16: 
        	for(int i = 0; i < *num_ele_to_operate; i++){
                res->res_i16 += *((int16_t*)ker_data+*ker_start_ds_offset+i)
                    * *((int16_t*)img_data+*img_start_ds_offset+i);
            }
            break;
            
        case i64: 
        	for(int i = 0; i < *num_ele_to_operate; i++){
                res->res_i64 += *((int64_t*)ker_data+*ker_start_ds_offset+i)
                    * *((int64_t*)img_data+*img_start_ds_offset+i);
            }
            break;
            
        case i32: 
        	for(int i = 0; i < *num_ele_to_operate; i++){
                res->res_i32 += *((int32_t*)ker_data+*ker_start_ds_offset+i)
                    * *((int32_t*)img_data+*img_start_ds_offset+i);
            }
            break;
            
        
        // case f8:
        // for(int i = 0; i < *num_ele_to_operate; i++){
        //     res->res_u8 += *((uint8_t*)ker_data+*ker_start_ds_offset+i)
        //         * *((uint8_t*)img_data+*img_start_ds_offset+i);
        // }
        // break;
            
        // case f16: 
        // for(int i = 0; i < *num_ele_to_operate; i++){
        //     res->res_u8 += *((uint8_t*)ker_data+*ker_start_ds_offset+i)
        //         * *((uint8_t*)img_data+*img_start_ds_offset+i);
        // }
        // break;
            
        case float32: 
        	for(int i = 0; i < *num_ele_to_operate; i++){
                res->res_f32 += *((float*)ker_data+*ker_start_ds_offset+i)
                    * *((float*)img_data+*img_start_ds_offset+i);
            }
            break;
            
        case float64: 
        	for(int i = 0; i < *num_ele_to_operate; i++){
                res->res_f64 += *((double*)ker_data+*ker_start_ds_offset+i)
                    * *((double*)img_data+*img_start_ds_offset+i);
            }
            break;
        
        default:
            fprintf(stderr,"ERROR: CONV HELPER INPUTS DATATYPE NOT FOUND\n");
            break;
    }
}

int convTensors(Tensor *in_img, Tensor *kernel, Tensor *out_img, 
            const int stride[2], const int padding[4]){
    
    fprintf(stderr,"INSIDE CONV\n");
    
    MemPoolRequest reqKer, reqImg;
    MemPoolResponse respKer, respImg;

    TensorDescriptor td_in, td_ker, td_out;
    td_in = in_img->descriptor;
    td_ker = kernel->descriptor;

    /*
         Verify Input Constraints
    */
    if (td_in.row_major_form != td_ker.row_major_form){
        fprintf(stderr,"ERROR: INPUTS ROW/COL MAJOR MISMATCH\n");
        return -1;
    }
    if(td_in.data_type != td_ker.data_type){
        fprintf(stderr,"ERROR: INPUTS DATATYPE MISMATCH\n");
        return -1;
    }
    
    uint8_t is_row_major = td_in.row_major_form; 
    uint32_t in_H = td_in.dimensions[0];
    uint32_t in_W = td_in.dimensions[1];
    uint32_t in_C = td_in.dimensions[2];
    uint32_t ker_H = td_ker.dimensions[0];
    uint32_t ker_W = td_ker.dimensions[1];
    uint32_t out_H = (td_in.dimensions[0] + padding[0] + padding[1] 
                    - td_ker.dimensions[0])/stride[0] + 1;
    uint32_t out_W = (td_in.dimensions[1] + padding[2] + padding[3] 
                    - td_ker.dimensions[1])/stride[1] + 1;
    uint32_t out_C = 1; //td_ker.dimensions[td_ker.number_of_dimensions - 1];
    
    out_img->descriptor.row_major_form = is_row_major;
    out_img->descriptor.number_of_dimensions = 3;
    out_img->descriptor.data_type = td_in.data_type;
    out_img->descriptor.dimensions[0] = out_H;
    out_img->descriptor.dimensions[1] = out_W;
    out_img->descriptor.dimensions[2] = out_C;
    td_out = out_img->descriptor;
    
    int num_dim_ker = td_ker.number_of_dimensions;
    // int num_ele_per_filt_per_ch = td_ker.dimensions[0]*td_ker.dimensions[1];
    int num_ele_per_filt = td_ker.dimensions[0]*td_ker.dimensions[1]
                            *td_ker.dimensions[2];
    // for(int i = 2; i < num_dim_ker - 1; i++){
    //     num_ele_ker *= td_ker.dimensions[i];
    // }
    uint32_t data_size = sizeofTensorDataInBytes(td_in.data_type);

    int32_t ker_word_offset, img_word_offset;
    int32_t ker_start_ds_offset, img_start_ds_offset; //ds is data size
    union ConvResult res;
    uint32_t size_so_far; //in bytes
    uint64_t word_to_store;
    int ii, ij; //image coords

    if(td_in.row_major_form == 1){
        // for(int kc = 0; kc < out_C; kc++){
            size_so_far = 0;
            word_to_store = 0;
            for(int oi = 0; oi < out_H; oi++){
                for(int oj = 0; oj < out_C; oj++){
                    /*
                        output index i, j
                        => input window's top left position is:
                            i*SH, j*SW w/o padding
                        obtain o/p value at (i, j) ele by ele of kernel.
                    */
                    {
                        // switch (td_in.data_type)
                        // {
                        //     case u8: res.res_u8 = 0; break;
                        //     case u16: res.res_u16 = 0; break;
                        //     case u32: res.res_u32 = 0; break;
                        //     case u64: res.res_u64 = 0; break;

                        //     case i8: res.res_i8 = 0; break;
                        //     case i16: res.res_i16 = 0; break;
                        //     case i32: res.res_i32 = 0; break;
                        //     case i64: res.res_i64 = 0; break;
                            
                        //     // case f8: res.res_f8 = 0; break;
                        //     // case f16: res.res_f16 = 0; break;
                        //     case float32: res.res_f32 = 0; break;
                        //     case float64: res.res_f64 = 0; break;
                            
                        //     default:
                        //         fprintf(stderr,"ERROR: CONV INPUTS DATATYPE NOT FOUND\n");
                        //         return -1;
                        //         break;
                        // }
                    }
                    res.res_u64 = 0u;
                    for(int ki = 0; ki < ker_H; ki++){
                        for(int kj = 0; kj < ker_W; kj++){
                            reqKer.request_type = READ;
                            reqKer.request_tag = 1; //TODO check
                            reqKer.arguments[0] = CEILING(in_C * data_size, 8) + 1;
                                //read 1 extra word in case data we need is not word aligned
                            ker_word_offset = (ki * ker_W + kj) * in_C * data_size / 8;
                            reqKer.arguments[1] = kernel->mem_pool_buffer_pointer 
                                + ker_word_offset;
                            reqKer.arguments[2] = 1; // stride = 1 as pointwise
                            memPoolAccess((MemPool*)kernel->mem_pool_identifier,&reqKer,&respKer);
                            if(respKer.status == NOT_OK){
                                fprintf(stderr,"ERROR: Read Kernel Tensor Failed in Conv\n");
                                return -1;
                            }
                            ker_start_ds_offset = (ki * ker_W + kj) * in_C 
                                                    - 8 * ker_word_offset / data_size;
                            
                            ii = oi*stride[0], ij = oj*stride[1];
                            reqImg.request_type = READ;
                            reqImg.request_tag = 1; //TODO check
                            reqImg.arguments[0] = CEILING(in_C * data_size, 8) + 1;
                            img_word_offset = (ii * in_W + ij) * in_C * data_size / 8;
                            reqImg.arguments[1] = kernel->mem_pool_buffer_pointer 
                                + img_word_offset;
                            reqImg.arguments[2] = 1; // stride = 1 as pointwise
                            memPoolAccess((MemPool*)kernel->mem_pool_identifier,&reqImg,&respImg);
                            if(respImg.status == NOT_OK){
                                fprintf(stderr,"ERROR: Mempool Read Image Tensor Failed in Conv\n");
                                return -1;
                            }
                            img_start_ds_offset = (ii * in_W + ij) * in_C 
                                                    - 8 * img_word_offset / data_size;
                            convHelper(respKer.read_data, respImg.read_data,
                                td_ker.data_type, &ker_start_ds_offset, &img_start_ds_offset,
                                &in_C, &res
                            );
                        }//end kj
                    }//end ki
                    word_to_store |= (res.res_u64 << (size_so_far*8));
                    size_so_far += data_size;
                    if(size_so_far == MEMPOOL_WORD_SIZE){
                        //write word_to_store
                        reqImg.request_type = WRITE;
                        reqImg.arguments[0] = 1;
                        reqImg.arguments[1] = out_img->mem_pool_buffer_pointer +
                                                (oi * out_W + oj) * data_size / 8;
                        reqImg.write_data[0] = word_to_store;
                        memPoolAccess((MemPool*)out_img->mem_pool_identifier, &reqImg, &respImg);
                        if (respImg.status == NOT_OK){
                            fprintf(stderr,"ERROR: Mempool Write Image Tensor Failed in Conv\n");
                            return -1;
                        }
                        size_so_far = 0;
                    }
                }//end j loop
            }//end i loop
        // }//end kc loop
        if(size_so_far > 0){
            //write word_to_store
            reqImg.request_type = WRITE;
            reqImg.arguments[0] = 1;
            reqImg.arguments[1] = out_img->mem_pool_buffer_pointer +
                                    ((out_H-1) * out_W + out_C - 1) * data_size / 8;
            reqImg.write_data[0] = word_to_store;
            memPoolAccess((MemPool*)out_img->mem_pool_identifier, &reqImg, &respImg);
            if (respImg.status == NOT_OK){
                fprintf(stderr,"ERROR: Mempool Write Image Tensor Failed in Conv\n");
                return -1;
            }
            size_so_far = 0;
        }
    }//end row major
    else{//column major
        fprintf(stderr,"ERROR: Conv not available for COLUMN major yet\n");
        return -1;
    }//end column major
    return 0; //SUCCESS
}