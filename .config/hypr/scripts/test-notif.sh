#!/bin/bash

notify-send 'Test (oldest)' 'This is a test notification.'
notify-send -n kitty -a kitty 'Test' 'This is a test notification from kitty the terminal emulator.'
notify-send -n kitty -a kitty -u critical 'Urgent!' 'This is a very urgent notification.'
notify-send -n kitty -a kitty -A a='Action 1' b='Action 2' 'Test' 'I have actions, click them!'
notify-send -n kitty -a kitty -t 10000 'Test (newest)' 'Expires in 10 seconds.'
