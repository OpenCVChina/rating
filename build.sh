#!/bin/bash

# Check if a parameter is given
if [ $# -eq 0 ]; then
  echo "Usage: $0 <arch>"
  echo "Available architectures:"
  printf "  %-8s %s\n" "x86"    "x86 architecture"
  printf "  %-8s %s\n" "arm"    "ARM architecture"
  printf "  %-8s %s\n" "riscv"  "RISC-V (no vector extension)"
  printf "  %-8s %s\n" "riscvv" "RISC-V (Vector extension)"
  exit 1
fi

iarch="$1"
available_archs=("x86" "arm" "riscv" "riscvv")
found=false
for arch in "${available_archs[@]}"; do
    if [ "$iarch" == "$arch" ]; then
        found=true
        break
    fi
done

if [ "$found" == "false" ]; then
    echo "Unknown input arch: ${iarch}. Available architectures:"
    printf "  %-8s %s\n" "x86"    "x86 architecture"
    printf "  %-8s %s\n" "arm"    "ARM architecture"
    printf "  %-8s %s\n" "riscv"  "RISC-V (no vector extension)"
    printf "  %-8s %s\n" "riscvv" "RISC-V (Vector extension)"
    exit 1
else
    echo "Evaluating ..."
fi

# Get the latest opencv
if [ ! -d "opencv" ]; then
    echo "Cannot find opencv. Updating submodules."
    git submodule update --init --remote opencv
elif [ -z "$(ls -A "opencv")" ]; then
    echo "opencv is empty. Updating submodules."
    git submodule update --init --remote opencv
fi

# Configure and build opencv according to target platform
echo "Building OpenCV ..."
if [ ${iarch} = "riscvv" ]; then
    cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=build/install \
    -DWITH_OPENCL=OFF -DWITH_LAPACK=OFF -DWITH_EIGEN=OFF -DBUILD_TESTS=OFF \
    -DCPU_BASELINE=RVV -DCPU_BASELINE_REQUIRE=RVV -DRISCV_RVV_SCALABLE=ON opencv
    cmake --build build --target install -j$(nproc)
else
    cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=build/install \
    -DWITH_OPENCL=OFF -DWITH_LAPACK=OFF -DWITH_EIGEN=OFF -DBUILD_TESTS=OFF opencv
    cmake --build build --target install -j$(nproc)
fi
echo "OpenCV build finished."