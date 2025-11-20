#!/bin/bash

# 4.x
modules=("calib3d" "core" "features2d" "imgproc" "objdetect")
# 5.x
#modules=("3d" "calib" "core" "features" "imgproc" "objdetect" "stereo")

BASELINE="BCM2711"
if [ $# -eq 1 ]; then
    BASELINE="$1"
fi

for module in "${modules[@]}"; do
    base_file="perf/${module}-${BASELINE}.xml"
    pattern="perf/${module}*.xml"

    echo "Comparing results of module: $module ..."

    # Check baseline file exists
    if [ ! -f "$base_file" ]; then
        echo "ERROR: Baseline file not found: $base_file"
        continue
    fi

    shopt -s nullglob
    matches=( $pattern )
    shopt -u nullglob

    # if the only match is the baseline file
    if [ ${#matches[@]} -eq 1 ]; then
        echo "ERROR: No comparison files found for module: $module"
        continue
    fi

    # Run comparison
    python3 opencv/modules/ts/misc/summary.py "$base_file" "$pattern" -o html > "perf/${module}.html"
    echo "Generated: perf/${module}.html"
done
