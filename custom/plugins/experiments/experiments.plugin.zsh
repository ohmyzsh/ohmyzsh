function experimentsplit {
  #BRANCH=$( echo "WEB-4083-conditional-logout-link" | sed $'s/-/\\\n/g' );
  BRANCH=$( echo "WEB-4083-conditional-logout-link" | tr '-' ' ' );
  ARR=(`echo ${BRANCH}`);
  echo ${ARR[2]};
}
