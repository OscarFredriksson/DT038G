#!/bin/bash
#Laboration 2 i operativsystem
#Kod skriven av: Oscar Fredriksson
#2018-12-09

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

function validate_filename()
{
    if [ -f $filename ]
    then
        return 0
    else
        
        return -1
    fi
}

function get_filename()
{
    while true; do
        echo "Filename:"
        read filename

        validate_filename
        if [ $? == 0 ]
        then
            break
        else
            echo "Invalid filename, try again:"
        fi

    done
}

function print_file()
{
    echo ""
    while IFS=';' read -r id name weight length width height; do
        echo "$id $name $weight $length $width $height"
    done < "$filename"
    echo ""
}

function backup_file()
{
    backupname="${filename%.*}.backup"   #Tar bort filändelsen och lägger till .backup istället

    cat $filename > $backupname
}

function sort_file()
{
    case $1 in
        i)
            sort -n -t $';' -o $filename $filename;;
        n)
            sort -k2,2 -t $';' -o $filename $filename;; 
        v)
            sort -k3,3 -n -t $';' -o $filename $filename;; 
        l)
            sort -k4,4 -n -t $';' -o $filename $filename;; 
        b)
            sort -k5,5 -n -t $';' -o $filename $filename.;; 
        h)
            sort -k6,6 -n -t $';' -o $filename $filename;;
        *)
            echo "invalid column to sort on"
            return -1;;
    esac
    


    return 0
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
            s)
                get_filename
                while true; do
                    echo "What do you want to sort on?"
                    echo "(i): ID, (n): name, (v): weight, (l):length, (b): width, (h): height"
                    echo "Enter an option:"
                    read column

                    sort_file "$column"
                    if [ $? == 0 ]  #Kollar returvärdet
                    then
                        break
                    fi
                done
                ;;
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

filename="$1"   #Spara filnamnet

validate_filename   #Kolla så filnamnet är giltigt
if [ $? != 0 ]
then
    echo "Invalid filename"
    exit
fi

shift 1         #Flytta argumenten ett steg så getopts ignorerar filnamnet

while getopts "hpbs:-:" arg; do
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
        s) 
            sort_file "${OPTARG}"
            exit
            ;; 
        *)  
            echo "invalid option"
            exit 
            ;;
    esac
done


########################################################################################################################################################################################################################################################################