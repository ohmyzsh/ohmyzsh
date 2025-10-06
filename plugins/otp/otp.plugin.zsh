export OTP_HOME=~/.otp
mkdir -p $OTP_HOME

function ot () {
  if ! command -v oathtool > /dev/null 2>&1; then
    echo "Note: you need to install oathtool or oath-toolkit, depending on your OS or distribution."
    return 1
  fi

  if ! command -v gpg > /dev/null 2>&1; then
    echo "Note: you need to install gpg and create an ID using 'gpg --gen-key', unless you have one already."
    return 1
  fi

  COPY_CMD='true'

  if [[ -z "$1" ]]; then
    echo "usage: $0 <profile.name>"
    return 1
  elif [ ! -f $OTP_HOME/$1.otp.asc ]; then
    echo "missing profile $1, you might need to create it first using otp_add_device"
    return 1
  else
    totpkey=$(gpg --decrypt $OTP_HOME/$1.otp.asc)
    oathtool --totp --b $totpkey | tee /dev/stderr | clipcopy
  fi
}

function otp_add_device () {
  if [[ "x$1" == "x" ]] then
    echo "usage: $0 <profile.name>"
    return 1
  else
    echo "Enter an email address attached to your GPG private key, then paste the secret configuration key followed by ^D"

    rm -f $OTP_HOME/$1.otp.asc
    gpg --armor --encrypt --output $OTP_HOME/$1.otp.asc /dev/stdin
  fi
}

function otp_devices () {
  reply=($(find $OTP_HOME -name \*.otp.asc | xargs basename -s .otp.asc))
}

compctl -K otp_devices ot
