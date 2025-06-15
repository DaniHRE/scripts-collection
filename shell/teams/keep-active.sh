#!/bin/bash
# -*- coding: UTF8 -*-

while true
do
  sleep 180
  tmp=$(xdotool getactivewindow)
  xdotool windowactivate --sync "$(xdotool search --name "Microsoft Teams")" key Right
  xdotool windowactivate "$tmp"
done
