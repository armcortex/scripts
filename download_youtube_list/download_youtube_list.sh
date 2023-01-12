# -N for thread
threads=`nproc --all`
yt-dlp -N $threads -o '%(playlist_index)d_%(n_entries)d - %(title)s.%(ext)s' $1