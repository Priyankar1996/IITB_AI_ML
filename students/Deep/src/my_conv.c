#include "../include/conv.h"


int convTensors(Tensor *in_img, Tensor *kernel, Tensor *out_img, MemPool *mpool, 
			const int stride[3], const int padding[6]){
	
	fprintf(stderr,"INSIDE CONV\n");
	
	MemPoolRequest reqKer, reqImg, reqOut;
	MemPoolResponse respKer, respImg, respOut;

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
	uint32_t ker_C = td_ker.dimensions[2];

	uint32_t out_H = (in_H + padding[0] + padding[1] - ker_H)/stride[0] + 1;
	uint32_t out_W = (in_W + padding[2] + padding[3] - ker_W)/stride[1] + 1;
	uint32_t out_C = (in_C + padding[4] + padding[5] - ker_C)/stride[2] + 1; //td_ker.dimensions[td_ker.number_of_dimensions - 1];
	
	out_img->descriptor.row_major_form = is_row_major;
	out_img->descriptor.number_of_dimensions = 3;
	out_img->descriptor.data_type = td_in.data_type;
	out_img->descriptor.dimensions[0] = out_H;
	out_img->descriptor.dimensions[1] = out_W;
	out_img->descriptor.dimensions[2] = out_C;
	td_out = out_img->descriptor;
	
	int num_dim_ker = td_ker.number_of_dimensions;
	int num_ele_per_filt = ker_W*ker_H*ker_C;
	int num_ele_out = out_W*out_H*out_C;

	uint32_t data_size = sizeofTensorDataInBytes(td_in.data_type);

	uint32_t num_words_ker = CEILING(num_ele_per_filt*data_size,8) ;
	
	reqKer.request_type = READ ;
	reqKer.arguments[0] = num_words_ker;
	reqKer.arguments[1] = kernel->mem_pool_buffer_pointer;
	reqKer.arguments[2] = 1; // stride = 1 as pointwise

	memPoolAccess((MemPool *)kernel->mem_pool_identifier,&reqKer,&respKer);
	if(respKer.status == NOT_OK){
		fprintf(stderr,"ERROR: Read Kernel Tensor Failed in Conv\n");
		return -1;
	}

	int flag = createTensorAtHead(out_img, mpool);
	//uint8_t init_val = 0;
	//flag = flag + initializeTensor(&out_img, &init_val);
	if(flag != 0){
		fprintf(stderr,"ERROR: Initialising output Tensor Failed in Conv\n");
		return -1;
	}


	uint8_t loops = CEILING(num_ele_out, MAX_SIZE_OF_REQUEST_IN_WORDS);
	uint8_t I=0;
	uint32_t done=0;
	for(I=0;I<loops;I++){
		uint32_t curr_writes = (I == loops - 1)? num_ele_out % MAX_SIZE_OF_REQUEST_IN_WORDS : MAX_SIZE_OF_REQUEST_IN_WORDS ;		
		uint32_t J = 0 ;
		switch(td_in.data_type){
			case i64:
				for(J=0; J<curr_writes; J++){
					uint8_t oc = done / (out_H*out_W);
					uint8_t oh = (done-oc*out_W*out_H)/(out_H), ow = done - oc*out_H*out_W - oh*out_H; 
					int32_t iws = ow*stride[1] - padding[2], iwe = iws + ker_W -1; 
					int32_t ihs = oh*stride[0] - padding[0], ihe = ihs + ker_H -1; 
					int32_t ics = oc*stride[2] - padding[4], ice = ics + ker_C -1; 

					iws = (iws<0)?0:iws ; iwe = (iwe>=in_W)? in_W-1 : iwe ; 
					ihs = (ihs<0)?0:ihs ; ihe = (ihe>=in_H)? in_H-1 : ihe ;
					ics = (ics<0)?0:ics ; ice = (ice>=in_C)? in_C-1 : ice ;

					//printf("iws:%d iwe:%d ihs:%d ihe:%d ics:%d ice:%d\n",iws,iwe,ihs,ihe,ics,ice);
					uint64_t ans = 0, id = 0;
					uint32_t tc;
					for (tc=ics;tc<=ice;tc++){
						uint32_t th ;
						for (th=ihs;th<=ihe;th++){
							uint32_t tw ;
							for(tw=iws;tw<=iwe;tw++){
								uint32_t indices[] = {tw,th,tc};
								uint32_t loc = getTensorEntryIndexOffset(&td_in, indices) ;
								reqImg.request_type = READ ;
								reqImg.arguments[0] = 1 ; //Read 1 by 1
								reqImg.arguments[1] = in_img->mem_pool_buffer_pointer + loc ;
								reqImg.arguments[2] = 1;
								memPoolAccess((MemPool *)in_img->mem_pool_identifier, &reqImg, &respImg);
								if(respImg.status !=  OK)
								{
									fprintf(stderr,"Error: could not read Img from memory.\n");
									break;
								}
								//printf("Multiplying %d with {%d,%d,%d}\n",id,tw,th,tc);
								ans += respKer.read_data[id]*respImg.read_data[0];	
								id++;								
							}
						}
					}
					
					reqOut.write_data[J + I*MAX_SIZE_OF_REQUEST_IN_WORDS] = ans;
					done++;
				}

				break;
			case float64:
				for(J=0; J<curr_writes; J++){
					uint8_t oc = done / (out_H*out_W);
					uint8_t oh = (done-oc*out_W*out_H)/(out_H), ow = done - oc*out_H*out_W - oh*out_H; 
					int32_t iws = ow*stride[1] - padding[2], iwe = iws + ker_W -1; 
					int32_t ihs = oh*stride[0] - padding[0], ihe = ihs + ker_H -1; 
					int32_t ics = oc*stride[2] - padding[4], ice = ics + ker_C -1; 

					iws = (iws<0)?0:iws ; iwe = (iwe>=in_W)? in_W-1 : iwe ; 
					ihs = (ihs<0)?0:ihs ; ihe = (ihe>=in_H)? in_H-1 : ihe ;
					ics = (ics<0)?0:ics ; ice = (ice>=in_C)? in_C-1 : ice ;

					//printf("iws:%d iwe:%d ihs:%d ihe:%d ics:%d ice:%d\n",iws,iwe,ihs,ihe,ics,ice);
					union udouble {
						double d ;
						uint64_t u;
					} ans, rk, ri ;
					ans.d=0;
					uint64_t id = 0;
					uint32_t tc;
					for (tc=ics;tc<=ice;tc++){
						uint32_t th ;
						for (th=ihs;th<=ihe;th++){
							uint32_t tw ;
							for(tw=iws;tw<=iwe;tw++){
								uint32_t indices[] = {tw,th,tc};
								uint32_t loc = getTensorEntryIndexOffset(&td_in, indices) ;
								reqImg.request_type = READ ;
								reqImg.arguments[0] = 1 ; //Read 1 by 1
								reqImg.arguments[1] = in_img->mem_pool_buffer_pointer + loc ;
								reqImg.arguments[2] = 1;
								memPoolAccess((MemPool *)in_img->mem_pool_identifier, &reqImg, &respImg);
								if(respImg.status !=  OK)
								{
									fprintf(stderr,"Error: could not read Img from memory.\n");
									break;
								}
								//printf("Multiplying %d with {%d,%d,%d}\n",id,tw,th,tc);
								rk.u = respKer.read_data[id] ;
								ri.u = respImg.read_data[0] ;
								//printf("ker: %f img: %f\n",rk.d, ri.d );
								ans.d += rk.d * ri.d ;	
								id++;								
							}
						}
					}
					//printf("ans: %lf\n",ans.d);
					reqOut.write_data[J + I*MAX_SIZE_OF_REQUEST_IN_WORDS] = ans.u;
					done++;
				}

				break;
			default:
				printf("Conv not ready yet for other data types\n");
				return -1 ;
		}
		reqOut.request_type = WRITE ;
		reqOut.request_tag = I + 1 ;
		reqOut.arguments[0] = curr_writes ;
		reqOut.arguments[1] = out_img->mem_pool_buffer_pointer + I*MAX_SIZE_OF_REQUEST_IN_WORDS;
		reqOut.arguments[2] = 1 ;
		memPoolAccess((MemPool *)out_img->mem_pool_identifier, &reqOut, &respOut);
		if(respOut.status !=  OK)
		{
			fprintf(stderr,"Error: could not write Convolved tensor into memory.\n");
			return -1;
		}
	}
	return 0; 	
}