#!/usr/bin/env bash

CURRENT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" && pwd )"

source "${CURRENT_DIR}/util.sh"

_operating_dir="${1}"

usage_msg() {
  echo "Usage: $0 <operating-dir> <args*>" >&2
}

if [ "${_operating_dir}" == "" ]; then
  usage_msg
  exit 1
fi

cd "${_operating_dir}"

"${@:2}"
