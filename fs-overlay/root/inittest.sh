#! /bin/sh

echo "generating random file"
dd if=/dev/urandom of=testfile bs=1024 count=50000
