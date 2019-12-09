#!/usr/bin/env sh

echo "\n1. Generating self-signed demo certificates"
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem

echo "\n2. Compiling demo file"
emcc -o test.o -c demo
emcc -o test.js test.o -ldl -pthread -static -r -s PROXY_TO_PTHREAD=1 -s USE_PTHREADS -s ERROR_ON_UNDEFINED_SYMBOLS=0