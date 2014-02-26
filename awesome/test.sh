#!/bin/bash
# script xepyhr-awesome
# author: dante4d <dante4d@gmail.com>
Xephyr -ac -br -noreset -screen 800x600 :10 &
sleep 1
DISPLAY=:10.0 awesome -c ~/.config/awesome/rc.lua
