#!/bin/bash

filename="data"


function print_help()
{
    echo "Usage: logistics FILE [-b|-p|-s {i|n|v|l|b|h}]"
    echo "Used for logistics management with FILE as underlying data."
    echo "  -b      generate backup copy of data contents"
    echo "  -p      print data contents and exit"
    echo "  -s      sort by additional argument: id (i), name (n)," 
    echo "          weight (v), length (l) width (b), height (h)," 
    echo "          print data contents and exit"
    echo "  --help display this help and exit"
}

if [ -n "$2" ] 
then
    echo "För många argument"
    exit
fi

while getopts "hpb-:" arg; do
    case $arg in
        -)
            case "${OPTARG}" in
                help)
                    print_help
                    exit
                    ;;
            esac;;
        h)
            print_help
            exit
            ;;
        p)
            while IFS=';' read -r id name weight length width height; do
                echo "$id $name $weight $length $width $height"
            done < "$filename".txt
            exit
            ;;
        b)  
            cat $filename.txt > $filename.backup
            exit
            ;;
        *)  
            echo "invalid option"
            exit 
            ;;
    esac
done

echo "please enter an option"