#!/bin/bash

vars='-var="org=sup"
  -var="project=devops"
  -var="runner_token=XXX"
  -var="runner_group_name=hogwarts-houses"
  -var="github_organisation=deanchin"'

usage() { echo "Usage: $0 [p|a|d]" 1>&2; exit 1; }

case "${1}" in
    p)
        terraform plan \
            -var="org=sup" \
            -var="project=devops"
        ;;
    *)  
        usage
        ;;
esac
