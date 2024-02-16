#!/usr/bin/env bash

set -euo pipefail
mkdir -p dist

# get script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function add_h1 {
  echo "<h1>$1</h1>" >> dist/index.html
}

function add_h2 {
  echo "<h2>$1</h2>" >> dist/index.html
}

function start_list {
  echo "<ul>" >> dist/index.html
}

function end_list {
  echo "</ul>" >> dist/index.html
}

function build_doc {
  
  # get paths from first argument
  doc_path=$1
  title=$2

  apiPath=$(basename $doc_path .yaml)

  # Header
  targetDir="dist/$apiPath"
  # remove the openapi.yaml from the path and create the directory
  mkdir -p $targetDir

  # use redocly cli to build the html
  npx @redocly/cli build-docs $doc_path -o $targetDir/index.html

  # write a link to the index 
  echo "<li><a href='/$apiPath/index.html'>$title</a></li>" >> dist/index.html
  
}

rm -f dist/index.html

add_h1 "Kong"
start_list
build_doc "specs/kong.yaml" "Default"
build_doc "specs/kong-skip-related.yaml" "Skip Related"
end_list

add_h1 "Kong Enterprise"
start_list
build_doc "specs/kong-enterprise.yaml" "Default"
build_doc "specs/kong-enterprise-skip-related.yaml" "Skip Related"
end_list

add_h1 "Konnect"
start_list
build_doc "specs/konnect.yaml" "Default"
build_doc "specs/konnect-skip-related.yaml" "Skip Related"
end_list