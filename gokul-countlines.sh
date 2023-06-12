#!/bin/bash

owner=""
month=""
flow=""

help_message() {
    echo "valid arguments format should be:"
    echo "./gokul-countlines.sh -o owner -m month"
    echo "month should be of format Jan, Feb, etc.."
}

isValidMonth() {
  temp=$1
  validMonth=1
  if [ ${month^^} = ${temp^^} ]; then
    validMonth=0
  fi
  return $validMonth
}

isValidOwner() {
  validOwner=1
  if [ ${owner^^} = $1 ]; then
    validOwner=0
  fi
  return $validOwner
}

getLines() {
  fileInfo=`stat --printf "%n|%G|%w|" $1`
  IFS="|" read -a fileInfoArray <<< $fileInfo
  MONTH=$(date -d "${fileInfoArray[2]}" '+%b')

  if [ $flow = "OWNERMONTH" ]; then
    isValidMonth $MONTH
    validatedMonth=$?
    isValidOwner ${fileInfoArray[1]^^}
    validatedOwner=$?

    if [ $validatedMonth = 0 ] && [ $validatedOwner = 0 ]; then
      countLines $1
    fi

  elif [ $flow = "OWNER" ]; then
    isValidOwner ${fileInfoArray[1]^^}
    validatedOwner=$?
    
    if [ $validatedOwner = 0 ]; then
      countLines $1
    fi
  
  else
    isValidMonth $MONTH
    validatedMonth=$?
    if [ $validatedMonth = 0 ]; then
      countLines $1
    fi
  fi
}

setFlow() {
  if [ ! -z "$owner" ] && [ ! -z "$month" ]; then
    echo "Looking for files created in the month: $month by: $owner"
    flow="OWNERMONTH"
  elif [ ! -z "$owner" ] && [ -z "$month" ]; then
    echo "Looking for files created by: $owner"
    flow="OWNER"
  else
    echo "Looking for files created in the month: $month"
    flow="MONTH"
  fi
}

countLines() {
  count=`wc -l $1`
  echo "File: $1, Lines: $count"
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

if [ $# -eq 0 ];
then
    help_message
    exit 0
else
  setFlow
  for FILE in *; do
    getLines $FILE
  done
fi
