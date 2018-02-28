import os
import fileinput

SPIRV_line = "\
; RUN: llvm-as < %s -o %t.bc\n\
; RUN: llvm-spirv %t.bc -o %t.spv\n\
; RUN: llvm-spirv -r %t.spv -o - | llvm-dis -o %t.ll\n"

Triple_line = "target triple = \"spir64-unknown-unknown\"\n"

DataLayuot_line = "target datalayout = \"e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-n8:16:32:64\"\n"

def addSPIRVLines(filename):
    FirstRun = True;
    #File = fileinput.FileInput(filename, inplace=1, backup=".bu")
    File = fileinput.FileInput(filename, inplace=1)
    hasTriple = False
    hasDataLayout = False
    for line in File:
        if "RUN:" in line and "llc" in line:
            if FirstRun == True:
                line = "".join([SPIRV_line, "\n", line.replace("%s","%t.ll", 1)])
                FirstRun = False;
            else:
                line = line.replace("%s", "%t.ll", 1)
        if "RUN:" in line and "mtriple" not in line:
            if "%llc_dwarf" in line:
                line = line.replace("%llc_dwarf", "%llc_dwarf -mtriple=%triple", 1)
            if " llc " in line:
                line = line.replace(" llc ", " llc -mtriple=%triple ", 1)
        if "target triple" in line:
            line = Triple_line
            hasTriple = True
        if "target datalayout" in line:
            hasDataLayout = True
        print line, # writes directly to filename, not to stdout!
    File.close()

    if not hasTriple or not hasDataLayout:
        with open(filename, "a") as f:
            if not hasTriple:
                #print filename
                f.write(Triple_line)
            if not hasDataLayout:
                f.write(DataLayuot_line)


CurrDir = os.path.dirname(os.path.realpath(__file__))
for root, dirs, files in os.walk(os.path.join(CurrDir, "DebugInfo")):
    for name in files:
        if name.endswith(".ll"):
            filename = os.path.join(root, name)
            addSPIRVLines(filename)

