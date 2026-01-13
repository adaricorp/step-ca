#!/bin/bash

set -euo pipefail

declare -A package_names=(
    ["certificates"]="step-ca"
    ["cli"]="step-cli"
)

arch="${ARCH}"

set -x

apt-get update
apt-get -y install curl

while read -r dir; do
    (
        cd "${dir}"

        repo="$(basename "${dir}")"
        tag="$(git describe --tags)"
        package_name="${package_names[${repo}]}"

        curl -fsSL \
            "https://github.com/smallstep/${repo}/releases/download/${tag}/${package_name}_${arch}.deb" \
            -o "../${package_name}_${tag}_${arch}.deb"
    )
done <<< "$(find . -mindepth 1 -maxdepth 1 -type d -not -path '*/.*')"
