# Advanced Aliases.
# Use with caution
#

# ls, the common ones I use a lot shortened for rapid fire usage
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'
alias lsr='ls -lARFh' #Recursive list of files and directories
alias lsn='ls -1'     #A column contains name of files and directories

alias zshrc='${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc' # Quick access to the .zshrc file

alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'

# Command line head / tail shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias -g P="2>&1| pygmentize -l pytb"

alias dud='du -d 1 -h'
(( $+commands[duf] )) || alias duf='du -sh *'
(( $+commands[fd] )) || alias fd='find . -type d -name'
alias ff='find . -type f -name'

alias h='history'
alias hgrep="fc -El 0 | grep"
alias help='man'
alias p='ps -f'
alias sortnr='sort -n -r'
alias unexport='unset'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# zsh is able to auto-do some kungfoo
# depends on the SUFFIX :)
autoload -Uz is-at-least
if is-at-least 4.2.0; then
  # open browser on urls
  if [[ -n "$BROWSER" ]]; then
    _browser_fts=(htm html xhtml)
    for ft in $_browser_fts; do alias -s $ft='$BROWSER'; done
  fi

  # open editable text files in text editor
  if [[ -n "$VISUAL" ]] || [[ -n "$EDITOR" ]]; then
    _aliases_launch_editor() {
      # directly launch matched files with executable bit and shebang present
      if [[ -x "${1}" ]]; then
        read -r <"${1}"
        if [[ ${#REPLY} -ge 3 ]] && [[ ${REPLY:0:2} = '#!' ]]; then
          "$@"
          return $?
        fi
      fi

      if [[ -n "$VISUAL" ]]; then
        $VISUAL "$@"
      else
        $EDITOR "$@"
      fi
    }
    # Taken from the /language/metadata/property[name="globs"] sections of the
    # gtksourceview language definition files in
    # /usr/share/gtksourceview-3.0/language-specs/*.lang
    _editor_fts=(
      abnf as adb ads 4th forth asp am awk prg bib bsv boo cg h c cmake ctest
      cbl cob cbd cdb cdc hh hp hpp h++ cpp cxx cc C c++ cs css CSSL csv cu cuh
      desktop kdelnk diff patch rej d docbook bat cmd sys dot gv dpatch dtd dtl
      e eif erl hrl fcl frt fs f f90 f95 for F F90 fs g gd gi gap gdb gs glslv
      glslf go groovy hs lhs hx pro idl igm ini jade pug java js node ijs json
      geojson topojson jl kt tex ltx sty cls dtx ins bbl l lex flex la lai lo
      ll logcat lua m4 ac in make mak mk page markdown md mkd m mac MAC dem DEM
      wxm WXM build mo mop mxml n nrx nai nsh m j ml mli mll mly ocl ooc sign
      impl cl p pas txt TXT pl pm al perl t php php3 php4 phtml pig pc po pot
      prolog proto pp py3 py pyw R Rout r Rhistory Rtspec rst rb rake gemspe rs
      scala scm sce sci sh bash sml sig rq sql rnw Rnw snw Snw swift sv svh t2t
      tcl tk tera texi texinfo thrift toml tml lock vala vapi vb v vhd xml xspf
      siv smil smi sml kino xul xbel abw zabw glabe jnlp mml rdf rss wml xmi fo
      xslfo xslt xsl y yacc yaml yml
    )
    for ft in $_editor_fts; do alias -s $ft=_aliases_launch_editor; done
  fi

  # open image files in image viewer
  if [[ -n "$XIVIEWER" ]]; then
    # List inspired by https://en.wikipedia.org/wiki/Image_file_formats
    _image_fts=(
      #: Raster formats
      # JPEG, JPEG2000, HEIF/HEVC, JBIG
      jpg jpeg jpe jif jfif jfi jp2 j2k jpf jpx jpm mj2 heif heic jbg jbig
      # BMP, BPG, GIF, ICO/ANI, PCX, PNG+MNG, TGA, TIFF, WebP (Web)
      bmp bpg gif dib ico cur ani pcx png mng tga tiff tif webp
      # NetPBM, XBM/XPM/XWD (ASCII)
      pbm bgm ppm pnm xbm xpm xwd
      # CIFF, DNG, DPX, ECW, FITS, ICS, RGBE (HDR & Raw)
      crw dng dpx ecw fits ics ids fit fts hdr
      # DDS ICNS OpenRaster SunRaster (Other)
      dds icns ora ras sun
      #: Vector formats
      # CGM WMF Gerber IGES SVG
      cgm wmf emf wmz emz gbr iges svg svgz
    )
    for ft in $_image_fts; do alias -s $ft='$XIVIEWER'; done
  fi

  if [[ -n "$XMVIEWER" ]]; then
    _media_fts=(
      #: Audio (container) formats
      # https://en.wikipedia.org/wiki/Audio_file_format#List_of_formats
      aac act aiff ape au awb dct dss flac gsm m4a m4b mp3 mpc oga opus ra sln
      tta vox wav wma wv
      #: Video (container) formats
      # https://en.wikipedia.org/wiki/Video_file_format#List_of_video_file_formats
      mkv flv f4v f4p f4a f4b vob ogv drc gifv avi mov qt wmv yuv rmvb asf amv
      m4v mpg mp2 m2v mpeg mpe mpv svi 3g2 mxf nsv
      #: Container formats that may store both
      3gp ogg mogg mp4 m4p rm webm
    )
    for ft in $_media_fts; do alias -s $ft=$XMVIEWER; done
  fi

  #open complex document formats using the system viewer
  _document_fts=(
    # Long-term storage formats
    djvu dvi fb2 epub pdf ps rtf
    # Office Binary & Office OpenXML
    doc docx docm ppt pptx pptm xls xlsx xlsm
    # OpenDocument
    odt fodt ods fods odp fodp odg fodg odf
    # Uniform Office Format
    uof uot uos uop
    # StarOffice
    sdw sxw sdc sxc sdd sci sda sxd smf sxm
    # WordPerfect
    wpd wp wp4 wp5 wp6 wp7
    # Others
    abw gnm gnumeric pages hwp
  )
  if type xdg-open >/dev/null; then
    for ft in $_document_fts; do alias -s $ft=xdg-open; done
  elif type open >/dev/null; then
    for ft in $_document_fts; do alias -s $ft=open; done
  fi

  #list whats inside packed file
  alias -s zip="unzip -l"
  alias -s rar="unrar l"
  alias -s tar="tar tf"
  alias -s tar.gz="echo "
  alias -s ace="unace l"
fi

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
