; RUN: llvm-as %s -o %t.bc
; RUN: llvm-spirv %t.bc -o %t.spv
; RUN: llvm-spirv -r %t.spv -o %t2.bc
; RUN: llvm-dis < %t2.bc | FileCheck %s --check-prefix=CHECK-LLVM

; CHECK-LLVM: entry:
; CHECK-LLVM: %agg1 = insertvalue %{{[0-9]*}} undef
; CHECK-LLVM: ret void

target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir64-unknown-unknown"

%0 = type { i32, float }

; Function Attrs: nounwind
define spir_func void @foo() #0 {
entry:
  %agg1 = insertvalue %0 undef, i32 1, 0
  ret void
}

attributes #0 = { nounwind }

!opencl.kernels = !{}
!opencl.enable.FP_CONTRACT = !{}
!spirv.Source = !{!0}
!opencl.spir.version = !{!1}
!opencl.ocl.version = !{!1}
!opencl.used.extensions = !{!2}
!opencl.used.optional.core.features = !{!2}
!spirv.Generator = !{!3}

!0 = !{i32 3, i32 200000}
!1 = !{i32 2, i32 0}
!2 = !{}
!3 = !{i16 6, i16 14}

