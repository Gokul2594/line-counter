#!/bin/bash

echo "countig lines...."

help_message() {
    echo "invalid command: no parameter included with argument $OPTARG"
    echo "valid arguments format"
    echo "./gokul-countlines.sh -o owner -m month"
}

while getopts ":o:m:" opt; do
  case $opt in
     o)
       echo "-o parameter $OPTARG" >&2
       ;;
     m)
       echo "-m parameter $OPTARG" >&2
       ;;
     *)
       help_message
       ;;
  esac
done