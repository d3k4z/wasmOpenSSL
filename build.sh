#!/usr/bin/env sh

# Based on code from https://github.com/TrueBitFoundation/wasm-ports/blob/master/openssl.sh

OPENSSL_VERSION=1.1.1d
PREFIX=`pwd`
DIRECTORY="openssl-${OPENSSL_VERSION}"

if [ ! -d "$DIRECTORY" ]; then
  echo "\n1. Download source code"
  curl https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz -o openssl-${OPENSSL_VERSION}.tar.gz
  tar xf openssl-${OPENSSL_VERSION}.tar.gz
fi

echo "\n2. Patching OpenSSL"
cd patch-${OPENSSL_VERSION}
find . -type f | cpio -pvduml ../openssl-${OPENSSL_VERSION}
cd ../openssl-${OPENSSL_VERSION}

echo "\n3. Configure"
wasiconfigure ./Configure gcc -no-tests -no-asm -static -no-sock -no-afalgeng -DOPENSSL_SYS_NETWARE -DSIG_DFL=0 -DSIG_IGN=0 -DHAVE_FORK=0 -DOPENSSL_NO_AFALGENG=1 --with-rand-seed=getrandom || exit $?
sed -i -e "s/CNF_EX_LIBS=/CNF_EX_LIBS=-lwasi-emulated-mman /g" Makefile
make apps/progs.h
sed -i 's|^CROSS_COMPILE.*$|CROSS_COMPILE=|g' Makefile

echo "\n4. Building"
wasimake make -j12 build_generated libssl.a libcrypto.a apps/openssl

rm -rf ${PREFIX}/build/include
mkdir -p ${PREFIX}/build/include
cp -R include/openssl ${PREFIX}/build/include

echo "\5. Generate libraries .wasm files"
emcc libcrypto.a -o ${PREFIX}/build/libcrypto.wasm
emcc libssl.a -o ${PREFIX}/build/libssl.wasm

echo "\n6. Link"
emcc apps/*.o libssl.a libcrypto.a \
  -o ${PREFIX}/build/openssl.wasm

echo "Done!"
