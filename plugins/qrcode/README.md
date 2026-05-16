# QRCode plugin

Generate a QR Code from the command line. Uses [QRcode.show](https://qrcode.show) via curl.

alias           | command
--------------- | --------
`qrcode [text]` | `curl -d "text" qrcode.show`
`qrsvg  [text]` | `curl -d "text" qrcode.show -H "Accept: image/svg+xml"`
