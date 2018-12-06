#!/bin/bash

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

function print_file()
{
    while IFS=';' read -r id name weight length width height; do
        echo "$id $name $weight $length $width $height"
    done < "$filename".txt
}

function backup_file()
{
    cat $filename.txt > $filename.backup
}


if [ -n "$3" ] 
then
    echo "För många argument"
    exit
fi

filename="$1"   #Spara filnamnet
shift 1         #Flytta argumenten ett steg så getopts ignorerar filnamnet

while getopts "hpb-:" arg; do

    #echo $arg

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
            print_file
            exit
            ;;
        b)  
            backup_file
            exit
            ;;
        *)  
            echo "invalid option"
            exit 
            ;;
    esac
done

#Interaktivt läge
#while true: do
#    echo Hello, who am I talking to?

#done