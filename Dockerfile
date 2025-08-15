# Minimal Debian image + Android NDK
FROM debian:bookworm-slim

ARG NDK_VERSION=r26d
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl unzip file \
 && rm -rf /var/lib/apt/lists/*

# Download and extract Android NDK
RUN curl -L "https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux.zip" -o /tmp/ndk.zip \
 && unzip -q /tmp/ndk.zip -d /opt \
 && rm /tmp/ndk.zip
ENV ANDROID_NDK_HOME=/opt/android-ndk-${NDK_VERSION}
ENV PATH="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH"

# Working directory
WORKDIR /work
COPY . /work

# Output directory
RUN mkdir -p /out

# Compile for arm64-v8a (API 21) -> libmylib.so
# Using clang (not clang++) to avoid linking against libc++_shared.so
RUN aarch64-linux-android21-clang -fPIC -shared \
    -o /out/libmylib.so /work/native-lib.c

# Basic ABI check
RUN file /out/libmylib.so
