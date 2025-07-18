#!/bin/bash
modules=("calib3d" "core" "dnn" "features2d" "flann" "gapi" "highgui" "imgcodecs" "imgproc" "java" "js" "ml" "objc" "objdetect" "photo" "python" "stitching" "ts" "video" "videoio" "world")

for module in "${modules[@]}"; do
    ./build/bin/opencv_perf_${module} --gtest_output=xml:perf-${module}.xml --perf_force_samples=50 --perf_min_samples=50
done
