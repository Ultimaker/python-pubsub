#!/bin/sh

set -eu

LOCAL_REGISTRY_IMAGE="google-pub-sub"

SRC_DIR="$(pwd)"
DOCKER_WORK_DIR="/build"
BUILD_DIR_TEMPLATE="_build"
BUILD_DIR="${BUILD_DIR_TEMPLATE}"


update_docker_image()
{
    docker build docker_env/ -t "${LOCAL_REGISTRY_IMAGE}"
}

run_in_docker()
{
    docker run \
        --privileged \
        --rm \
        -it \
        -e "BUILD_DIR=${DOCKER_WORK_DIR}/${BUILD_DIR}" \
        -v "${SRC_DIR}:${DOCKER_WORK_DIR}" \
        -w "${DOCKER_WORK_DIR}" \
        "${LOCAL_REGISTRY_IMAGE}" \
        "${@}"
}

run_build()
{
    run_in_docker "./build.sh" "${@}" Make sure you add you own build.sh script
    return
}

deliver_pkg()
{
    run_in_docker chown -R "$(id -u):$(id -g)" "${DOCKER_WORK_DIR}"

    cp "${BUILD_DIR}/"*".deb" "./"
}

usage()
{
    echo "Usage: ${0} [OPTIONS]"
    echo "  -h   Print usage"
    echo "  -l   Skip code linting"
}

while getopts ":hl" options; do
    case "${options}" in
    h)
        usage
        exit 0
        ;;
    :)
        echo "Option -${OPTARG} requires an argument."
        exit 1
        ;;
    ?)
        echo "Invalid option: -${OPTARG}"
        exit 1
        ;;
    esac
done
shift "$((OPTIND - 1))"

if ! command -V docker; then
    echo "Docker not found, docker-less builds are not supported."
    exit 1
fi

update_docker_image

run_build "${@}"

deliver_pkg

exit 0
