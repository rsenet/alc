# ALC (Android Lib Compilator)

![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)
![Docker](https://img.shields.io/badge/Docker-ready-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Android](https://img.shields.io/badge/Android_NDK-r26d-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![ABI](https://img.shields.io/badge/Target_ABI-arm64--v8a-000000?style=for-the-badge)

<br />
<div align="center">
  <h3 align="center">ALC (Android Lib Compilator)</h3>

  <p align="center">
    Build Android shared libraries (<code>.so</code>) from C/C++ using the Android NDK inside Docker.
    <br />
    <em>Reproducible, portable, and no local NDK install required.</em>
  </p>
</div>


## What is ALC?

**ALC** provides a **Dockerfile** and ready-to-run **commands** to:

- Download **Android NDK r26d**
- **Cross-compile** a C/C++ source file into a **shared library `.so`** for **arm64-v8a** (API level 21 by default)
- Export the build artifact to your host via a mounted volume

> Typical use case: compile a minimal native snippet (e.g., a `JNI_OnLoad`-based library) without setting up a full local NDK/CMake toolchain.


## Requirements

- **Docker** installed and running
- A C source file (e.g., `native-lib.c`)
- (Optional) **ADB** if you want to push/test the library on a device


## Project layout

```
alc-docker/
├─ Dockerfile
└─ native-lib.c   # Your C code (example below)
```

Example `native-lib.c` (mirrors the reference snippet):

```c
#include <jni.h>
#include <stdlib.h>

JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void* reserved) {
    system();
    return JNI_VERSION_1_6;
}
```


## Usage

### 1) Build the image

#### macOS Apple Silicon (M1/M2/M3) — recommended

Force the x86_64 platform to use the NDK's `linux-x86_64` prebuilt toolchain:

```bash
docker build --platform=linux/amd64 -t alc-ndk-arm64 .
```

#### x86_64 host (Linux/macOS Intel/Windows WSL)

```bash
docker build -t alc-ndk-arm64 .
```

> The image downloads Android NDK **r26d** and exports `aarch64-linux-android21-clang++` in `PATH`.

### 2) Compile and extract the `.so`

Create a local output directory:

```bash
mkdir -p out
```

Run the container to copy the artifact:

```bash
# On Apple Silicon, add: --platform=linux/amd64
docker run --rm   -v "$PWD/out":/host_out   alc-ndk-arm64   /bin/bash -lc 'cp /out/libmylib.so /host_out/'
```

You should get:
```
./out/libmylib.so
```

### 3) Verify the library ABI

On the host:

```bash
file out/libmylib.so
# Expected: ELF 64-bit LSB shared object, ARM aarch64, ...
```

### 4) Load the library in your Android app

The produced artifact is **libmylib.so**, so in Java/Kotlin:

```java
static {
    System.loadLibrary("mylib"); // omit the "lib" prefix and ".so" suffix
}
```


## Contributing

Contributions are welcome!

To contribute:

1. Fork the repository
2. Create a feature branch (git checkout -b feature/my-feature)
3. Commit your changes (git commit -m 'feat: my feature')
4. Push to your branch (git push origin feature/my-feature)
5. Open a Pull Request



## Author

**Régis SENET**  
[https://github.com/rsenet](https://github.com/rsenet)



## License

This project is licensed under the [GPLv3 License](https://www.gnu.org/licenses/quick-guide-gplv3.en.html)
