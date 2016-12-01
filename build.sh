

export NDK=/ndk/android-ndk-r10e
export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt
export PLATFORM=$NDK/platforms/android-8/arch-arm
export PREFIX=./ffmpeg_android

./configure	\
	--target-os=linux	\
	--prefix=$PREFIX	\
	--enable-cross-compile	\
	--enable-runtime-cpudetect	\
	--disable-asm	\
	--arch=arm	\
	--cc=$PREBUILT/linux-x86/bin/arm-linux-androideabi-gcc	\
	--cross-prefix=$PREBUILT/linux-x86/bin/arm-linux-androideabi-	\
	--disable-stripping	\
	--nm=$PREBUILT/linux-x86/bin/arm-linux-androideabi-nm	\
	--sysroot=/ndk/android-ndk-r10e/platforms/android-8/arch-arm	\
	--enable-gpl	\
	--disable-shared	\
	--enable-static	\
	--enable-small	\
	--disable-ffprobe	\
	--disable-ffplay	\
	--disable-ffmpeg	\
	--disable-ffserver	\
	--disable-debug 	\
	--extra-cflags="-fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -marm -march=armv7-a"

# if you want to support the x264 , need to add the folloing
# in --extra-clfags add the "-I../x264_android/include", this is the x264-android include
# add the --extra-ldflags="-L../x264_android/lib"

make

make install

export ANDROID_LD=/ndk/android-ndk-r10e/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86/bin/arm-linux-androideabi-ld

$ANDROID_LD	\
	-rpath-link=$PLATFORM/usr/lib	\
	-L$PLATFORM/usr/lib	\
	-L.	\
	-soname libffmpeg.so	\
	-shared -nostdlib	-Bsymbolic	--whole-archive	--no-undefined	\
	-o libffmpeg.so	./ffmpeg_android/lib/*.a	\
	-lc -lm -lz -ldl -llog	\
	--dynamic-linker=/system/bin/linker	\
	$PREBUILT/linux-x86/lib/gcc/arm-linux-androideabi/4.8/libgcc.a

	


