#!/bin/sh

BUILD_DIR="${BUILD_DIR}"

export DEB_BUILD_OPTIONS=nocheck

build() 
{
	python3 setup.py --command-packages=stdeb.command bdist_deb
	if [ ! -d "${BUILD_DIR}" ]; then
	    mkdir -p "${BUILD_DIR}"
    fi
	mv "deb_dist/"*".deb" "${BUILD_DIR}/"
}

build
