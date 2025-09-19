import pandas as pd
import re
import argparse

parser = argparse.ArgumentParser(description="Process OpenCV performance results.")
parser.add_argument(
    "--output", default="score.md",
    help="Output Markdown filename"
)
parser.add_argument(
    "--modules", nargs="+", 
    help="Module Name(s)"
)
args = parser.parse_args()
output_file = args.output

# 4.x
modules=["calib3d" "core" "features2d" "imgproc" "objdetect" "photo" "stitching" "video"]
# 5.x
#modules=["3d" "calib" "core" "features" "imgproc" "objdetect" "photo" "stereo" "stitching" "video"]
if args.modules:
    modules = args.modules

result = dict()
result["module"] = []

df = pd.read_html(f"perf/{modules[0]}.html")[0]
rows, cols = df.shape
dev_types = [re.search(r'-(.*?)\s+vs', s).group(1) for s in df.columns.tolist()[cols//2+1:cols]]

for module in modules:
    result["module"].append(module)

    df = pd.read_html(f"perf/{module}.html")[0]
    df = df[df.iloc[:, cols//2+1:cols] != "-"]
    df.iloc[:, cols//2+1:cols] = df.iloc[:, cols//2+1:cols].apply(pd.to_numeric)
    score = df.iloc[:, cols//2+1:cols].mean() * 100
    score = score.values.tolist()
    for (i, dev_type) in enumerate(dev_types):
        if dev_type not in result:

            result[dev_type] = []
        result[dev_type].append(score[i])

df = pd.DataFrame(result)

mean_scores = df.drop(columns="module").mean()
df.loc['Mean'] = ['Mean'] + mean_scores.tolist()
numeric_cols = df.select_dtypes(include="number").columns
df[numeric_cols] = df[numeric_cols].round(2)

with open(output_file, "w") as f:
    f.write(df.to_markdown(index=False))
print(df.to_string(index=False))