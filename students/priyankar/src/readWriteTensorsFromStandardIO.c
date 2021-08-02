#include "createTensor.h"
#include "readWriteTensorsFromStandardIO.h"

int readTensorFromFile(char *filename, Tensor *t)
{
    FILE *file;
    file = fopen(filename,"r");
    MemPool *mp = (MemPool *)(t->mem_pool_identifier);
    MemPoolRequest mp_req;
    MemPoolResponse mp_resp;
    uint32_t count = 0,i, num_elems=1, datasize, num_images;
    int iter = 0;
    datasize = sizeofTensorDataInBytes(t->descriptor.data_type);
    num_elems = numberOfElementsInTensor(t);

    uint32_t flag = 0;

    char line[4096];
    if(file == NULL)
    {
        perror("ERROR: File opening failed.\n");
        return 1;
    }
    else
    {
        mp_req.request_type = WRITE;
        int words_left = CEILING(num_elems*datasize,8);
        void *array;
        array = mp_req.write_data;     
        while(fgets(line, 4096, file))
        {
            const char *tok;
            char *eptr;
            for(tok = strtok(line, ","); tok && *tok;tok = strtok(NULL,","))
            {
                int elementsToWrite = MIN(words_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
                
                switch (t->descriptor.data_type)
                {
                    case u8: ; 
				    uint8_t val8 = (uint8_t) strtoul(tok,&eptr,10);
				    *(((uint8_t*)array) + count++) = val8;
				    break;

                    case u16: ;
				    uint16_t val16 = (uint16_t) strtoul(tok,&eptr,10);
				    *(((uint16_t*)array) + count++) = val16;
				    break;

                    case u32: ;
                    uint32_t val32 = (uint32_t) strtoul(tok,&eptr,10);
                    *(((uint32_t*)array) + count++) = val32;
                    break;

                    case u64: ; 
				    uint64_t val64 = (uint64_t) strtoul(tok,&eptr,10);
				    *(((uint64_t*)array) + count++) = val64;
				    break;
				
			        case i8: ;
				    int8_t val8i = (int8_t) strtol(tok,&eptr,10);
				    *(((int8_t*)array) + count++) = val8i;
				    break;

			        case i16: ;
				    int16_t val16i = (int16_t) strtol(tok,&eptr,10);
				    *(((int16_t*)array) + count++) = val16i;
				    break;

			        case i32: ; 
				    int32_t val32i = (int32_t) strtol(tok,&eptr,10) ;
				    *(((int32_t*)array) + count++) = val32i;
				    break;

			        case i64: ;
				    int64_t val64i = (int64_t) strtol(tok,&eptr,10);
				    *(((int64_t*)array) + count++) = val64i;
				    break;

			        // case float8: ;
				    // to be added 
				    // break;

			        // case float16: ;
				    // to be added 
				    // break;

			        case float32: ;
				    float val32f = (float)strtod(tok,&eptr);
				    *(((float*)array) + count++) = val32f;
				    break;

			        case float64: ;
				    double val64f = (double)strtod(tok,&eptr);
				    *(((double*)array) + count++) = val64f;
				    break;

                    default:
                    break;
                }
                if (count == (elementsToWrite*8/datasize)) 
                {
                    mp_req.arguments[0] = elementsToWrite; 
		            mp_req.arguments[1] = t->mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter++;
		            mp_req.arguments[2] = 1;
                    printf("Words to write:%d\n",elementsToWrite);
                    memPoolAccess(mp,&mp_req,&mp_resp);

                    //for(i=0;i<elementsToWrite;i++)
                    //    printf("%u\t",mp_req.write_data[i]);
                    //printf("\n");
                    words_left -= elementsToWrite;
                    count = 0;

                    if(mp_resp.status == OK)
                        flag = flag || 0;
                    else
                        flag = flag || 1; 
                }
            }
        }
    }
    if (flag == 1)
        perror("ERROR: Could not read from file.\n");
    else   
        printf("SUCCESS: Read from File.\n");
    return flag;
}

int writeTensorToFile(char *filename, Tensor *t)
{
    int flag = 0; //float fvalue; double dvalue;
    FILE *file;
    file = fopen(filename,"w");
    MemPool *mp = (MemPool *)(t->mem_pool_identifier);
    MemPoolRequest mp_req;
    MemPoolResponse mp_resp;
    uint32_t datasize,num_elems=1;
    datasize = sizeofTensorDataInBytes(t->descriptor.data_type);
    num_elems = numberOfElementsInTensor(t);

    if(file == NULL)
    {
        printf("ERROR: File opening failed.\n");
        return 1;
    }
    else
    {
        int iter = -1,j;
        uint64_t count=0; size_t k;
        int words_left = CEILING(num_elems * datasize,8);
        for( ; words_left > 0; words_left -= MAX_SIZE_OF_REQUEST_IN_WORDS)
        {
            iter ++;
            int elements_to_read = MIN(words_left,MAX_SIZE_OF_REQUEST_IN_WORDS);
            printf("Words to read:%d\n",elements_to_read);
            mp_req.request_type = READ;
            mp_req.arguments[0] = elements_to_read;
            mp_req.arguments[1] = t->mem_pool_buffer_pointer+MAX_SIZE_OF_REQUEST_IN_WORDS*iter;
		    mp_req.arguments[2] = 1;//stride

            memPoolAccess(mp, &mp_req, &mp_resp);
            if(mp_resp.status !=OK)
            {
                printf("ERROR: Failed to read the source tensor.");
                flag = flag || 1;
                break;
            }

            for(j=0;j<elements_to_read;j++)
            {
                switch (t->descriptor.data_type)
                {
                    case u8:{
                                //count++;
                                uint8_t (*bytesu8)[8] = (void *) &mp_resp.read_data[j];
                                for (k = 0; k < 8; k++)
                                {
                                    count++;
                                    fprintf(file, "%hhu%s",(*bytesu8)[k],(count%3!=0 ? ",":"\n"));
                                }
                                break;
                            }
                    
                    case u16:{
                                uint16_t (*bytesu16)[4] = (void *) &mp_resp.read_data[j];
                                for (k = 0; k < 4; k++)
                                {
                                    count++;
                                    fprintf(file, "%hhu%s",(*bytesu16)[k],(count%3!=0 ? ",":"\n"));
                                }
                                break;
                            }
                    case u32:{
                                uint32_t (*bytesu32)[2] = (void*) &mp_resp.read_data[j];
                                for (k = 0; k < sizeof(*bytesu32)/sizeof(uint32_t); k++)
                                {
                                    count++;
                                    fprintf(file, "%hhu%s",(*bytesu32)[k],(count%3!=0 ? ",":"\n"));
                                }
                                break;
                            }
                    case u64:   count++; 
                                fprintf(file, "%u%s",mp_resp.read_data[j],(count%3!=0 ? ",":"\n"));
                                break;

                    case i8:{
                                int8_t (*bytes8)[8] = (void*) &mp_resp.read_data[j];
                                for (k = 0; k < 8; k++)
                                {
                                    count++;
                                    fprintf(file, "%hhi%s",(*bytes8)[k],(count%3!=0 ? ",":"\n"));
                                }
                                break;
                            }
                    case i16:{
                                int16_t (*bytes16)[4] = (void*) &mp_resp.read_data[j];
                                for (k = 0; k < 4; k++)
                                {
                                    count++;
                                    fprintf(file, "%hhi%s",(*bytes16)[k],(count%3!=0 ? ",":"\n"));
                                }
                                break;
                            }

                    case i32:{
                                int32_t (*bytes32)[2] = (void*) &mp_resp.read_data[j];
                                for (k = 0; k < 2; k++)
                                {
                                    count++;
                                    fprintf(file, "%hhi%s",(*bytes32)[k],(count%3!=0 ? ",":"\n"));
                                }
                                break;
                            }
                    case i64: fprintf(file, "%d%s",mp_resp.read_data[j],(count%3!=0 ? ",":"\n"));
                                break;

                    //case float8:
                    //case float16:
                    case float32:{
                                    float (*bytes32)[2] = (void*) &mp_resp.read_data[j];
                                    for (k = 0; k < 2; k++)
                                    {
                                        count++;
                                        fprintf(file, "%f%s",(*bytes32)[k],(count%3!=0 ? ",":"\n"));
                                    }
                                    /*memcpy(&fvalue, &mp_resp.read_data[j],sizeof(float));
                                    fprintf(file, "%f%s",fvalue,(count%3!=0 ? ",":"\n"));*/
                                    break;
                                }

                    case float64:{
                                    count++;
                                    double *dvalue = (void*) &mp_resp.read_data[j];
                                    fprintf(file, "%f%s",(*dvalue),(count%3!=0 ? ",":"\n"));
                                    break;
                                }
                                    /*memcpy(&dvalue, &mp_resp.read_data[j],sizeof(double));
                                    fprintf(file, "%d%s",dvalue,(count%3!=0 ? ",":"\n"));
                                    break;*/
                }
            }
        }
    }
    if (flag == 0)
        printf("SUCCESS: Wrote Into File.\n");
    return flag;
}