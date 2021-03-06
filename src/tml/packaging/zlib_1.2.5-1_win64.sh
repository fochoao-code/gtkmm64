# This is a shell script that calls functions and scripts from
# tml@iki.fi's personal work environment. It is not expected to be
# usable unmodified by others, and is included only for reference.

MOD=zlib
VER=1.2.5
REV=1
ARCH=win64

THIS=${MOD}_${VER}-${REV}_${ARCH}

RUNZIP=${THIS}.zip
DEVZIP=${MOD}-dev_${VER}-${REV}_${ARCH}.zip

HEX=`echo $THIS | md5sum | cut -d' ' -f1`
TARGET=c:/devel/target/$HEX

usedev
usemingw64
usemsvs9x64

(

set -x

# The zlib makefilery is somewhat sucky, but it is just a simple DLL
# built out of a handful of source files, so just simply do the
# compilation here instead

# We produce a DLL with the name zlib1.dll. That is, as far as I can
# see from upstream documentation, the desired name for a zlib DLL
# that on 32-bit Windows uses the cdecl calling convention. Now, on
# 64-bit Windows there is just one calling convention. And upstream
# doesn't provide any 64-bit binaries. So the name to use is just a
# guesstimate on what would be least likely to cause any confusion.

patch -p0 <<'EOF'
--- ../zlib-1.2.5/zconf.h	2010-04-18 10:58:06 +0300
+++ zconf.h	2010-08-17 15:56:35 +0300
@@ -270,7 +270,31 @@
 #  endif
 #endif
 
+/* When a specific build of zlib is done on Windows, it is either a
+ * DLL or not. That build should have a specific corresponding zconf.h
+ * distributed. The zconf.h thus knows a priori whether the
+ * corresponding library was built as a DLL or not. Requiring the
+ * library user to define ZLIB_DLL when compiling, and intending to
+ * link against the import library for such a DLL build, is
+ * silly. Instead just unconditionally define ZLIB_DLL here as this
+ * build is a DLL, period.
+ *
+ * Similarly, when a specific build of zlib is done on (32-bit)
+ * Windows, it either uses the WINAPI calling convention or not. A
+ * user of a prebuilt library can not choose later. So it is pointless
+ * to require the user to define ZLIB_WINAPI when compiling. Instead,
+ * just have a specific copy of this zconf.h that corresponds to that
+ * build of zlib. In the case here, we don't build zlib with WINAPI,
+ * so ignore any attempt by a misguided user to use it.
+ */
+
+#undef ZLIB_DLL
+#define ZLIB_DLL 1
+
+#undef ZLIB_WINAPI
+
 #if defined(WINDOWS) || defined(WIN32)
+   /* NOTE: Bogus. See above comment about ZLIB_DLL */
    /* If building or using zlib as a DLL, define ZLIB_DLL.
     * This is not mandatory, but it offers a little performance increase.
     */
@@ -283,6 +307,8 @@
 #      endif
 #    endif
 #  endif  /* ZLIB_DLL */
+
+   /* NOTE: Bogus. See above comment about ZLIB_WINAPI */
    /* If building or using zlib with the WINAPI/WINAPIV calling convention,
     * define ZLIB_WINAPI.
     * Caution: the standard ZLIB1.DLL is NOT compiled using ZLIB_WINAPI.
@@ -364,17 +390,23 @@
 #  include <sys/types.h>    /* for off_t */
 #endif
 
+/* LFS conventions have no meaning on Windows. Looking for feature
+ * macros like _LARGEFILE64_SOURCE or _FILE_OFFSET_BITS on Windows is
+ * wrong. So make sure any such macros misguidedly defined by the user
+ * have no effect.
+ */
+
 /* a little trick to accommodate both "#define _LARGEFILE64_SOURCE" and
  * "#define _LARGEFILE64_SOURCE 1" as requesting 64-bit operations, (even
  * though the former does not conform to the LFS document), but considering
  * both "#undef _LARGEFILE64_SOURCE" and "#define _LARGEFILE64_SOURCE 0" as
  * equivalently requesting no 64-bit operations
  */
-#if -_LARGEFILE64_SOURCE - -1 == 1
+#if !defined(_WIN32) && -_LARGEFILE64_SOURCE - -1 == 1
 #  undef _LARGEFILE64_SOURCE
 #endif
 
-#if defined(Z_HAVE_UNISTD_H) || defined(_LARGEFILE64_SOURCE)
+#if !defined(_WIN32) && (defined(Z_HAVE_UNISTD_H) || defined(_LARGEFILE64_SOURCE))
 #  include <unistd.h>       /* for SEEK_* and off_t */
 #  ifdef VMS
 #    include <unixio.h>     /* for off_t */
@@ -394,10 +426,14 @@
 #  define z_off_t long
 #endif
 
-#if defined(_LARGEFILE64_SOURCE) && _LFS64_LARGEFILE-0
+#if !defined(_WIN32) && (defined(_LARGEFILE64_SOURCE) && _LFS64_LARGEFILE-0)
 #  define z_off64_t off64_t
 #else
-#  define z_off64_t z_off_t
+#  if defined(_WIN32)
+#    define z_off64_t __int64
+#  else
+#    define z_off64_t z_off_t
+#  endif
 #endif
 
 #if defined(__OS400__)
--- ../zlib-1.2.5/zlib.h	2010-04-19 21:12:48 +0300
+++ zlib.h	2010-08-17 15:19:45 +0300
@@ -1556,13 +1556,21 @@
         inflateBackInit_((strm), (windowBits), (window), \
                                             ZLIB_VERSION, sizeof(z_stream))
 
+/* LFS conventions have no meaning on Windows. Looking for feature
+ * macros like _LARGEFILE64_SOURCE or _FILE_OFFSET_BITS on Windows is
+ * wrong. So make sure any such macros misguidedly defined by the user
+ * have no effect. Windows has large file support, period. So, no
+ * problem in always providing this API on Windows.
+ */
+
 /* provide 64-bit offset functions if _LARGEFILE64_SOURCE defined, and/or
  * change the regular functions to 64 bits if _FILE_OFFSET_BITS is 64 (if
  * both are true, the application gets the *64 functions, and the regular
  * functions are changed to 64 bits) -- in case these are set on systems
  * without large file support, _LFS64_LARGEFILE must also be true
  */
-#if defined(_LARGEFILE64_SOURCE) && _LFS64_LARGEFILE-0
+
+#if defined(_WIN32) || (defined(_LARGEFILE64_SOURCE) && _LFS64_LARGEFILE-0)
    ZEXTERN gzFile ZEXPORT gzopen64 OF((const char *, const char *));
    ZEXTERN z_off64_t ZEXPORT gzseek64 OF((gzFile, z_off64_t, int));
    ZEXTERN z_off64_t ZEXPORT gztell64 OF((gzFile));
@@ -1571,7 +1579,7 @@
    ZEXTERN uLong ZEXPORT crc32_combine64 OF((uLong, uLong, z_off64_t));
 #endif
 
-#if !defined(ZLIB_INTERNAL) && _FILE_OFFSET_BITS-0 == 64 && _LFS64_LARGEFILE-0
+#if !defined(_WIN32) && !defined(ZLIB_INTERNAL) && _FILE_OFFSET_BITS-0 == 64 && _LFS64_LARGEFILE-0
 #  define gzopen gzopen64
 #  define gzseek gzseek64
 #  define gztell gztell64
--- ../zlib-1.2.5/zutil.h	2010-04-18 12:29:24 +0300
+++ zutil.h	2010-08-17 15:32:26 +0300
@@ -13,7 +13,7 @@
 #ifndef ZUTIL_H
 #define ZUTIL_H
 
-#if ((__GNUC__-0) * 10 + __GNUC_MINOR__-0 >= 33) && !defined(NO_VIZ)
+#if !defined(_WIN32) && ((__GNUC__-0) * 10 + __GNUC_MINOR__-0 >= 33) && !defined(NO_VIZ)
 #  define ZLIB_INTERNAL __attribute__((visibility ("hidden")))
 #else
 #  define ZLIB_INTERNAL
@@ -160,7 +160,7 @@
 #endif
 
 /* provide prototypes for these when building zlib without LFS */
-#if !defined(_LARGEFILE64_SOURCE) || _LFS64_LARGEFILE-0 == 0
+#if !defined(_WIN32) && (!defined(_LARGEFILE64_SOURCE) || _LFS64_LARGEFILE-0 == 0)
     ZEXTERN uLong ZEXPORT adler32_combine64 OF((uLong, uLong, z_off_t));
     ZEXTERN uLong ZEXPORT crc32_combine64 OF((uLong, uLong, z_off_t));
 #endif
--- ../zlib-1.2.5/gzguts.h	2010-04-18 12:28:32 +0300
+++ gzguts.h	2010-08-17 15:39:47 +0300
@@ -12,7 +12,7 @@
 #  endif
 #endif
 
-#if ((__GNUC__-0) * 10 + __GNUC_MINOR__-0 >= 33) && !defined(NO_VIZ)
+#if !defined(_WIN32) && ((__GNUC__-0) * 10 + __GNUC_MINOR__-0 >= 33) && !defined(NO_VIZ)
 #  define ZLIB_INTERNAL __attribute__((visibility ("hidden")))
 #else
 #  define ZLIB_INTERNAL
--- ../zlib-1.2.5/gzlib.c	2010-04-18 10:53:22 +0300
+++ gzlib.c	2010-08-17 15:43:00 +0300
@@ -5,10 +5,14 @@
 
 #include "gzguts.h"
 
-#if defined(_LARGEFILE64_SOURCE) && _LFS64_LARGEFILE-0
-#  define LSEEK lseek64
+#if defined(_WIN32)
+#  define LSEEK _lseeki64
 #else
-#  define LSEEK lseek
+#  if defined(_LARGEFILE64_SOURCE) && _LFS64_LARGEFILE-0
+#    define LSEEK lseek64
+#  else
+#    define LSEEK lseek
+#  endif
 #endif
 
 /* Local functions */
--- ../zlib-1.2.5/win32/zlib.def	2010-03-12 10:56:34 +0200
+++ win32/zlib.def	2010-08-17 15:34:34 +0300
@@ -1,6 +1,4 @@
-LIBRARY
 ; zlib data compression library
-
 EXPORTS
 ; basic functions
     zlibVersion
@@ -57,6 +55,13 @@
     gzclose_w
     gzerror
     gzclearerr
+; large file functions
+    gzopen64
+    gzseek64
+    gztell64
+    gzoffset64
+    adler32_combine64
+    crc32_combine64
 ; checksum functions
     adler32
     crc32
EOF

x86_64-w64-mingw32-windres --define GCC_WINDRES -o zlibrc.o -v win32/zlib1.rc
x86_64-w64-mingw32-gcc -O3 -Wall -shared win32/zlib.def -o zlib1.dll -Wl,--out-implib,libz.dll.a adler32.c compress.c crc32.c deflate.c gzclose.c gzlib.c gzread.c gzwrite.c infback.c inffast.c inflate.c inftrees.c trees.c uncompr.c zutil.c zlibrc.o &&

# The somewhat odd name zdll.lib for the MSVS import library was
# traditionally used for the 32-bit library, so continue like that?
lib -def:win32/zlib.def -machine:X64 -name:zlib1.dll -out:zdll.lib &&

mkdir -p $TARGET/{bin,include,lib} &&
cp zlib1.dll $TARGET/bin &&
cp libz.dll.a $TARGET/lib &&
cp zdll.lib win32/zlib.def $TARGET/lib &&
cp zlib.h zconf.h $TARGET/include &&

rm -f /tmp/$RUNZIP /tmp/$DEVZIP &&
(cd /devel/target/$HEX &&
zip /tmp/$RUNZIP bin/zlib1.dll &&
zip -r -D /tmp/$DEVZIP lib include
)

) 2>&1 | tee /devel/src/tml/packaging/$THIS.log

(cd /devel && zip /tmp/$DEVZIP src/tml/packaging/$THIS.{sh,log}) &&
manifestify /tmp/$RUNZIP /tmp/$DEVZIP
