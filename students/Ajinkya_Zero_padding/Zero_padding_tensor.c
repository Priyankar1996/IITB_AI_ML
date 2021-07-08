#include <stdio.h>
#include <stdint.h>
#include <stdlib.h> 
#include "mempool.h"
#include "tensor.h"
#include <math.h>
#include "zero_padding.h"

MemPool 	mp1;
MemPoolRequest 	req1;
MemPoolResponse resp1; 

MemPool 	mp2;
MemPoolRequest 	req2;
MemPoolResponse resp2; 


void copy_tensor_for_expansion(Tensor *Resultant_tensor,Tensor *src, uint32_t scale_factor,Tensor *result);
void getConstantTensor(int value, Tensor* result);
uint32_t size_to_leave(Tensor* Resultant_tensor);

// Zero padding: Extend the size of an n-dimensional tensor to each side
// by a factor of s, and populate the newly created locations with zeros.


void zeropadtensor(Tensor* src, uint32_t scale_factor, uint32_t constant, Tensor* result) {

    // Creating a tensor tp store the source Tensor
    uint32_t ndim = src->descriptor.number_of_dimensions;
    uint32_t *dims;
    dims = src->descriptor.dimensions;

    // Calculating the new data for the zero padded tensor.
    uint32_t ndim_scale = ndim * scale_factor;
    uint32_t dims_scale[ndim];
    for (int i = 0; i < ndim; i++)
    {
        dims_scale[i] = dims[i] + 2*scale_factor;
    }

    // Creating a new tensor according to the configurartions of the
    // zero padded Tensor.
    createTensor(ndim_scale, dims_scale, u16 , mp1, &Constant_tensor);

    // Initialing the newly created tensor to all zero elements
    getConstantTensor(constant, &Constant_tensor);

    // copying the input tensor to the zero intialized tensor so as to create
    // the resultant tensor
    copy_tensor_for_expansion(&Constant_tensor, &src, scale_factor);

}


// Have to write the code for copying the tensor in the new tensor to upscale
// the  tensor for padding.
// Previous code did not work.
// void  copy_tensor_for_expansion(Tensor *Resultant_tensor,Tensor *src, uint32_t scale_factor) {
//   for(uint32_t i = src->mem_pool_buffer_pointer + scale_factor; i < (src->descriptor.dimensions - scale_factor); i = i + scale_factor){
// 		for (uint32_t j = src->mem_pool_buffer_pointer + scale_factor; j < (src->descriptor.dimensions - scale_factor); j = j + 1){
// 			// Have to edit the line below for data write.
//             Resultant_tensor[i][j + scale_factor] = src[i][j];
// 		}
// 	}
// }


// Here writing the code for element access of the Tensor
// in order to access the single element of the Tensor and Reading as well writing the data 
// accordingly.
// void  copy_tensor_for_expansion(Tensor *Resultant_tensor,Tensor *src, uint32_t scale_factor,Tensor *result) {
//     switch (Resultant_tensor->descriptor.number_of_dimensions)
//     {
//     case 1:
//         // Code for a single dimension
//         for (uint32_t i = scale_factor; i < (Resultant_tensor->descriptor.dimensions[0] - scale_factor); i++ )
//         {
//             readDataBlock(src->mem_pool_identifier,,);
//             writeDataBlock(Resultant_tensor->mem_pool_buffer_pointer,,);
//         }
        
//         break;
//     case 2:
//         // Code for 2 dimensional Tensor
//         for (uint32_t j = scale_factor; j < (Resultant_tensor->descriptor.dimensions[1]); j++)
//         {
//             for (uint32_t i = scale_factor; i < (Resultant_tensor->descriptor.dimensions[0] - scale_factor); i++ )
//         {
//             readDataBlock(src->mem_pool_identifier,,);
//             writeDataBlock(Resultant_tensor->mem_pool_buffer_pointer + size_to_leave(Resultant_tensor->descriptor.dimensions[0]),,);
//         }
//         }
        
//         break;
//     case 3:
//         // Code for 3 dimensional Tensor
//         for (uint32_t k = scale_factor; k < (Resultant_tensor->descriptor.dimensions[2]); k++)
//         {
//             for (uint32_t j = scale_factor; j < (Resultant_tensor->descriptor.dimensions[1]); j++)
//         {
//             for (uint32_t i = scale_factor; i < (Resultant_tensor->descriptor.dimensions[0] - scale_factor); i++ )
//         {
//             readDataBlock(src->mem_pool_identifier,,);
//             writeDataBlock(Resultant_tensor->mem_pool_buffer_pointer + size_to_leave(Resultant_tensor->descriptor.dimensions[0]),,);
//         }
//         }
//         }
        
//         break;
//     case 4:
//         // Code for 4 dimensional Tensor
//         for (uint32_t l = scale_factor; k < Resultant_tensor->descriptor.dimensions[3]; k++)
//         {
//             for (uint32_t k = scale_factor; k < (Resultant_tensor->descriptor.dimensions[2]); k++)
//         {
//             for (uint32_t j = scale_factor; j < (Resultant_tensor->descriptor.dimensions[1]); j++)
//         {
//             for (uint32_t i = scale_factor; i < (Resultant_tensor->descriptor.dimensions[0] - scale_factor); i++ )
//         {
//             readDataBlock(src->mem_pool_identifier,,);
//             writeDataBlock(Resultant_tensor->mem_pool_buffer_pointer + size_to_leave(Resultant_tensor->descriptor.dimensions[0]),,);
//         }
//         }
//         }
//         }
        
//         break;
//     case 5:
//         // Code for 5 dimensional Tensor
//         for (uint32_t m = 0; m < Resultant_tensor->descriptor.dimensions[4]; m++)
//         {
//             for (uint32_t l = scale_factor; k < Resultant_tensor->descriptor.dimensions[3]; k++)
//         {
//             for (uint32_t k = scale_factor; k < (Resultant_tensor->descriptor.dimensions[2]); k++)
//         {
//             for (uint32_t j = scale_factor; j < (Resultant_tensor->descriptor.dimensions[1]); j++)
//         {
//             for (uint32_t i = scale_factor; i < (Resultant_tensor->descriptor.dimensions[0] - scale_factor); i++ )
//         {
//             readDataBlock(src->mem_pool_identifier,,);
//             writeDataBlock(Resultant_tensor->mem_pool_buffer_pointer + size_to_leave(Resultant_tensor->descriptor.dimensions[0]),,);
//         }
//         }
//         }
//         }
//         }
        
//         break;
//     default:
//         printf("Check the Tensor for errors");
//         break;
//     }
// }


// Copy Tensor type using the getTensorEntryIndexOffset

void  copy_tensor_for_expansion(Tensor *Resultant_tensor,Tensor *src, uint32_t scale_factor,Tensor *result) {
    ////////////////////////////////////////

    // MemPool mp1 = src->mem_pool_buffer_pointer;
    // MemPool mp2 = result->mem_pool_buffer_pointer;

    MemPoolRequest req;
    req.request_tag = 0;
    MemPoolResponse resp;

    //generate read req for one word at a time from src.
    //store it into temp_buffer.
    //generate write req for dest tensor.
    uint64_t src_base = src->mem_pool_buffer_pointer;
    uint64_t temp_buffer;
    uint32_t k;

    //store the base address of dest tensor.
    uint32_t dest_base = 0;
    dest_base = resp.allocated_base_address;
    result->mem_pool_buffer_pointer = resp.allocated_base_address;
    ///////////////////////////////////////

    switch (Resultant_tensor->descriptor.number_of_dimensions)
    {
    case 1:
        // Code for a single dimension
        for (uint32_t i = scale_factor; i < (Resultant_tensor->descriptor.dimensions[0] - scale_factor); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(Resultant_tensor->mem_pool_buffer_pointer,,);
            uint32_t *address = getTensorEntryIndexOffset(src,i);

        /////////////////////////////////////////////
            //read one word at a time from src tensor
        req.request_type = READ;
        req.request_tag  = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = src_base;
        //printf("req arguments[1] is %d",req.arguments[1]);

        //generate read request for src
        memPoolAccess(mp1, &req, &resp);
        if(resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", k);

        //store into a temporary local buffer.
        temp_buffer = resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        req.request_type = WRITE;
        req.request_tag = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = dest_base;
        req.write_data[0] = temp_buffer;

        //generate write req for dest.
        memPoolAccess(mp2, &req, &resp);
        if(resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", k);

        src_base++;
        dest_base++;
        ///////////////////////////////////////////////////
        }
        
        break;
    case 2:
        // Code for 2 dimensional Tensor
        for (uint32_t j = scale_factor; j < (Resultant_tensor->descriptor.dimensions[1] -scale_factor); j++)
        {
            for (uint32_t i = scale_factor; i < (Resultant_tensor->descriptor.dimensions[0] - scale_factor); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(Resultant_tensor->mem_pool_buffer_pointer + size_to_leave(Resultant_tensor->descriptor.dimensions[0]),,);
            uint32_t ind[2] = {i,j};
            uint32_t *address = getTensorEntryIndexOffset(src,ind);

             /////////////////////////////////////////////
            //read one word at a time from src tensor
        req.request_type = READ;
        req.request_tag  = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = src_base;
        //printf("req arguments[1] is %d",req.arguments[1]);

        //generate read request for src
        memPoolAccess(mp1, &req, &resp);
        if(resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", k);

        //store into a temporary local buffer.
        temp_buffer = resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        req.request_type = WRITE;
        req.request_tag = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = dest_base;
        req.write_data[0] = temp_buffer;

        //generate write req for dest.
        memPoolAccess(mp2, &req, &resp);
        if(resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", k);

        src_base++;
        dest_base++;
        ///////////////////////////////////////////////////
        }
        }
        
        break;
    case 3:
        // Code for 3 dimensional Tensor
        for (uint32_t k = scale_factor; k < (Resultant_tensor->descriptor.dimensions[2] - scale_factor); k++)
        {
            for (uint32_t j = scale_factor; j < (Resultant_tensor->descriptor.dimensions[1]); j++)
        {
            for (uint32_t i = scale_factor; i < (Resultant_tensor->descriptor.dimensions[0] - scale_factor); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(Resultant_tensor->mem_pool_buffer_pointer + size_to_leave(Resultant_tensor->descriptor.dimensions[0]),,);
            uint32_t ind[3] = {i,j,k};
            uint32_t *address = getTensorEntryIndexOffset(src,ind);

             /////////////////////////////////////////////
            //read one word at a time from src tensor
        req.request_type = READ;
        req.request_tag  = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = src_base;
        //printf("req arguments[1] is %d",req.arguments[1]);

        //generate read request for src
        memPoolAccess(mp1, &req, &resp);
        if(resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", k);

        //store into a temporary local buffer.
        temp_buffer = resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        req.request_type = WRITE;
        req.request_tag = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = dest_base;
        req.write_data[0] = temp_buffer;

        //generate write req for dest.
        memPoolAccess(mp2, &req, &resp);
        if(resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", k);

        src_base++;
        dest_base++;
        ///////////////////////////////////////////////////
        }
        }
        }
        
        break;
    case 4:
        // Code for 4 dimensional Tensor
        for (uint32_t l = scale_factor; l < (Resultant_tensor->descriptor.dimensions[3] - scale_factor); l++)
        {
            for (uint32_t k = scale_factor; k < (Resultant_tensor->descriptor.dimensions[2] - scale_factor); k++)
        {
            for (uint32_t j = scale_factor; j < (Resultant_tensor->descriptor.dimensions[1] - scale_factor); j++)
        {
            for (uint32_t i = scale_factor; i < (Resultant_tensor->descriptor.dimensions[0] - scale_factor); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(Resultant_tensor->mem_pool_buffer_pointer + size_to_leave(Resultant_tensor->descriptor.dimensions[0]),,);
            uint32_t ind[3] = {i,j,k,l};
            uint32_t *address = getTensorEntryIndexOffset(src,ind);

             /////////////////////////////////////////////
            //read one word at a time from src tensor
        req.request_type = READ;
        req.request_tag  = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = src_base;
        //printf("req arguments[1] is %d",req.arguments[1]);

        //generate read request for src
        memPoolAccess(mp1, &req, &resp);
        if(resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", k);

        //store into a temporary local buffer.
        temp_buffer = resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        req.request_type = WRITE;
        req.request_tag = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = dest_base;
        req.write_data[0] = temp_buffer;

        //generate write req for dest.
        memPoolAccess(mp2, &req, &resp);
        if(resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", k);

        src_base++;
        dest_base++;
        ///////////////////////////////////////////////////
        }
        }
        }
        }
        
        break;
    case 5:
        // Code for 5 dimensional Tensor
        for (uint32_t m = scale_factor; m < (Resultant_tensor->descriptor.dimensions[4] - scale_factor); m++)
        {
            for (uint32_t l = scale_factor; l < (Resultant_tensor->descriptor.dimensions[3] - scale_factor); l++)
        {
            for (uint32_t k = scale_factor; k < (Resultant_tensor->descriptor.dimensions[2] - scale_factor); k++)
        {
            for (uint32_t j = scale_factor; j < (Resultant_tensor->descriptor.dimensions[1] - scale_factor); j++)
        {
            for (uint32_t i = scale_factor; i < (Resultant_tensor->descriptor.dimensions[0] - scale_factor); i++ )
        {
            // readDataBlock(src->mem_pool_identifier,,);
            // writeDataBlock(Resultant_tensor->mem_pool_buffer_pointer + size_to_leave(Resultant_tensor->descriptor.dimensions[0]),,);
            uint32_t ind[5] = {i,j,k,l,m};
            uint32_t *address = getTensorEntryIndexOffset(src,ind);


             /////////////////////////////////////////////
            //read one word at a time from src tensor
        req.request_type = READ;
        req.request_tag  = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = src_base;
        //printf("req arguments[1] is %d",req.arguments[1]);

        //generate read request for src
        memPoolAccess(mp1, &req, &resp);
        if(resp.status != OK)
        {
            fprintf(stderr,"Error: could not read word %d from source tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: read from block %d.\n", k);

        //store into a temporary local buffer.
        temp_buffer = resp.read_data[0];
        //printf("Temporary buffer value : %d",temp_buffer);

        //write one word at a time int dest tensor.
        req.request_type = WRITE;
        req.request_tag = req.request_tag + 1;
        req.arguments[0] = 1;
        req.arguments[1] = dest_base;
        req.write_data[0] = temp_buffer;

        //generate write req for dest.
        memPoolAccess(mp2, &req, &resp);
        if(resp.status !=  OK)
        {
            fprintf(stderr,"Error: could not write word %d into destination tensor.\n", k);
        }
        fprintf(stderr,"\nInfo: wrote into block %d.\n", k);

        src_base++;
        dest_base++;
        ///////////////////////////////////////////////////
        }
        }
        }
        }
        }
        
        break;
    default:
        printf("Check the Tensor for errors");
        break;
    }
}


uint32_t size_to_leave(Tensor* Resultant_tensor){
    uint32_t size = sizeofTensorDataInBytes(Resultant_tensor->descriptor.data_type) * Resultant_tensor->descriptor.dimensions[0];
    return size;
}

// Here writing the code for the copy_tensor_for_expansion
// Here we are trying to make the tensor for n dimensions using function call 
// void  copy_tensor_for_expansion(Tensor *Resultant_tensor,Tensor *src, uint32_t scale_factor,Tensor *result) {

// }


// Have to write the code for filling the upscaled tensor with th initial
// values of o.
void getConstantTensor(int value,Tensor* result){
	Tensor* T_res_ptr = result;
	

    int r;
    float s=1;
    // result->descriptor.number_of_dimensions = ndim;
    // printf("Number of dim : %d\n",result->descriptor.number_of_dimensions);
    uint32_t ndim = result->descriptor.number_of_dimensions;
    uint32_t *dims;
    dims = result->descriptor.dimensions;
    for(r=0;r<ndim;r++)
    {
        // result->descriptor.dimensions[r] = *dims;
        // printf("Dim %d is %d\n",r,result->descriptor.dimensions[r]);
        s = s * (*dims);
        dims = dims + 1;
    }
    // result->descriptor.data_type = dt;
    // result->mem_pool_identifier = mempool;
    printf("size of created tensor src %f\n",s);

    uint32_t p = 0;
    uint32_t npages,rem;
    uint32_t consta = 512;
    uint32_t b=0,k;
    npages = ceil(s/512);
    printf("Number of pages required : %d\n",npages);
    rem = (uint32_t) s % consta;
    for(p=0;p<npages;p++)
    {
        if(p != npages - 1)
        {
            req1.request_type = ALLOCATE;
            req1.request_tag = p;
            req1.arguments[0] = 1;

            memPoolAccess(&result, &req1, &resp1);
            if(resp1.status !=  OK)
            {
                fprintf(stderr,"Error: could not allocate memory.\n");
            }

            for(k=0; k < MEMPOOL_PAGE_SIZE; k++)
            {
                req1.write_data[k] = 0;
            }

            req1.request_type = WRITE;
            req1.request_tag  = p + npages;
            req1.arguments[0] = MEMPOOL_PAGE_SIZE;
            req1.arguments[1] = resp1.allocated_base_address;

            memPoolAccess(&pool2, &req1, &resp1);
            if(resp1.status !=  OK)
            {
                fprintf(stderr,"Error: could not write into memory.\n");
            }

            fprintf(stderr,"\nInfo: wrote into page %d.\n", p);
        }
        
    }
    result->mem_pool_buffer_pointer = pool2.mem_pool_buffer;
}
