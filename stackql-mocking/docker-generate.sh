#!/usr/bin/env bash

CURRENT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" && pwd )"

source "${CURRENT_DIR}/util.sh"

_path_to_input_file="${1}"

_generator_name="${2}"

_output_dir="${3}"

usage_msg() {
  echo "Usage: $0 <path-to-input-file> <generator-name> <output-dir>" >&2
}

if [ "${_path_to_input_file}" == "" ]; then
  usage_msg
  exit 1
fi

if [ "${_generator_name}" == "" ]; then
  usage_msg
  exit 1
fi

if [ "${_output_dir}" == "" ]; then
  usage_msg
  exit 1
fi

_http_file_path="$(echo "${_path_to_input_file}" | grep '^http[s]*://')"

if [ "${_http_file_path}" != "" ]; then
  _input_path="${_http_file_path}"
else 
  _input_path="/local/${_path_to_input_file}"
fi

docker run --rm -v "${REPOSITORY_ROOT}:/local" \
  openapitools/openapi-generator-cli generate \
  -i "${_input_path}" \
  -g "${_generator_name}"  \
  -o "/local/out/${_output_dir}"
