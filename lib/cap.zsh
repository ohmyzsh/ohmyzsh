# May need to trash `.zcompdump` and regenerate it 
# with `compinit` for this to work

_cap_does_task_list_need_generating () {
  if [ ! -f .cap_tasks~ ]; then return 0;
  else
    accurate=$(stat -f%m .cap_tasks~)
    changed=$(stat -f%m config/deploy.rb)
    return $(expr $accurate '>=' $changed)
  fi
}

_cap () {
  if [ -f capfile ]; then
    if _cap_does_task_list_need_generating; then
      echo "\nGenerating .cap_tasks~..." > /dev/stderr
      cap -vT | awk 'FB != 1 {if ($0 ~ /^$/){FB=1}else{print $2}}' > .cap_tasks~
    fi
    compadd `cat .cap_tasks~`
  fi
}

compctl -K _cap cap

