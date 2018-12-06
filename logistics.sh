#!/bin/bash

function print_help()
{
    echo ""
    echo "Usage: logistics FILE [-b|-p|-s {i|n|v|l|b|h}]"
    echo "Used for logistics management with FILE as underlying data."
    echo "  -b      generate backup copy of data contents"
    echo "  -p      print data contents and exit"
    echo "  -s      sort by additional argument: id (i), name (n)," 
    echo "          weight (v), length (l) width (b), height (h)," 
    echo "          print data contents and exit"
    echo "  --help display this help and exit"
    echo ""
}

function get_filename()
{
    while true; do
        echo "Filename:"
        read filename
        if [ -f $filename.txt ]
        then
            break
        else
            echo "Invalid filename"
        fi
    done
}

function print_file()
{
    echo ""
    while IFS=';' read -r id name weight length width height; do
        echo "$id $name $weight $length $width $height"
    done < "$filename".txt
    echo ""
}

function backup_file()
{
    cat $filename.txt > $filename.backup
}

function interactive_menu()
{
    while true; do
        
        echo "What do you want to do?"
        echo "(p): print file content, (b): backup file, (s): sort file, (h): print help text, (e): exit program" 
        echo "Enter an option:"
        read input

        case $input in

            h)
                print_help;;
            p)
                get_filename
                print_file;;
            b)
                get_filename
                backup_file;;
            e)
                exit;;
            *)
                echo "Invalid input, try again"
                ;;
        
        esac

    done
}

if [ -z "$1" ]
then interactive_menu
fi

if [ -n "$3" ] 
then
    
    echo "För många argument"
    exit
fi

filename="$1"   #Spara filnamnet
shift 1         #Flytta argumenten ett steg så getopts ignorerar filnamnet

while getopts "hpb-:" arg; do
    case $arg in
        -)  #Kolla efter lång flagga
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