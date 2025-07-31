import pandas as pd

modules = [
    "calib3d",
    "core",
    "dnn",
    "features2d",
    "imgcodecs",
    "imgproc",
    "objdetect",
    "photo",
    "stitching",
    "video",
    "videoio",
]

result = dict()

print("{:<11}\t{}".format("Module", "Average Score"))
for module in modules:
    df = pd.read_html(f"perf/{module}.html")[0]
    df = df[df.iloc[:, 3] != "-"]
    df.iloc[:, 3] = df.iloc[:, 3].apply(pd.to_numeric)
    score = df.iloc[:, 3].mean() * 100
    result[module] = score
    print(f"{module:<11}\t{score:.2f}")
