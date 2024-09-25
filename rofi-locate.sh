#!/bin/bash

#       https://www.youtube.com/user/gotbletu
#       https://github.com/gotbletu
# info: rofi-locate is a script to search local files and folders on your computer using the locate command and the updatedb database
# requirements: rofi mlocate
# playlist: https://www.youtube.com/playlist?list=PLqv94xWU9zZ0LVP1SEFQsLEYjZC_SUB3m

xdg-open "$(locate home system | rofi -threads 0 -width 100 -dmenu -i -p "locate:")"
