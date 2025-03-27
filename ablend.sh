#!/bin/sh

if [ $# -ne 4 ]; then
    echo "Usage: $0 <file1.mp4> <file2.mp4> <time_ms> <sequence_count>"
    exit 1
fi

video1="$1"
video2="$2"
sequence_time_ms="$3"
sequences="$4"

# Check if video files exist
if [ ! -f "$video1" ] || [ ! -f "$video2" ]; then
    echo "Error: One of the video files does not exist."
    exit 1
fi

output="mixed_output.mp4"
sequence_time_s=$(echo "scale=2; $sequence_time_ms / 1000" | bc | sed 's/^\./0./')  # Convert milliseconds to seconds with 2 decimal places
temp_list="temp_list.txt"
> "$temp_list"

i=0
while [ $i -lt $sequences ]; do
    start=$(echo "$i * $sequence_time_s" | bc | sed 's/^\./0./')  # Calculate start time with 2 decimal places

    # Displaying information about the extracted segment
    echo "Extracting segment: Start = $start s, Duration = $sequence_time_s s"

    # Extract segment from the first video file
    ffmpeg -hide_banner -loglevel error -ss "$start" -t "$sequence_time_s" -i "$video1" -c:v libx264 -c:a aac "clip1_$i.mp4" -y
    if [ $? -ne 0 ]; then
        echo "Error while creating clip1_$i.mp4"
        exit 1
    fi
    echo "file 'clip1_$i.mp4'" >> "$temp_list"

    # Extract segment from the second video file
    ffmpeg -hide_banner -loglevel error -ss "$start" -t "$sequence_time_s" -i "$video2" -c:v libx264 -c:a aac "clip2_$i.mp4" -y
    if [ $? -ne 0 ]; then
        echo "Error while creating clip2_$i.mp4"
        exit 1
    fi
    echo "file 'clip2_$i.mp4'" >> "$temp_list"

    echo "Created segments: clip1_$i.mp4 and clip2_$i.mp4"

    i=$((i + 1))
done

# Merge all segments into one file
ffmpeg -f concat -safe 0 -i "$temp_list" -c copy "$output" -hide_banner -loglevel error
if [ $? -ne 0 ]; then
    echo "Error while creating the final file."
    exit 1
fi

# Cleanup
rm clip1_*.mp4 clip2_*.mp4 "$temp_list"
echo "Output saved to $output"
