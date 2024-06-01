#!/usr/bin/env bash

# idk why but this doesn't work in sxhkd
(pgrep screenkey && pkill -f screenkey) || screenkey
