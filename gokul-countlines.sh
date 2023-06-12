#!/bin/bash

echo "countig lines...."

owner=""
month=""

help_message() {
    echo "invalid command: no parameter included with argument $OPTARG"
    echo "valid arguments format"
    echo "./gokul-countlines.sh -o owner -m month"
    echo "month should be of format Jan, Feb, etc.."
}

shouldGetLines() {
  fileInfo=`stat --printf "%n|%G|%w|" $1`
  IFS="|" read -a fileInfoArray <<< $fileInfo
  MONTH=$(date -d "${fileInfoArray[2]}" '+%b')
  valid=1

  if [ ${owner^^} = ${fileInfoArray[1]^^} ] && [ ${month^^} = ${MONTH^^} ]; then
    valid=0
  fi
  
  return $valid
}

countLines() {
  shouldGetLines $1
  valid=$?
  if [ $valid = 0 ]; then
    count=`wc -l $1`
    echo "File: $1, Lines: $count"
  fi
}

while getopts ":o:m:" opt; do
  case $opt in
     o)
       owner=$OPTARG >&2
       ;;
     m)
       month=$OPTARG >&2
       ;;
     *)
       help_message
       ;;
  esac
done


for FILE in *; do 
  countLines $FILE;
done