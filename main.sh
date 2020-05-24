#!/bin/bash

KEY_FRAME_INDEX=$1

echo "INDEX=${KEY_FRAME_INDEX}"

FORCE=${2:-y}

echo "FORCE=${FORCE}"

function walk() {
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
            walk $1"/"$file
        else
            video=$1"/"$file
            if [[ $video =~ \.mp4$ ]]
            then
                name=${video/%".mp4"/".jpg"}

                if [ -f "$name" ] && [ ! "$FORCE" = "y" ]
                then
                    echo "$name exists, skip."
                    continue
                fi

                eval $(ffprobe -select_streams v \
                    -show_frames -v quiet \
                    -show_entries frame=pict_type \
                    -of csv $video \
                    | grep -n I \
                    | cut -d ':' -f 1 \
                    | awk -v KEY_FRAME_INDEX="$KEY_FRAME_INDEX"\
                        'NR==KEY_FRAME_INDEX{print "key="$1}')

                
                ffmpeg -i $video \
                    -vf select="between(n\,$key\,$key),setpts=PTS-STARTPTS" \
                    -y -v quiet \
                    $name

                echo "$name choose from $key frame"
            fi
        fi
    done
}

walk /video

echo "Mission finished!"
