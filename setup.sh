#!/bin/bash

set -eo pipefail

# Disable sudo timeout
echo "Defaults timestamp_timeout = -1" | sudo tee /etc/sudoers.d/timeout >/dev/null

# Limit DNF to 10 parallel downloads
echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf >/dev/null
