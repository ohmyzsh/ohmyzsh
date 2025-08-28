#!/bin/zsh
# ytd: YouTube ses indirici Oh My Zsh plugin

ytd() {
    if [[ -z "$1" ]]; then
        echo "Kullanım: ytd <YouTube linki>"
        return 1
    fi

    # İndirme klasörü
    DIR="$HOME"
    mkdir -p "$DIR"

    # yt-dlp ile mp3 olarak indir
    yt-dlp -f bestaudio --extract-audio --audio-format mp3 --no-playlist -o "$DIR/%(title)s.%(ext)s" "$1"
}

