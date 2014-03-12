#!/bin/sh -e
#
# Helper script for running image with proper port mappings.

sudo docker run -d -p 45160:22 viliusl/`basename "$PWD"`