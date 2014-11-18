#!/bin/sh

while [ 1 ]
do
	openRTSP -v -c -t rtsp://85.142.60.74:5005/live/mpeg4 2>/dev/null| ffmpeg -an -i - -an -r 5 -b 512k http://127.0.0.1:8090/feed1.ffm 2>/dev/null
	sleep 15
done
