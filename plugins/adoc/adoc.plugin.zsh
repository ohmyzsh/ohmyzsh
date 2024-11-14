adoc() {
  if [ -e "docs/index.html" ] && [ "docs/index.html" -nt "README.adoc" ] ; then
    echo "adoc: 'docs/index.html' is up to date."
  else
    asciidoctor README.adoc -o docs/index.html \
      --require=asciidoctor-diagram \
      --attribute nofooter \
      --attribute toc=left \
      --attribute source-highlighter=highlight.js \
      --attribute sectnums \
      --attribute sectnumlevels=2
  fi
}
