os=$(uname)

if [[ "$os" == "Linux" ]]; then
    threads=`nproc --all`
elif [[ "$os" == "Darwin" ]]; then
    threads=`sysctl -n hw.ncpu`
else
    echo "Unknown OS"
fi

yt-dlp --concurrent-fragments $threads \
    --output '%(playlist_index)d_%(n_entries)d - %(title)s.%(ext)s' \
    --cache-dir ./tmp \
    --paths ./tmp \
    $1