#!/bin/sh

conan remote add pkg $CONAN_REMOTE

if [ $# -eq 0 ]; then
    /bin/bash
else
    /bin/bash -c "$*"
fi
