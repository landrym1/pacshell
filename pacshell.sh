#!/bin/bash


#<
while true; do
    read -n 1 key
    case "$key" in $'\x1b')   
            read -rsn2 -t 0.01 arrow # Read the next 2 characters quickly
            case "$arrow" in
                '[A') echo "Up arrow"
		      echo "test"	;;
                '[B') echo "Down arrow" ;;
                '[C') echo "Right arrow" ;;
                '[D') echo "Left arrow" ;;
                *) echo "Unknown arrow sequence: $arrow" ;;
            esac
            ;;
        *) echo "Unknown key: $key" ;;
    esac
done
>#
