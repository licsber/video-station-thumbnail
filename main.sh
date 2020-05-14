#!/bin/bash

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
                eval $(ffprobe -select_streams v \
                    -show_frames -v quiet \
                    -show_entries frame=pict_type \
                    -of csv $video \
                    | grep -n I \
                    | cut -d ':' -f 1 \
                    | awk 'NR==4{print "key="$1}')

                name=${video/%".mp4"/".jpg"}
                
                ffmpeg -i $video \
                    -vf select="between(n\,$key\,$key),setpts=PTS-STARTPTS" \
                    -y -v quiet \
                    $name

                echo $name
            fi
        fi
    done
}

walk /video

echo "Mission finished!"
