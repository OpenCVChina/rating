# Rating

Scripts to rate SBCs (Single Board Computer) with OpenCV Performance Testings.

## Get scores with Rating

```bash
bash build.sh
bash run.sh
bash compare.sh
python rate.py
```

Example scores (Mac Mini M2 vs. Intel i7-12700K):

```
Module          Average Score
calib3d         101.86
core            133.77
dnn             65.79
features2d      87.77
imgcodecs       103.83
imgproc         106.24
objdetect       79.39
photo           162.23
stitching       131.80
video           44.34
videoio         65.60
```

## License

This project is licensed under [Apache 2.0 License](./LICENSE).
