#set -xe
# pdf.plugin.zsh

PDF_READER=""

_check_pdf_reader() {
    for reader in okular evince xpdf firefox zathura atril mupdf xreader deepin-reader gv papers; do
        if command -v $reader >/dev/null 2>&1; then
            PDF_READER=$reader
            return
        fi
    done
    echo "No suitable PDF reader found. Please install okular, evince, xpdf, or firefox."
    return 1
}

_pdfdirectory() {
    if [[ ! -f ~/.config/pdfiledoc/pdfs.txt ]]; then
        mkdir -p ~/.config/pdfiledoc
        if command -v fd &> /dev/null; then
            fd -e pdf . "$HOME" > ~/.config/pdfiledoc/pdfs.txt
        else
            find "$HOME" -type f -name '*.pdf' > ~/.config/pdfiledoc/pdfs.txt
        fi
    fi
}

pdf() {
    _check_pdf_reader || return 1
    _pdfdirectory

    local var1=$(cat ~/.config/pdfiledoc/pdfs.txt | fzf -i)
    echo "$var1"

    if [[ -n $var1 ]]; then
        $PDF_READER "$var1" &
    elif ! command -v fd &> /dev/null; then
        local newinput=$(find "$HOME" -type f -name '*.pdf')
        echo "$newinput" > ~/.config/pdfiledoc/pdfs.txt
    else
        local newinput=$(fd -e pdf . "$HOME")
        echo "$newinput" > ~/.config/pdfiledoc/pdfs.txt
    fi

    if [[ $# -gt 0 && -f $1 ]]; then
        $PDF_READER "$1" &
    fi
}
