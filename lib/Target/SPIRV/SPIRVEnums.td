//===----- SPIRVEnums.td - Enums for SPIRV ----*- tablegen -------------*--===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
// Copyright (c) 2014 Advanced Micro Devices, Inc. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal with the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimers.
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimers in the documentation
// and/or other materials provided with the distribution.
// Neither the names of Advanced Micro Devices, Inc., nor the names of its
// contributors may be used to endorse or promote products derived from this
// Software without specific prior written permission.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS WITH
// THE SOFTWARE.

def EnableExperimental : Predicate<"llvm::EnableExperimentalFeatures">;
def In32BitMode  : Predicate<"!Subtarget->is64Bit()">;
def In64BitMode  : Predicate<"Subtarget->is64Bit()">;
def EnableOpt    : Predicate<"CodeGenOpt::None != TM.getOptLevel()">;

def SPIRVSourceLanguage : Operand<i32> {
  let PrintMethod = "printSPIRVSourceLanguage";

  int Unknown = 0;
  int ESSL = 1;
  int GLSL = 2;
  int OpenCL_C = 3;
  int OpenCL_CPP = 4;
}

def SPIRVExecutionModel : Operand<i32> {
  let PrintMethod = "printSPIRVExecutionModel";

  int Vertex = 0;
  int TessellationControl = 1;
  int TessellationEvaluation = 2;
  int Geometry = 3;
  int Fragment = 4;
  int GLCompute = 5;
  int Kernel = 6;
}

def SPIRVAddressingModel : Operand<i32> {
  let PrintMethod = "printSPIRVAddressingModel";

  int Logical = 0;
  int Physical32 = 1;
  int Physical64 = 2;
}

def SPIRVMemoryModel : Operand<i32> {
  let PrintMethod = "printSPIRVMemoryModel";

  int Simple = 0;
  int GLSL450 = 1;
  int OpenCL = 2;
}

def SPIRVExecutionMode : Operand<i32> {
  let PrintMethod = "printSPIRVExecutionMode";

  int lVertex = 0;
  int lTessellationControl = 1;
  int lTessellationEvaluation = 2;
  int lGeometry = 3;
  int lFragment = 4;
  int lGLCompute = 5;
  int lKernel = 6;
  int Invocations = 0;
  int SpacingEqual = 1;
  int SpacingFractionalEven = 2;
  int SpacingFractionalOdd = 3;
  int VertexOrderCw = 4;
  int VertexOrderCcw = 5;
  int PixelCenterInteger = 6;
  int OriginUpperLeft = 7;
  int OriginLowerLeft = 8;
  int EarlyFragmentTests = 9;
  int PointMode = 10;
  int Xfb = 11;
  int DepthReplacing = 12;
  int DepthGreater = 14;
  int DepthLess = 15;
  int DepthUnchanged = 16;
  int LocalSize = 17;
  int LocalSizeHint = 18;
  int InputPoints = 19;
  int InputLines = 20;
  int InputLinesAdjacency = 21;
  int Triangles = 22;
  int InputTrianglesAdjacency = 23;
  int Quads = 24;
  int Isolines = 25;
  int OutputVertices = 26;
  int OutputPoints = 27;
  int OutputLineStrip = 28;
  int OutputTriangleStrip = 29;
  int VecTypeHint = 30;
  int ContractionOff = 31;
}

def SPIRVStorageClass : Operand<i32> {
  let PrintMethod = "printSPIRVStorageClass";

  int UniformConstant = 0;
  int Input = 1;
  int Uniform = 2;
  int Output = 3;
  int Workgroup = 4;
  int CrossWorkgroup = 5;
  int Private = 6;
  int Function = 7;
  int Generic = 8;
  int PushConstant = 9;
  int AtomicCounter = 10;
  int Image = 11;
}

def SPIRVDim : Operand<i32> {
  let PrintMethod = "printSPIRVDim";

  int 1D = 0;
  int 2D = 1;
  int 3D = 2;
  int Cube = 3;
  int Rect = 4;
  int Buffer = 5;
  int SubpassData = 6;
}

def SPIRVSamplerAddressingMode : Operand<i32> {
  let PrintMethod = "printSPIRVSamplerAddressingMode";

  int None = 0;
  int ClampToEdge = 1;
  int Clamp = 2;
  int Repeat = 3;
  int RepeatMirrored = 4;
}

def SPIRVSamplerFilterMode : Operand<i32> {
  let PrintMethod = "printSPIRVSamplerFilterMode";

  int Nearest = 0;
  int Linear = 1;
}

def SPIRVImageFormat : Operand<i32> {
  let PrintMethod = "printSPIRVImageFormat";

  int Unknown = 0;
  int Rgba32f = 1;
  int Rgba16f = 2;
  int R32f = 3;
  int Rgba8 = 4;
  int Rgba8Snorm = 5;
  int Rg32f = 6;
  int Rg16f = 7;
  int R11fG11fB10f = 8;
  int R16f = 9;
  int Rgba16 = 10;
  int Rgb10A2 = 11;
  int Rg16 = 12;
  int Rg8 = 13;
  int R16 = 14;
  int R8 = 15;
  int Rgba16Snorm = 16;
  int Rg16Snorm = 17;
  int Rg8Snorm = 18;
  int R16Snorm = 19;
  int R8Snorm = 20;
  int Rgba32i = 21;
  int Rgba16i = 22;
  int Rgba8i = 23;
  int R32i = 24;
  int Rg32i = 25;
  int Rg16i = 26;
  int Rg8i = 27;
  int R16i = 28;
  int R8i = 29;
  int Rgba32ui = 30;
  int Rgba16ui = 31;
  int Rgba8ui = 32;
  int R32ui = 33;
  int Rgb10a2ui = 34;
  int Rg32ui = 35;
  int Rg16ui = 36;
  int Rg8ui = 37;
  int R16ui = 38;
  int R8ui = 39;
}

def SPIRVImageChannelOrder : Operand<i32> {
  let PrintMethod = "printSPIRVImageChannelOrder";

  int R = 0;
  int A = 1;
  int RG = 2;
  int RA = 3;
  int RGB = 4;
  int RGBA = 5;
  int BGRA = 6;
  int ARGB = 7;
  int Intensity = 8;
  int Luminance = 9;
  int Rx = 10;
  int RGx = 11;
  int RGBx = 12;
  int Depth = 13;
  int DepthStencil = 14;
  int sRGB = 15;
  int sRGBx = 16;
  int sRGBA = 17;
  int sBGRA = 18;
}

def SPIRVImageChannelDataType : Operand<i32> {
  let PrintMethod = "printSPIRVImageChannelDataType";

  int SnormInt8 = 0;
  int SnormInt16 = 1;
  int UnormInt8 = 2;
  int UnormInt16 = 3;
  int UnormShort565 = 4;
  int UnormShort555 = 5;
  int UnormInt101010 = 6;
  int SignedInt8 = 7;
  int SignedInt16 = 8;
  int SignedInt32 = 9;
  int UnsignedInt8 = 10;
  int UnsignedInt16 = 11;
  int UnsignedInt32 = 12;
  int HalfFloat = 13;
  int Float = 14;
  int UnormInt24 = 15;
  int UnormInt101010_2 = 16;
}

def SPIRVImageOperands : Operand<i32> {
  let PrintMethod = "printSPIRVImageOperands";

  int BiasShift = 0;
  int LodShift = 1;
  int GradShift = 2;
  int ConstOffsetShift = 3;
  int OffsetShift = 4;
  int ConstOffsetsShift = 5;
  int SampleShift = 6;
  int MinLodShift = 7;
  int MaskNone = 0;
  int BiasMask = 0x00000001;
  int LodMask = 0x00000002;
  int GradMask = 0x00000004;
  int ConstOffsetMask = 0x00000008;
  int OffsetMask = 0x00000010;
  int ConstOffsetsMask = 0x00000020;
  int SampleMask = 0x00000040;
  int MinLodMask = 0x00000080;
}

def SPIRVFPFastMathMode : Operand<i32> {
  let PrintMethod = "printSPIRVFPFastMathMode";

  int NotNaNShift = 0;
  int NotInfShift = 1;
  int NSZShift = 2;
  int AllowRecipShift = 3;
  int FastShift = 4;
  int MaskNone = 0;
  int NotNaNMask = 0x00000001;
  int NotInfMask = 0x00000002;
  int NSZMask = 0x00000004;
  int AllowRecipMask = 0x00000008;
  int FastMask = 0x00000010;
}

def SPIRVFPRoundingMode : Operand<i32> {
  let PrintMethod = "printSPIRVFPRoundingMode";

  int RTE = 0;
  int RTZ = 1;
  int RTP = 2;
  int RTN = 3;
}

def SPIRVLinkageType : Operand<i32> {
  let PrintMethod = "printSPIRVLinkageType";

  int Export = 0;
  int Import = 1;
}

def SPIRVAccessQualifier : Operand<i32> {
  let PrintMethod = "printSPIRVAccessQualifier";

  int ReadOnly = 0;
  int WriteOnly = 1;
  int ReadWrite = 2;
}

def SPIRVFunctionParameterAttribute : Operand<i32> {
  let PrintMethod = "printSPIRVFunctionParameterAttribute";

  int Zext = 0;
  int Sext = 1;
  int ByVal = 2;
  int Sret = 3;
  int NoAlias = 4;
  int NoCapture = 5;
  int NoWrite = 6;
  int NoReadWrite = 7;
}

def SPIRVDecoration : Operand<i32> {
  let PrintMethod = "printSPIRVDecoration";

  int RelaxedPrecision = 0;
  int SpecId = 1;
  int Block = 2;
  int BufferBlock = 3;
  int RowMajor = 4;
  int ColMajor = 5;
  int ArrayStride = 6;
  int MatrixStride = 7;
  int GLSLShared = 8;
  int GLSLPacked = 9;
  int CPacked = 10;
  int BuiltIn = 11;
  int NoPerspective = 13;
  int Flat = 14;
  int Patch = 15;
  int Centroid = 16;
  int Sample = 17;
  int Invariant = 18;
  int Restrict = 19;
  int Aliased = 20;
  int Volatile = 21;
  int Constant = 22;
  int Coherent = 23;
  int NonWritable = 24;
  int NonReadable = 25;
  int Uniform = 26;
  int SaturatedConversion = 28;
  int Stream = 29;
  int Location = 30;
  int Component = 31;
  int Index = 32;
  int Binding = 33;
  int DescriptorSet = 34;
  int Offset = 35;
  int XfbBuffer = 36;
  int XfbStride = 37;
  int FuncParamAttr = 38;
  int FPRoundingMode = 39;
  int FPFastMathMode = 40;
  int LinkageAttributes = 41;
  int NoContraction = 42;
  int InputAttachmentIndex = 43;
  int Alignment = 44;
}

def SPIRVBuiltIn : Operand<i32> {
  let PrintMethod = "printSPIRVBuiltIn";

  int Position = 0;
  int PointSize = 1;
  int ClipDistance = 3;
  int CullDistance = 4;
  int VertexId = 5;
  int InstanceId = 6;
  int PrimitiveId = 7;
  int InvocationId = 8;
  int Layer = 9;
  int ViewportIndex = 10;
  int TessLevelOuter = 11;
  int TessLevelInner = 12;
  int TessCoord = 13;
  int PatchVertices = 14;
  int FragCoord = 15;
  int PointCoord = 16;
  int FrontFacing = 17;
  int SampleId = 18;
  int SamplePosition = 19;
  int SampleMask = 20;
  int FragDepth = 22;
  int HelperInvocation = 23;
  int NumWorkgroups = 24;
  int WorkgroupSize = 25;
  int WorkgroupId = 26;
  int LocalInvocationId = 27;
  int GlobalInvocationId = 28;
  int LocalInvocationIndex = 29;
  int WorkDim = 30;
  int GlobalSize = 31;
  int EnqueuedWorkgroupSize = 32;
  int GlobalOffset = 33;
  int GlobalLinearId = 34;
  int SubgroupSize = 36;
  int SubgroupMaxSize = 37;
  int NumSubgroups = 38;
  int NumEnqueuedSubgroups = 39;
  int SubgroupId = 40;
  int SubgroupLocalInvocationId = 41;
  int VertexIndex = 42;
  int InstanceIndex = 43;
}

def SPIRVSelectionControl : Operand<i32> {
  let PrintMethod = "printSPIRVSelectionControl";

  int FlattenShift = 0;
  int DontFlattenShift = 1;
  int MaskNone = 0;
  int FlattenMask = 0x00000001;
  int DontFlattenMask = 0x00000002;
}

def SPIRVLoopControl : Operand<i32> {
  let PrintMethod = "printSPIRVLoopControl";

  int UnrollShift = 0;
  int DontUnrollShift = 1;
  int MaskNone = 0;
  int UnrollMask = 0x00000001;
  int DontUnrollMask = 0x00000002;
}

def SPIRVFunctionControl : Operand<i32> {
  let PrintMethod = "printSPIRVFunctionControl";

  int InlineShift = 0;
  int DontInlineShift = 1;
  int PureShift = 2;
  int ConstShift = 3;
  int MaskNone = 0;
  int InlineMask = 0x00000001;
  int DontInlineMask = 0x00000002;
  int PureMask = 0x00000004;
  int ConstMask = 0x00000008;
  int MaskMax = 0xF;
}

def SPIRVMemorySemantics : Operand<i32> {
  let PrintMethod = "printSPIRVMemorySemantics";

  int AcquireShift = 1;
  int ReleaseShift = 2;
  int AcquireReleaseShift = 3;
  int SequentiallyConsistentShift = 4;
  int UniformMemoryShift = 6;
  int SubgroupMemoryShift = 7;
  int WorkgroupMemoryShift = 8;
  int CrossWorkgroupMemoryShift = 9;
  int AtomicCounterMemoryShift = 10;
  int ImageMemoryShift = 11;
  int MaskNone = 0;
  int AcquireMask = 0x00000002;
  int ReleaseMask = 0x00000004;
  int AcquireReleaseMask = 0x00000008;
  int SequentiallyConsistentMask = 0x00000010;
  int UniformMemoryMask = 0x00000040;
  int SubgroupMemoryMask = 0x00000080;
  int WorkgroupMemoryMask = 0x00000100;
  int CrossWorkgroupMemoryMask = 0x00000200;
  int AtomicCounterMemoryMask = 0x00000400;
  int ImageMemoryMask = 0x00000800;
}

def SPIRVMemoryAccess : Operand<i32> {
  let PrintMethod = "printSPIRVMemoryAccess";

  int VolatileShift = 0;
  int AlignedShift = 1;
  int NontemporalShift = 2;
  int MaskNone = 0;
  int VolatileMask = 0x00000001;
  int AlignedMask = 0x00000002;
  int NontemporalMask = 0x00000004;
}

def SPIRVScope : Operand<i32> {
  let PrintMethod = "printSPIRVScope";

  int CrossDevice = 0;
  int Device = 1;
  int Workgroup = 2;
  int Subgroup = 3;
  int Invocation = 4;
}

def SPIRVGroupOperation : Operand<i32> {
  let PrintMethod = "printSPIRVGroupOperation";

  int Reduce = 0;
  int InclusiveScan = 1;
  int ExclusiveScan = 2;
}

def SPIRVKernelEnqueueFlags : Operand<i32> {
  let PrintMethod = "printSPIRVKernelEnqueueFlags";

  int NoWait = 0;
  int WaitKernel = 1;
  int WaitWorkGroup = 2;
}

def SPIRVKernelProfilingInfo : Operand<i32> {
  let PrintMethod = "printSPIRVKernelProfilingInfo";

  int CmdExecTimeShift = 0;
  int MaskNone = 0;
  int CmdExecTimeMask = 0x00000001;
}

class SPIRVCapability_ {
  int Matrix = 0;
  int Shader = 1;
  int Geometry = 2;
  int Tessellation = 3;
  int Addresses = 4;
  int Linkage = 5;
  int Kernel = 6;
  int Vector16 = 7;
  int Float16Buffer = 8;
  int Float16 = 9;
  int Float64 = 10;
  int Int64 = 11;
  int Int64Atomics = 12;
  int ImageBasic = 13;
  int ImageReadWrite = 14;
  int ImageMipmap = 15;
  int Pipes = 17;
  int Groups = 18;
  int DeviceEnqueue = 19;
  int LiteralSampler = 20;
  int AtomicStorage = 21;
  int Int16 = 22;
  int TessellationPointSize = 23;
  int GeometryPointSize = 24;
  int ImageGatherExtended = 25;
  int StorageImageMultisample = 27;
  int UniformBufferArrayDynamicIndexing = 28;
  int SampledImageArrayDynamicIndexing = 29;
  int StorageBufferArrayDynamicIndexing = 30;
  int StorageImageArrayDynamicIndexing = 31;
  int ClipDistance = 32;
  int CullDistance = 33;
  int ImageCubeArray = 34;
  int SampleRateShading = 35;
  int ImageRect = 36;
  int SampledRect = 37;
  int GenericPointer = 38;
  int Int8 = 39;
  int InputAttachment = 40;
  int SparseResidency = 41;
  int MinLod = 42;
  int Sampled1D = 43;
  int Image1D = 44;
  int SampledCubeArray = 45;
  int SampledBuffer = 46;
  int ImageBuffer = 47;
  int ImageMSArray = 48;
  int StorageImageExtendedFormats = 49;
  int ImageQuery = 50;
  int DerivativeControl = 51;
  int InterpolationFunction = 52;
  int TransformFeedback = 53;
  int GeometryStreams = 54;
  int StorageImageReadWithoutFormat = 55;
  int StorageImageWriteWithoutFormat = 56;
}
def SPIRVCapability : SPIRVCapability_;

def SPIRVOp : Operand<i32> {
  let PrintMethod = "printSPIRVOp";

  int Nop = 0;
  int Undef = 1;
  int SourceContinued = 2;
  int Source = 3;
  int SourceExtension = 4;
  int Name = 5;
  int MemberName = 6;
  int String = 7;
  int Line = 8;
  int Extension = 10;
  int ExtInstImport = 11;
  int ExtInst = 12;
  int MemoryModel = 14;
  int EntryPoint = 15;
  int ExecutionMode = 16;
  int Capability = 17;
  int TypeVoid = 19;
  int TypeBool = 20;
  int TypeInt = 21;
  int TypeFloat = 22;
  int TypeVector = 23;
  int TypeMatrix = 24;
  int TypeImage = 25;
  int TypeSampler = 26;
  int TypeSampledImage = 27;
  int TypeArray = 28;
  int TypeRuntimeArray = 29;
  int TypeStruct = 30;
  int TypeOpaque = 31;
  int TypePointer = 32;
  int TypeFunction = 33;
  int TypeEvent = 34;
  int TypeDeviceEvent = 35;
  int TypeReserveId = 36;
  int TypeQueue = 37;
  int TypePipe = 38;
  int TypeForwardPointer = 39;
  int ConstantTrue = 41;
  int ConstantFalse = 42;
  int Constant = 43;
  int ConstantComposite = 44;
  int ConstantSampler = 45;
  int ConstantNull = 46;
  int SpecConstantTrue = 48;
  int SpecConstantFalse = 49;
  int SpecConstant = 50;
  int SpecConstantComposite = 51;
  int SpecConstantOp = 52;
  int Function = 54;
  int FunctionParameter = 55;
  int FunctionEnd = 56;
  int FunctionCall = 57;
  int Variable = 59;
  int ImageTexelPointer = 60;
  int Load = 61;
  int Store = 62;
  int CopyMemory = 63;
  int CopyMemorySized = 64;
  int AccessChain = 65;
  int InBoundsAccessChain = 66;
  int PtrAccessChain = 67;
  int ArrayLength = 68;
  int GenericPtrMemSemantics = 69;
  int InBoundsPtrAccessChain = 70;
  int Decorate = 71;
  int MemberDecorate = 72;
  int DecorationGroup = 73;
  int GroupDecorate = 74;
  int GroupMemberDecorate = 75;
  int VectorExtractDynamic = 77;
  int VectorInsertDynamic = 78;
  int VectorShuffle = 79;
  int CompositeConstruct = 80;
  int CompositeExtract = 81;
  int CompositeInsert = 82;
  int CopyObject = 83;
  int Transpose = 84;
  int SampledImage = 86;
  int ImageSampleImplicitLod = 87;
  int ImageSampleExplicitLod = 88;
  int ImageSampleDrefImplicitLod = 89;
  int ImageSampleDrefExplicitLod = 90;
  int ImageSampleProjImplicitLod = 91;
  int ImageSampleProjExplicitLod = 92;
  int ImageSampleProjDrefImplicitLod = 93;
  int ImageSampleProjDrefExplicitLod = 94;
  int ImageFetch = 95;
  int ImageGather = 96;
  int ImageDrefGather = 97;
  int ImageRead = 98;
  int ImageWrite = 99;
  int Image = 100;
  int ImageQueryFormat = 101;
  int ImageQueryOrder = 102;
  int ImageQuerySizeLod = 103;
  int ImageQuerySize = 104;
  int ImageQueryLod = 105;
  int ImageQueryLevels = 106;
  int ImageQuerySamples = 107;
  int ConvertFToU = 109;
  int ConvertFToS = 110;
  int ConvertSToF = 111;
  int ConvertUToF = 112;
  int UConvert = 113;
  int SConvert = 114;
  int FConvert = 115;
  int QuantizeToF16 = 116;
  int ConvertPtrToU = 117;
  int SatConvertSToU = 118;
  int SatConvertUToS = 119;
  int ConvertUToPtr = 120;
  int PtrCastToGeneric = 121;
  int GenericCastToPtr = 122;
  int GenericCastToPtrExplicit = 123;
  int Bitcast = 124;
  int SNegate = 126;
  int FNegate = 127;
  int IAdd = 128;
  int FAdd = 129;
  int ISub = 130;
  int FSub = 131;
  int IMul = 132;
  int FMul = 133;
  int UDiv = 134;
  int SDiv = 135;
  int FDiv = 136;
  int UMod = 137;
  int SRem = 138;
  int SMod = 139;
  int FRem = 140;
  int FMod = 141;
  int VectorTimesScalar = 142;
  int MatrixTimesScalar = 143;
  int VectorTimesMatrix = 144;
  int MatrixTimesVector = 145;
  int MatrixTimesMatrix = 146;
  int OuterProduct = 147;
  int Dot = 148;
  int IAddCarry = 149;
  int ISubBorrow = 150;
  int UMulExtended = 151;
  int SMulExtended = 152;
  int Any = 154;
  int All = 155;
  int IsNan = 156;
  int IsInf = 157;
  int IsFinite = 158;
  int IsNormal = 159;
  int SignBitSet = 160;
  int LessOrGreater = 161;
  int Ordered = 162;
  int Unordered = 163;
  int LogicalEqual = 164;
  int LogicalNotEqual = 165;
  int LogicalOr = 166;
  int LogicalAnd = 167;
  int LogicalNot = 168;
  int Select = 169;
  int IEqual = 170;
  int INotEqual = 171;
  int UGreaterThan = 172;
  int SGreaterThan = 173;
  int UGreaterThanEqual = 174;
  int SGreaterThanEqual = 175;
  int ULessThan = 176;
  int SLessThan = 177;
  int ULessThanEqual = 178;
  int SLessThanEqual = 179;
  int FOrdEqual = 180;
  int FUnordEqual = 181;
  int FOrdNotEqual = 182;
  int FUnordNotEqual = 183;
  int FOrdLessThan = 184;
  int FUnordLessThan = 185;
  int FOrdGreaterThan = 186;
  int FUnordGreaterThan = 187;
  int FOrdLessThanEqual = 188;
  int FUnordLessThanEqual = 189;
  int FOrdGreaterThanEqual = 190;
  int FUnordGreaterThanEqual = 191;
  int ShiftRightLogical = 194;
  int ShiftRightArithmetic = 195;
  int ShiftLeftLogical = 196;
  int BitwiseOr = 197;
  int BitwiseXor = 198;
  int BitwiseAnd = 199;
  int Not = 200;
  int BitFieldInsert = 201;
  int BitFieldSExtract = 202;
  int BitFieldUExtract = 203;
  int BitReverse = 204;
  int BitCount = 205;
  int DPdx = 207;
  int DPdy = 208;
  int Fwidth = 209;
  int DPdxFine = 210;
  int DPdyFine = 211;
  int FwidthFine = 212;
  int DPdxCoarse = 213;
  int DPdyCoarse = 214;
  int FwidthCoarse = 215;
  int EmitVertex = 218;
  int EndPrimitive = 219;
  int EmitStreamVertex = 220;
  int EndStreamPrimitive = 221;
  int ControlBarrier = 224;
  int MemoryBarrier = 225;
  int AtomicLoad = 227;
  int AtomicStore = 228;
  int AtomicExchange = 229;
  int AtomicCompareExchange = 230;
  int AtomicCompareExchangeWeak = 231;
  int AtomicIIncrement = 232;
  int AtomicIDecrement = 233;
  int AtomicIAdd = 234;
  int AtomicISub = 235;
  int AtomicSMin = 236;
  int AtomicUMin = 237;
  int AtomicSMax = 238;
  int AtomicUMax = 239;
  int AtomicAnd = 240;
  int AtomicOr = 241;
  int AtomicXor = 242;
  int Phi = 245;
  int LoopMerge = 246;
  int SelectionMerge = 247;
  int Label = 248;
  int Branch = 249;
  int BranchConditional = 250;
  int Switch = 251;
  int Kill = 252;
  int Return = 253;
  int ReturnValue = 254;
  int Unreachable = 255;
  int LifetimeStart = 256;
  int LifetimeStop = 257;
  int GroupAsyncCopy = 259;
  int GroupWaitEvents = 260;
  int GroupAll = 261;
  int GroupAny = 262;
  int GroupBroadcast = 263;
  int GroupIAdd = 264;
  int GroupFAdd = 265;
  int GroupFMin = 266;
  int GroupUMin = 267;
  int GroupSMin = 268;
  int GroupFMax = 269;
  int GroupUMax = 270;
  int GroupSMax = 271;
  int ReadPipe = 274;
  int WritePipe = 275;
  int ReservedReadPipe = 276;
  int ReservedWritePipe = 277;
  int ReserveReadPipePackets = 278;
  int ReserveWritePipePackets = 279;
  int CommitReadPipe = 280;
  int CommitWritePipe = 281;
  int IsValidReserveId = 282;
  int GetNumPipePackets = 283;
  int GetMaxPipePackets = 284;
  int GroupReserveReadPipePackets = 285;
  int GroupReserveWritePipePackets = 286;
  int GroupCommitReadPipe = 287;
  int GroupCommitWritePipe = 288;
  int EnqueueMarker = 291;
  int EnqueueKernel = 292;
  int GetKernelNDrangeSubGroupCount = 293;
  int GetKernelNDrangeMaxSubGroupSize = 294;
  int GetKernelWorkGroupSize = 295;
  int GetKernelPreferredWorkGroupSizeMultiple = 296;
  int RetainEvent = 297;
  int ReleaseEvent = 298;
  int CreateUserEvent = 299;
  int IsValidEvent = 300;
  int SetUserEventStatus = 301;
  int CaptureEventProfilingInfo = 302;
  int GetDefaultQueue = 303;
  int BuildNDRange = 304;
  int ImageSparseSampleImplicitLod = 305;
  int ImageSparseSampleExplicitLod = 306;
  int ImageSparseSampleDrefImplicitLod = 307;
  int ImageSparseSampleDrefExplicitLod = 308;
  int ImageSparseSampleProjImplicitLod = 309;
  int ImageSparseSampleProjExplicitLod = 310;
  int ImageSparseSampleProjDrefImplicitLod = 311;
  int ImageSparseSampleProjDrefExplicitLod = 312;
  int ImageSparseFetch = 313;
  int ImageSparseGather = 314;
  int ImageSparseDrefGather = 315;
  int ImageSparseTexelsResident = 316;
  int NoLine = 317;
  int AtomicFlagTestAndSet = 318;
  int AtomicFlagClear = 319;
  int Forward = 1024;
}

