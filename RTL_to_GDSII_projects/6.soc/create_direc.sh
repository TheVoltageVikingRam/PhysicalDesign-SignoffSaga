#!/bin/bash

PROJECT_DIR="soc_design"

echo "Creating project directory structure inside '$PROJECT_DIR'..."

# Create root project directory
mkdir -p "$PROJECT_DIR"

# Apps directories
mkdir -p "$PROJECT_DIR/apps/bubblesort"
mkdir -p "$PROJECT_DIR/apps/libs/bench_lib/inc"
mkdir -p "$PROJECT_DIR/apps/libs/bench_lib/src"
mkdir -p "$PROJECT_DIR/apps/libs/iosim_lib/inc"
mkdir -p "$PROJECT_DIR/apps/libs/iosim_lib/src"
mkdir -p "$PROJECT_DIR/apps/libs/string_lib/inc"
mkdir -p "$PROJECT_DIR/apps/libs/string_lib/src"
mkdir -p "$PROJECT_DIR/apps/libs/sys_lib/inc"
mkdir -p "$PROJECT_DIR/apps/libs/sys_lib/src"
mkdir -p "$PROJECT_DIR/apps/ref"
mkdir -p "$PROJECT_DIR/apps/sw_utils"

# Root level project directories
mkdir -p "$PROJECT_DIR/dbs"
mkdir -p "$PROJECT_DIR/docs"
mkdir -p "$PROJECT_DIR/export"
mkdir -p "$PROJECT_DIR/inputs"
mkdir -p "$PROJECT_DIR/libraries"

# Memory generation directories
mkdir -p "$PROJECT_DIR/mem_gen/SP_16384X32/M16"
mkdir -p "$PROJECT_DIR/mem_gen/SP_16384X32/M32"

# Reports and Scripts
mkdir -p "$PROJECT_DIR/reports"
mkdir -p "$PROJECT_DIR/scripts"

# Sourcecode (RTL and Testbenches) directories
mkdir -p "$PROJECT_DIR/sourcecode/rtl/riscv-master/include"
mkdir -p "$PROJECT_DIR/sourcecode/rtl/soc/components"
mkdir -p "$PROJECT_DIR/sourcecode/tb/slm_files"

# Workspace
mkdir -p "$PROJECT_DIR/workspace"

echo "Directory structure created successfully inside '$PROJECT_DIR'!"
