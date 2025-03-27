### Description:  
**ablend.sh** is a script that creates a fast-paced alternating sequence (ABABA) from two video files. It extracts short segments from both videos and merges them into a single output file. The user specifies the duration of each segment and the number of repetitions.  

### Usage:  
```bash
./ablend.sh <file1.mp4> <file2.mp4> <time_ms> <sequence_count>
```

### Parameters:  
- `<file1.mp4>` – First input video file  
- `<file2.mp4>` – Second input video file  
- `<time_ms>` – Duration of each segment in milliseconds  
- `<sequence_count>` – Number of AB sequences to generate  

### Example:  
```bash
./ablend.sh video1.mp4 video2.mp4 500 10
```
This command extracts 10 alternating 500ms clips from `video1.mp4` and `video2.mp4`, then combines them into `mixed_output.mp4`.
