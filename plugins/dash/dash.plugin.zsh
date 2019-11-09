# Usage: dash [keyword:]query
dash() { open dash://"$*" }
compdef _dash dash

_dash() {
  # No sense doing this for anything except the 2nd position and if we haven't
  # specified which docset to query against
  if [[ $CURRENT -eq 2 && ! "$words[2]" =~ ":" ]]; then
    local -a _all_docsets
    _all_docsets=()
    # Use defaults to get the array of docsets from preferences
    # Have to smash it into one big line so that each docset is an element of
    # our DOCSETS array
    DOCSETS=("${(@f)$(defaults read com.kapeli.dashdoc docsets | tr -d '\n' | grep -oE '\{.*?\}')}")

    # remove all newlines since defaults prints so pretty like
    # Now get each docset and output each on their own line
    for doc in "$DOCSETS[@]"; do
      # Only output docsets that are actually enabled
      if [[ "`echo $doc | grep -Eo \"isEnabled = .*?;\" | sed 's/[^01]//g'`" == "0" ]]; then
        continue
      fi

      keyword=''

      # Order of preference as explained to me by @kapeli via email
      KEYWORD_LOCATORS=(keyword suggestedKeyword platform)
      for locator in "$KEYWORD_LOCATORS[@]"; do
        # Echo the docset, try to find the appropriate keyword
        # Strip doublequotes and colon from any keyword so that everything has the
        # same format when output (we'll add the colon in the completion)
        keyword=`echo $doc | grep -Eo "$locator = .*?;" | sed -e "s/$locator = \(.*\);/\1/" -e "s/[\":]//g"`
        if [[ ! -z "$keyword" ]]; then
          # if we fall back to platform, we should do some checking per @kapeli
          if [[ "$locator" == "platform" ]]; then
            # Since these are the only special cases right now, let's not do the
            # expensive processing unless we have to
            if [[ "$keyword" = (python|java|qt|cocos2d) ]]; then
              docsetName=`echo $doc | grep -Eo "docsetName = .*?;" | sed -e "s/docsetName = \(.*\);/\1/" -e "s/[\":]//g"`
              case "$keyword" in
                python)
                  case "$docsetName" in
                    "Python 2") keyword="python2" ;;
                    "Python 3") keyword="python3" ;;
                  esac ;;
                java)
                  case "$docsetName" in
                    "Java SE7") keyword="java7" ;;
                    "Java SE6") keyword="java6" ;;
                    "Java SE8") keyword="java8" ;;
                  esac ;;
                qt)
                  case "$docsetName" in
                    "Qt 5") keyword="qt5" ;;
                    "Qt 4"|Qt) keyword="qt4" ;;
                  esac ;;
                cocos2d)
                  case "$docsetName" in
                    Cocos3D) keyword="cocos3d" ;;
                  esac ;;
              esac
            fi
          fi

          # Bail once we have a match
          break
        fi
      done

      # If we have a keyword, add it to the list!
      if [[ ! -z "$keyword" ]]; then
        _all_docsets+=($keyword)
      fi
    done

    # special thanks to [arx] on #zsh for getting me sorted on this piece
    compadd -qS: -- "$_all_docsets[@]"
    return
  fi
}
