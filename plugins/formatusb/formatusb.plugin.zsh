# Utility function to format USB Stick/Hard Drive
# It will create a single partition that fills the whole drive space



format2usb-ext2() {
  if [ $# -lt 2 ]; then
    echo -e "format and create a partition that fills up the whole device"
    echo -e "\nUsage: $0 <label> <device>"
    echo -e "Example: $0 MY_USB sdx"
    return 1
  fi

  # check if the device is mounted
  mount_status=$(mount | grep /dev/"$2" | wc -l)
  if [ "$mount_status" -ne 0 ]
  then
    lsblk -o "NAME,SIZE,FSTYPE,TYPE,LABEL,MOUNTPOINT,UUID" | grep "$2"
    echo -e "${Red}/dev/$2 is mounted. You have to unmount /dev/$2 ${Color_Off}"
    return 1
  fi

  # list out all drives
  lsblk -o "NAME,SIZE,FSTYPE,TYPE,LABEL,MOUNTPOINT,UUID" | grep --color -E "$2|$"

  echo -n -e "${Red}WARNING: You are about to FORMAT a drive. Do you want to continue? [y/n] ${Color_Off}"
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo "... You chose to continue"
  else
    return 1
  fi

  # delete existing partition then create new linux partition
  echo -e "d\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\no\nn\np\n1\n\n\nw" | sudo fdisk /dev/"$2"

  # delete partiton x8 using d\n\n
  # d    delete a partition
  #      default, partition

  # o    create a new empty DOS partition table
  # n    add a new partition
  # p    print the partition table
  # 1    partition number 1
  #      default, start immediately after preceding partition
  #      default, extend partition to end of disk
  # w    write table to disk and exit

  # format device
  echo -e "y\n" | sudo mkfs.ext2 -L "$1" /dev/"$2"1

  # set permission
  mkdir -p /tmp/testmount
  sudo mount /dev/"$2"1 /tmp/testmount
  sudo chmod -R 777 /tmp/testmount
  sudo umount /tmp/testmount
  rmdir /tmp/testmount
}

format2usb-ext3() {
  if [ $# -lt 2 ]; then
    echo -e "format and create a partition that fills up the whole device"
    echo -e "\nUsage: $0 <label> <device>"
    echo -e "Example: $0 MY_USB sdx"
    return 1
  fi

  # check if the device is mounted
  mount_status=$(mount | grep /dev/"$2" | wc -l)
  if [ "$mount_status" -ne 0 ]
  then
    lsblk -o "NAME,SIZE,FSTYPE,TYPE,LABEL,MOUNTPOINT,UUID" | grep "$2"
    echo -e "${Red}/dev/$2 is mounted. You have to unmount /dev/$2 ${Color_Off}"
    return 1
  fi

  # list out all drives
  lsblk -o "NAME,SIZE,FSTYPE,TYPE,LABEL,MOUNTPOINT,UUID" | grep --color -E "$2|$"

  echo -n -e "${Red}WARNING: You are about to FORMAT a drive. Do you want to continue? [y/n] ${Color_Off}"
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo "... You chose to continue"
  else
    return 1
  fi

  # delete existing partition then create new linux partition
  echo -e "d\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\no\nn\np\n1\n\n\nw" | sudo fdisk /dev/"$2"

  # delete partiton x8 using d\n\n
  # d    delete a partition
  #      default, partition

  # o    create a new empty DOS partition table
  # n    add a new partition
  # p    print the partition table
  # 1    partition number 1
  #      default, start immediately after preceding partition
  #      default, extend partition to end of disk
  # w    write table to disk and exit

  # format device
  echo -e "y\n" | sudo mkfs.ext3 -L "$1" /dev/"$2"1

  # set permission
  mkdir -p /tmp/testmount
  sudo mount /dev/"$2"1 /tmp/testmount
  sudo chmod -R 777 /tmp/testmount
  sudo umount /tmp/testmount
  rmdir /tmp/testmount
}

format2usb-ext4() {
  if [ $# -lt 2 ]; then
    echo -e "format and create a partition that fills up the whole device"
    echo -e "\nUsage: $0 <label> <device>"
    echo -e "Example: $0 MY_USB sdx"
    return 1
  fi

  # check if the device is mounted
  mount_status=$(mount | grep /dev/"$2" | wc -l)
  if [ "$mount_status" -ne 0 ]
  then
    lsblk -o "NAME,SIZE,FSTYPE,TYPE,LABEL,MOUNTPOINT,UUID" | grep "$2"
    echo -e "${Red}/dev/$2 is mounted. You have to unmount /dev/$2 ${Color_Off}"
    return 1
  fi

  # list out all drives
  lsblk -o "NAME,SIZE,FSTYPE,TYPE,LABEL,MOUNTPOINT,UUID" | grep --color -E "$2|$"

  echo -n -e "${Red}WARNING: You are about to FORMAT a drive. Do you want to continue? [y/n] ${Color_Off}"
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo "... You chose to continue"
  else
    return 1
  fi

  # delete existing partition then create new linux partition
  echo -e "d\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\no\nn\np\n1\n\n\nw" | sudo fdisk /dev/"$2"

  # delete partiton x8 using d\n\n
  # d    delete a partition
  #      default, partition

  # o    create a new empty DOS partition table
  # n    add a new partition
  # p    print the partition table
  # 1    partition number 1
  #      default, start immediately after preceding partition
  #      default, extend partition to end of disk
  # w    write table to disk and exit

  # format device
  echo -e "y\n" | sudo mkfs.ext4 -L "$1" /dev/"$2"1

  # set permission
  mkdir -p /tmp/testmount
  sudo mount /dev/"$2"1 /tmp/testmount
  sudo chmod -R 777 /tmp/testmount
  sudo umount /tmp/testmount
  rmdir /tmp/testmount
}

format2usb-fat32() {
  if [ $# -lt 2 ]; then
    echo -e "format and create a partition that fills up the whole device"
    echo -e "\nUsage: $0 <label> <device>"
    echo -e "Example: $0 MY_USB sdx"
    return 1
  fi

  # check if the device is mounted
  mount_status=$(mount | grep /dev/"$2" | wc -l)
  if [ "$mount_status" -ne 0 ]
  then
    lsblk -o "NAME,SIZE,FSTYPE,TYPE,LABEL,MOUNTPOINT,UUID" | grep "$2"
    echo -e "${Red}/dev/$2 is mounted. You have to unmount /dev/$2 ${Color_Off}"
    return 1
  fi

  # list out all drives
  lsblk -o "NAME,SIZE,FSTYPE,TYPE,LABEL,MOUNTPOINT,UUID" | grep --color -E "$2|$"

  echo -n -e "${Red}WARNING: You are about to FORMAT a drive. Do you want to continue? [y/n] ${Color_Off}"
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo "... You chose to continue"
  else
    return 1
  fi

  # delete existing partition then create new linux partition
  echo -e "d\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\no\nn\np\n1\n\n\nt\nb\nw" | sudo fdisk /dev/"$2"

  # delete partiton x8 using d\n\n
  # d    delete a partition
  #      default, partition

  # o    create a new empty DOS partition table
  # n    add a new partition
  # p    print the partition table
  # 1    partition number 1
  #      default, start immediately after preceding partition
  #      default, extend partition to end of disk
  # t    change a partition type (L to list all types)
  # b    W95 FAT32
  # w    write table to disk and exit

  # fat32 likes the labels to be in uppercase
  label_name=$(echo "$1" | tr '[:lower:]' '[:upper:]')

  # format device
  sudo mkfs.fat -F 32 -n "$label_name" -I /dev/"$2"1

  # set permission
  mkdir -p /tmp/testmount
  sudo mount /dev/"$2"1 /tmp/testmount
  sudo chmod -R 777 /tmp/testmount
  sudo umount /tmp/testmount
  rmdir /tmp/testmount
}

format2usb-ntfs() {
  if [ $# -lt 2 ]; then
    echo -e "format and create a partition that fills up the whole device"
    echo -e "\nUsage: $0 <label> <device>"
    echo -e "Example: $0 MY_USB sdx"
    return 1
  fi

  # check if the device is mounted
  mount_status=$(mount | grep /dev/"$2" | wc -l)
  if [ "$mount_status" -ne 0 ]
  then
    lsblk -o "NAME,SIZE,FSTYPE,TYPE,LABEL,MOUNTPOINT,UUID" | grep "$2"
    echo -e "${Red}/dev/$2 is mounted. You have to unmount /dev/$2 ${Color_Off}"
    return 1
  fi

  # list out all drives
  lsblk -o "NAME,SIZE,FSTYPE,TYPE,LABEL,MOUNTPOINT,UUID" | grep --color -E "$2|$"

  echo -n -e "${Red}WARNING: You are about to FORMAT a drive. Do you want to continue? [y/n] ${Color_Off}"
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo "... You chose to continue"
  else
    return 1
  fi

  # delete existing partition then create new linux partition
  echo -e "d\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\no\nn\np\n1\n\n\nt\n7\nw" | sudo fdisk /dev/"$2"

  # delete partiton x8 using d\n\n
  # d    delete a partition
  #      default, partition

  # o    create a new empty DOS partition table
  # n    add a new partition
  # p    print the partition table
  # 1    partition number 1
  #      default, start immediately after preceding partition
  #      default, extend partition to end of disk
  # t    change a partition type (L to list all types)
  # 7    HPFS/NTFS/exFAT
  # w    write table to disk and exit

  # format device
  sudo mkfs.ntfs -f -L "$1" /dev/"$2"1

  # set permission
  mkdir -p /tmp/testmount
  sudo mount /dev/"$2"1 /tmp/testmount
  sudo chmod -R 777 /tmp/testmount
  sudo umount /tmp/testmount
  rmdir /tmp/testmount
}

# }}}