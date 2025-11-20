#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <cpu model> [opencv module]"
  printf "  %-16s %s\n" "-cpu model" "the model name of the target CPU"
  printf "  %-16s %s\n" "-opencv module" "default modules will be tested if no module specified: calib3d, core, features2d, imgproc, objdetect"
  echo "Example:"
  printf "  %-7s %s\n" "$0" "'Rockchip RK3568'"
  printf "  %-7s %s %s\n" "$0" "'Rockchip RK3568'" "imgproc"
  exit 1
fi

# Get the opencv_extra
if [ ! -d "opencv_extra" ]; then
    echo "Cannot find opencv_extra. Updating submodules."
    git submodule update --init --remote opencv_extra
elif [ -z "$(ls -A "opencv_extra")" ]; then
    echo "opencv_extra is empty. Updating submodules."
    git submodule update --init --remote opencv_extra
fi

# 4.x
modules=("calib3d" "core" "features2d" "imgproc" "objdetect")
# 5.x
#modules=("3d" "calib" "core" "features" "imgproc" "objdetect" "stereo")
if [ $# -ge 2 ]; then
    modules=("${@:2}")
fi

RESULT_DIR=perf/
if [ ! -d ${RESULT_DIR} ]; then
    mkdir ${RESULT_DIR}
fi

export OPENCV_TEST_DATA_PATH=$(pwd)/opencv_extra/testdata
for module in "${modules[@]}"; do
    echo "PERFORMANCE TEST MODULE: $module"
    ./build/bin/opencv_perf_${module} --gtest_output=xml:"${RESULT_DIR}/${module}-${1}.xml" --perf_force_samples=50 --perf_min_samples=50
done
echo "Performance testing finished."