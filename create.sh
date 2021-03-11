#!/bin/bash

OUTPUT_BASE_DIR=./out
TEMPLATE_DIR=./template
OPENSTACK_TEMPLATE="${TEMPLATE_DIR:?}/openstack-template.yml"

if [[ -f $OPENSTACK_TEMPLATE ]]; then
  CREATE_OPENSTACK_CONFIG=true
else
  CREATE_OPENSTACK_CONFIG=false
fi

function yellow() {
  echo -e "\033[33m$1\033[39m"
}

function red() {
  echo -e "\033[31m$1\033[39m"
}

function confirm() {
  yellow "$1 (press Y to confirm)"
  read CONFIRM
  if [[ "$CONFIRM" == 'Y' ]]; then
    return 0
  else
    return 1
  fi
}

echo "This script creates a new GOB service with basis repo and configuration"

yellow "What is the name of the new service?"

read NAME

LOWER="$(tr '[:upper:]' '[:lower:]' <<< ${NAME})"
UPPER_FIRST="$(tr '[:lower:]' '[:upper:]' <<< ${NAME:0:1})${NAME:1}"

REPO_NAME="GOB-${UPPER_FIRST}"
PYTHON_MODULE_NAME="gob${LOWER}"
DOCKER_NAME=$PYTHON_MODULE_NAME
DOCKER_REPO="gob_${LOWER}"
OPENSTACK_FILENAME="deploy-gob-${LOWER}.yml"


if ! confirm "The repo name will be $REPO_NAME and the Docker container name will be $DOCKER_NAME. Is this ok?"; then
  echo "Cancelling. Good bye!"
  exit
fi

OUTPUT_DIR="$OUTPUT_BASE_DIR/$REPO_NAME"
OPENSTACK_TEMPLATE_DST="$OUTPUT_BASE_DIR/$OPENSTACK_FILENAME"

if [[ -d $OUTPUT_DIR ]]; then
  if ! confirm "The output dir $OUTPUT_DIR already exists. Remove existing files in this directory?"; then
    echo "You don't want me to overwrite the existing files. Please fix it yourself. Exiting."
    exit
  fi

  rm -rf "${OUTPUT_DIR:?}"
  rm -f "${OPENSTACK_TEMPLATE_DST:?}"
fi
mkdir -p $OUTPUT_DIR

echo "Copy template files to output directory"
cp -r "${TEMPLATE_DIR:?}/repo/" $OUTPUT_DIR

if $CREATE_OPENSTACK_CONFIG; then
  cp "$OPENSTACK_TEMPLATE" $OPENSTACK_TEMPLATE_DST
fi

echo "Rename python module"
mv $OUTPUT_DIR/src/the_module $OUTPUT_DIR/src/$PYTHON_MODULE_NAME

echo "Replace variables in templates"

function replace_tag_at_loc() {
  TEMPLATE_TAG=$1
  REPLACE_WITH=$2
  LOCATION=$3

  find "$LOCATION" -type f -exec sed -i "" -e "s/$TEMPLATE_TAG/$REPLACE_WITH/g" {} \;
}

function replace_tag() {
  # Replace tag in all files in OUTPUT_DIR plus the Openstack template file
  TEMPLATE_TAG=$1
  REPLACE_WITH=$2

  replace_tag_at_loc "$TEMPLATE_TAG" "$REPLACE_WITH" "$OUTPUT_DIR"

  if $CREATE_OPENSTACK_CONFIG; then
    replace_tag_at_loc "$TEMPLATE_TAG" "$REPLACE_WITH" "$OPENSTACK_TEMPLATE_DST"
  fi
}


replace_tag "GOB_TEMPLATE_DOCKER_NAME" "$DOCKER_NAME"
replace_tag "GOB_TEMPLATE_DOCKER_REPO" "$DOCKER_REPO"
replace_tag "GOB_TEMPLATE_REPO_NAME" "$REPO_NAME"
replace_tag "GOB_TEMPLATE_OPENSTACK_FILENAME" "$OPENSTACK_FILENAME"
replace_tag "GOB_TEMPLATE_PYTHON_MODULE_NAME" "$PYTHON_MODULE_NAME"
replace_tag "GOB_TEMPLATE_OPENSTACK_PARAMS" "app_gob-${LOWER}"

echo "Done."
echo "Your new repo is in $OUTPUT_DIR"

if $CREATE_OPENSTACK_CONFIG; then
  echo "The Openstack deploy config is $OPENSTACK_TEMPLATE_DST"
else
  red "Openstack deploy config is not created, template was missing. Place the template at $OPENSTACK_TEMPLATE and re-run this command"
fi

