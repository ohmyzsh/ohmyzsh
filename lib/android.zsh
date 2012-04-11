function android_sdk_version() {
  sdk=$(xmlstarlet sel -t -v "/manifest/uses-sdk/@android:minSdkVersion" AndroidManifest.xml 2> /dev/null) || return
  versions[1]='1.0 Base'
  versions[2]='1.1 Base 1.1'
  versions[3]='1.5 Cupcake'
  versions[4]='1.6 Cupcake'
  versions[5]='2.0 Eclair'
  versions[6]='2.0.1 Eclair 0.1'
  versions[7]='2.1 Eclair MR1'
  versions[8]='2.2 Froyo'
  versions[9]='2.3.0-2 Gingerbread'
  versions[10]='2.3.3-4 Gingerbread MR1'
  versions[11]='3.0 Honeycomb'
  versions[12]='3.1 Honeycomb MR1'
  versions[13]='3.2 Honeycomb MR2'
  versions[14]='4.0.0-2 Ice Cream Sandwich'
  versions[15]='4.0.0-2 Ice Cream Sandwich MR1'
  version="$versions[$sdk]"
  echo "$version"
}

function android_package_name() {
  package=$(xmlstarlet sel -t -v "/manifest/@package" AndroidManifest.xml 2> /dev/null) || return
  echo "$package"
}

function android_prompt_info() {
    if [ -n "$(android_sdk_version)" ]; then
    echo "${ZSH_THEME_ANDROID_PROMPT_PREFIX}$(android_package_name) $(android_sdk_version)${ZSH_THEME_ANDROID_PROMPT_SUFFIX}"
    fi
    
}