#!/bin/bash

set -e

readonly VCODEC="mp4v"
readonly VBITRATE="1024"

readonly ACODEC="mp4a"
readonly ABITRATE="128"

readonly MUX="mp4" 
readonly VLC="/usr/bin/vlc"                                                                                                                                           

if [ ! -e "${VLC}" ]
then
    echo "'${VLC}' not available"
    exit 1
fi

transcode() {
    for file in "$@"
    do
	echo "=> Transcoding '${file}'... "

	dst=$(dirname "${file}")
	new=$(basename "${file}" | sed 's@\.[a-z][a-z][a-z]$@@').${MUX}

	${VLC} -I dummy -q "${file}" \
	--sout "#transcode{vcodec=${VCODEC},vb=${VBITRATE},acodec=${ACODEC},ab=${ABITRATE}}:standard{mux=${MUX},dst=\"${dst}/${new}\",access=file}" \
	vlc://quit
	ls -lh "${file}" "${dst}/$new"
	echo
    done
}

if [ -z "$@" ]
then
    echo "$(basename $0) *.ASF"
    exit 1
else
    transcode
    exit 0
fi
