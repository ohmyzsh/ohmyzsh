#Nombre de ficheros

ruta="~/Descargas"

# youtube templates
title="%(title)s"
ext="%(ext)s"
playlist="%(playlist_title)"
playlistId="%(playlist_id)"


formato_audio="-o $ruta/$titulo.$extension" # ruta / titulo.extension
formato_video="-o $ruta/$titulo.$extension" #ruta / titulo.extension
formato_playlist2="-o $ruta/$playlist/$title.$ext" # ruta / playlist / titulo.extension
formato_playlist="-o $ruta/$playlist/$playlistId_$title.$ext" # ruta / playlist / playlistId_titulo.extension


#configuracion
alias yt-h="youtube-dl --help"                    # muestra la ayuda
alias yt-conf="nano ~/.config/youtube-dl/config"  # editor de configuracion


#
#Extraer audio
#

# extrae audio en .aac
alias yta-aac="youtube-dl --extract-audio --audio-format aac --embed-thumbnail $formato_audio"
# extrae el mejor audio
alias yta-best="youtube-dl --extract-audio --audio-format best --embed-thumbnail $formato_audio"
# extrea audio en .flac
alias yta-flac="youtube-dl --extract-audio --audio-format flac --embed-thumbnail $formato_audio"
# extrae audio en .m4a
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a --embed-thumbnail $formato_audio"
 # extrae audio en .mp3
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 --embed-thumbnail $formato_audio"
 # extrae audio en .opus
alias yta-opus="youtube-dl --extract-audio --audio-format opus --embed-thumbnail $formato_audio"
# extrae audio en .vorbis
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis --embed-thumbnail $formato_audio"
# extrae audio en .wav
alias yta-wav="youtube-dl --extract-audio --audio-format wav --embed-thumbnail $formato_audio"


#
#Extraer video
#

# extrae video en .mp4
alias ytv-mp4="youtube-dl -f mp4 --add-metadata $formato_video"
# extrae video en .webm
alias ytv-="youtube-dl -f webm --add-metadata $formato_video"


#
# Extraer todo
#

# extrae el mejor formato y video
alias yta-best="youtube-dl -f bestvideo+bestaudio $formato_audio"


#
#Playlist
#
