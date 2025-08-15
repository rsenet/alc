#include <jni.h>
#include <stdlib.h>

JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void* reserved) {
    system();
    return JNI_VERSION_1_6;
}