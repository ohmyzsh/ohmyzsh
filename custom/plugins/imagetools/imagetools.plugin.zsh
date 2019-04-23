## image manipulation
function imgRemoveWhiteBackground {
  fileType="${1:-png}"
  blurRad="${2:-20}"
  find . -type f -name *.$fileType -print0 | while IFS= read -r -d $'\0' file; do 
    convert -verbose $file -fuzz $blurRad% -transparent white "$file"; 
  done
}

function imgMaxSize {
  maxSize="${1:-1500}"
  fileType="${2:-png}"
  for file in *.$fileType ; do 
    convert -verbose $file -thumbnail "$maxSizex$maxSize" ./$file ; 
  done
}

function imgConvertFormat {
  fromFileType="${1:-png}"
  toFileType="${2:-jpg}"
  for file in *.$fromFileType ; do 
    convert -verbose $file "$( echo "./$file.$toFileType" | sed -e "s/\.$fromFileType//" )" ; 
  done
}

function imgMaxSizeConvertTiny {
  maxSize="${1:-1500}"
  fromFileType="${2:-png}"
  toFileType="${3:-jpg}"
  imgMaxSize $maxSize $fromFileType;
  imgConvertFormat $fromFileType $toFileType;
  tinypng;
}

function imagetools {
  echo "imgRemoveWhiteBackground < file type : png > < blur radius (tolerance) : 20 > - Bulk remove white background from all images in dir of specified format";
  echo "imgMaxSize < largest h or w in pixels : 1500 > - Bulk contain image sizes by each largest dimension";
  echo "imgConvertFormat < target format : png > <destination format : jpeg > - Bulk convert images from target format to destination format";
  echo "imgMaxSizeConvertTiny < largest h or w in pixels : 1500 > < target format : png > <destination format : jpeg > - All of the above combined";
}