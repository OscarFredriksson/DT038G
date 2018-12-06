#!/bin/bash

filename="data.txt"


while getopts "hp" arg; do
  case $arg in
    h)
        echo "Hjälptext!"
        exit
        ;;
    p)
        while IFS=';' read -r id name weight length width height; do
            echo "$id $name $weight $length $width $height"
        done < "$filename"
        exit
        ;;
  esac
done

