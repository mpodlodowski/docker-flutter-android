# flutter-android
This is the git repo for [mpodlodowski/flutter-android](https://hub.docker.com/r/mpodlodowski/flutter-android) image.

The image consists of several components needed to build flutter images and distribute them for android:
- java 8 (needed by android tools)
- android sdk
- flutter
- dart in the latest version (sometimes flutter packages require dart >=2.1.0 which is not a part of stable flutter yet)

## Build
```
docker build -t mpodlodowski/flutter-android .
docker push mpodlodowski/flutter-android
```