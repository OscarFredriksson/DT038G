#!/bin/bash

filename="data.txt"


while getopts "h" arg; do
  case $arg in
    h)
      echo "Hjälptext!"
      exit
      ;;
  esac
done

while IFS=';' read -r id name weight length width height; do
      echo "$id $name $weight $length $width $height"
 done < "$filename"