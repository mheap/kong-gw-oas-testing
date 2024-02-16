#!/usr/bin/env bash
SETUP_CMD="go run . -cmd setup -product"
GEN_CMD="go run . -cmd gen -product"
GEN_DIR="../kong-admin-spec-generator"
WORK_DIR=$PWD

PRODUCTS=("kong" "kong-enterprise" "konnect")
VARIANTS=("" "-skip-related")

mkdir -p specs

for product in "${PRODUCTS[@]}"; do
  echo "=> Setup: $product"
  cd $GEN_DIR
  $SETUP_CMD $product $variant
  cd $WORK_DIR
  for variant in "${VARIANTS[@]}"; do
    cd $GEN_DIR
    echo "==> Generating $product $variant"
    $GEN_CMD $product $variant
    cd $WORK_DIR
    cat $GEN_DIR/work/openapi.json | yq . -P > ./specs/$product$variant.yaml
  done

  echo "=> Cleaning up"
  docker rm -f kong-database
  docker rm -f kong-gateway
done
