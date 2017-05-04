//===------------------------- ManglingUtils.cpp -------------------------===//
//
//                              SPIR Tools
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===---------------------------------------------------------------------===//
/*
 * Contributed by: Intel Corporation.
 */

#include "ManglingUtils.h"

namespace SPIR {

  // String represenration for the primitive types.
  static const char* PrimitiveNames[PRIMITIVE_NUM] ={
    "bool",
    "uchar",
    "char",
    "ushort",
    "short",
    "uint",
    "int",
    "ulong",
    "long",
    "half",
    "float",
    "double",
    "void",
    "...",
    "image1d_t",
    "image1d_array_t",
    "image1d_buffer_t",
    "image2d_t",
    "image2d_array_t",
    "image3d_t",
    "image2d_msaa_t",
    "image2d_array_msaa_t",
    "image2d_msaa_depth_t",
    "image2d_array_msaa_depth_t",
    "image2d_depth_t",
    "image2d_array_depth_t",
    "event_t",
    "pipe_t",
    "reserve_id_t",
    "queue_t",
    "ndrange_t",
    "clk_event_t",
    "sampler_t",
    "kernel_enqueue_flags_t",
    "clk_profiling_info",
  };

  const char* mangledTypes[PRIMITIVE_NUM] = {
    "b",  //BOOL
    "h",  //UCHAR
    "c",  //CHAR
    "t",  //USHORT
    "s",  //SHORT
    "j",  //UINT
    "i",  //INT
    "m",  //ULONG
    "l",  //LONG
    "Dh", //HALF
    "f",  //FLOAT
    "d",  //DOUBLE
    "v",  //VOID
    "z",  //VarArg
    "11ocl_image1d",                 //PRIMITIVE_IMAGE_1D_T
    "16ocl_image1darray",            //PRIMITIVE_IMAGE_1D_ARRAY_T
    "17ocl_image1dbuffer",           //PRIMITIVE_IMAGE_1D_BUFFER_T
    "11ocl_image2d",                 //PRIMITIVE_IMAGE_2D_T
    "16ocl_image2darray",            //PRIMITIVE_IMAGE_2D_ARRAY_T
    "11ocl_image3d",                 //PRIMITIVE_IMAGE_3D_T
    "15ocl_image2dmsaa",             //PRIMITIVE_IMAGE_2D_MSAA_T
    "20ocl_image2darraymsaa",        //PRIMITIVE_IMAGE_2D_ARRAY_MSAA_T
    "20ocl_image2dmsaadepth",        //PRIMITIVE_IMAGE_2D_MSAA_DEPTH_T
    "25ocl_image2darraymsaadepth",   //PRIMITIVE_IMAGE_2D_ARRAY_MSAA_DEPTH_T
    "16ocl_image2ddepth",            //PRIMITIVE_IMAGE_2D_DEPTH_T
    "21ocl_image2darraydepth",       //PRIMITIVE_IMAGE_2D_ARRAY_DEPTH_T
    "9ocl_event",                    //PRIMITIVE_EVENT_T
    "8ocl_pipe",                     //PRIMITIVE_PIPE_T
    "13ocl_reserveid",               //PRIMITIVE_RESERVE_ID_T
    "9ocl_queue",                    //PRIMITIVE_QUEUE_T
    "9ndrange_t",                    //PRIMITIVE_NDRANGE_T
    "12ocl_clkevent",                //PRIMITIVE_CLK_EVENT_T
    "11ocl_sampler",                 //PRIMITIVE_SAMPLER_T
#if defined(SPIRV_SPIR20_MANGLING_REQUIREMENTS)
    "i",                             //PRIMITIVE_KERNEL_ENQUEUE_FLAGS_T
    "i",                             //PRIMITIVE_CLK_PROFILING_INFO
#else
    "22kernel_enqueue_flags_t",      //PRIMITIVE_KERNEL_ENQUEUE_FLAGS_T
    "18clk_profiling_info",          //PRIMITIVE_CLK_PROFILING_INFO
#endif
  };

  const char* readableAttribute[ATTR_NUM] = {
    "restrict",
    "volatile",
    "const",
    "__private",
    "__global",
    "__constant",
    "__local",
    "__generic",
  };

  const char* mangledAttribute[ATTR_NUM] = {
    "r",
    "V",
    "K",
    "",
    "U3AS1",
    "U3AS2",
    "U3AS3",
    "U3AS4",
  };

  // SPIR supported version - stated version is oldest supported version.
  static const SPIRversion primitiveSupportedVersions[PRIMITIVE_NUM] ={
    SPIR12,        //BOOL
    SPIR12,        //UCHAR
    SPIR12,        //CHAR
    SPIR12,        //USHORT
    SPIR12,        //SHORT
    SPIR12,        //UINT
    SPIR12,        //INT
    SPIR12,        //ULONG
    SPIR12,        //LONG
    SPIR12,        //HALF
    SPIR12,        //FLOAT
    SPIR12,        //DOUBLE
    SPIR12,        //VOID
    SPIR12,        //VarArg
    SPIR12,        //PRIMITIVE_IMAGE_1D_T
    SPIR12,        //PRIMITIVE_IMAGE_1D_ARRAY_T
    SPIR12,        //PRIMITIVE_IMAGE_1D_BUFFER_T
    SPIR12,        //PRIMITIVE_IMAGE_2D_T
    SPIR12,        //PRIMITIVE_IMAGE_2D_ARRAY_T
    SPIR12,        //PRIMITIVE_IMAGE_3D_T
    SPIR12,        //PRIMITIVE_IMAGE_2D_MSAA_T
    SPIR12,        //PRIMITIVE_IMAGE_2D_ARRAY_MSAA_T
    SPIR12,        //PRIMITIVE_IMAGE_2D_MSAA_DEPTH_T
    SPIR12,        //PRIMITIVE_IMAGE_2D_ARRAY_MSAA_DEPTH_T
    SPIR12,        //PRIMITIVE_IMAGE_2D_DEPTH_T
    SPIR12,        //PRIMITIVE_IMAGE_2D_ARRAY_DEPTH_T
    SPIR12,        //PRIMITIVE_EVENT_T
    SPIR20,        //PRIMITIVE_PIPE_T
    SPIR20,        //PRIMITIVE_RESERVE_ID_T
    SPIR20,        //PRIMITIVE_QUEUE_T
    SPIR20,        //PRIMITIVE_NDRANGE_T
    SPIR20,        //PRIMITIVE_CLK_EVENT_T
    SPIR12         //PRIMITIVE_SAMPLER_T
  };

  const char* mangledPrimitiveString(TypePrimitiveEnum t) {
    return mangledTypes[t];
  }

  const char* readablePrimitiveString(TypePrimitiveEnum t) {
    return PrimitiveNames[t];
  }

  const char* getMangledAttribute(TypeAttributeEnum attribute) {
    return mangledAttribute[attribute];
  }

  const char* getReadableAttribute(TypeAttributeEnum attribute) {
    return readableAttribute[attribute];
  }

  SPIRversion getSupportedVersion(TypePrimitiveEnum t) {
    return primitiveSupportedVersions[t];
  }

  const char* mangledPrimitiveStringfromName(std::string type) {
    for (size_t i = 0; i < (sizeof(PrimitiveNames) / sizeof(PrimitiveNames[0])); i++)
      if (type.compare(PrimitiveNames[i]) == 0)
        return mangledTypes[i];
    return NULL;
  }

  const char* getSPIRVersionAsString(SPIRversion version) {
    switch (version) {
      case SPIR12: return "SPIR 1.2";
      case SPIR20: return "SPIR 2.0";
      default:
        assert(false && "Unknown SPIR Version");
        return "Unknown SPIR Version";
    }
  }

} // End SPIR namespace
