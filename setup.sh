#!/bin/bash

set -eo pipefail

# Disable sudo timeout
echo "Defaults timestamp_timeout = -1" | sudo tee /etc/sudoers.d/timeout >/dev/null
