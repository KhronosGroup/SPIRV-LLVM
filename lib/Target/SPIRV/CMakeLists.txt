set(LLVM_TARGET_DEFINITIONS SPIRV.td)

tablegen(LLVM SPIRVGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM SPIRVGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM SPIRVGenDAGISel.inc -gen-dag-isel)
tablegen(LLVM SPIRVGenSubtarget.inc -gen-subtarget)
tablegen(LLVM SPIRVGenIntrinsics.inc -gen-tgt-intrinsic)
add_public_tablegen_target(SPIRVCommonTableGen)

add_llvm_target(SPIRVCodeGen
  SPIRVAsmPrinter.cpp
  SPIRVFrameLowering.cpp
  SPIRVInstrInfo.cpp
  SPIRVISelDAGToDAG.cpp
  SPIRVISelLowering.cpp
  SPIRVRegisterInfo.cpp
  SPIRVSubtarget.cpp
  SPIRVTargetMachine.cpp
  )

add_subdirectory(TargetInfo)
add_subdirectory(MCTargetDesc)

