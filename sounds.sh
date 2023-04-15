
#!/bin/bash


file="background.mp3"


if [ -f "$file" ]; then
  mplayer "$file"
else
  echo "File not found"
fi




