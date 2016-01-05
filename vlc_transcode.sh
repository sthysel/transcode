#!/bin/bash

set -e

readonly ALLFILES=$@

readonly VCODEC="mp4v"
readonly VBITRATE="512"

readonly ACODEC="mp4a"
readonly ABITRATE="128"

readonly MUX="ogg" 
readonly VLC="/usr/bin/vlc"                                                                                                                                           

if [ ! -e "${VLC}" ]
then
    echo "'${VLC}' not available"
    exit 1
fi

# https://www.videolan.org/doc/streaming-howto/en/ch03.html
transcode() {
    for file in ${ALLFILES}
    do
	echo "Transcoding '${file}'... "

	dst=$(dirname "${file}")
	new=$(basename "${file}" | sed 's@\.[a-z][a-z][a-z]$@@').${MUX}

	${VLC} -I dummy -q "${file}" \
	--sout "#\
	transcode{vcodec=${VCODEC},venc=ffmpeg,vb=${VBITRATE},acodec=${ACODEC},ab=${ABITRATE}}:\
	standard{mux=${MUX},dst=\"${dst}/${new}\",access=file}" \
	vlc://quit
	ls -lh "${file}" "${dst}/$new"
	echo
    done
}

if [ -z ${ALLFILES} ]
then
    echo "$(basename $0) *.ASF"
    exit 1
else
    transcode
    exit 0
fi
