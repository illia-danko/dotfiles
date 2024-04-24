#!/usr/bin/env bash

# Copy clipboard history to cliphist.
# Instead of polling, it is simply listen to 'cliphotify' and blocks until an event arrives.

while clipnotify; do xclip -o -selection c | cliphist store; done
