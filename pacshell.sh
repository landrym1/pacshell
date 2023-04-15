#!/bin/bash

# Pac-Man in a linux terminal

#MAP_WIDTH=27
#MAP_HEIGHT=40
MAP_WIDTH=7
MAP_HEIGHT=7

ELEMENT_EMPTY=0
ELEMENT_WALL=1
ELEMENT_DOT=2
ELEMENT_BIG_DOT=3
ELEMENT_GHOST=4

ELEMENT_PACMAN_LEFT=6
ELEMENT_PACMAN_UP=7
ELEMENT_PACMAN_RIGHT=8
ELEMENT_PACMAN_DOWN=9

declare -A map

function build_map_test {
	map0=(1 1 1 1 1 1 1)
	map1=(1 0 2 2 2 0 1)
	map2=(1 0 1 1 1 0 1)
	map3=(1 3 1 4 1 3 1)
	map4=(1 0 1 1 1 0 1)
	map5=(1 0 0 6 0 0 1)
	map6=(1 1 1 1 1 1 1)
	for ((r = 0; r < $MAP_HEIGHT; r++)); do
		printf -v row "map%d" $r
                for ((c = 0; c < $MAP_WIDTH; c++)); do
			printf -v cell "%s[%d]" $row $c
			map[$r,$c]=$(echo ${!cell})
		done
	done
}

function display {
	for ((r = 0; r < $MAP_HEIGHT; r++)); do
		for ((c = 0; c < $MAP_WIDTH; c++)); do
			if [[ ${map[$r,$c]} -eq $ELEMENT_EMPTY ]]; then
				printf "%c" ' '
			elif [[ ${map[$r,$c]} -eq $ELEMENT_WALL ]]; then
                                printf "%c" '='
			elif [[ ${map[$r,$c]} -eq $ELEMENT_DOT ]]; then
                                printf "%c" '.'
			elif [[ ${map[$r,$c]} -eq $ELEMENT_BIG_DOT ]]; then
                                printf "%c" 'o'
			elif [[ ${map[$r,$c]} -eq $ELEMENT_GHOST ]]; then
                                printf "%c" 'G'
			elif [[ ${map[$r,$c]} -eq $ELEMENT_PACMAN_LEFT ]]; then
				printf "%c" ')'
			elif [[ ${map[$r,$c]} -eq $ELEMENT_PACMAN_UP ]]; then
                                printf "%c" 'U'
			elif [[ ${map[$r,$c]} -eq $ELEMENT_RIGHT ]]; then
                                printf "%c" '('
			elif [[ ${map[$r,$c]} -eq $ELEMENT_DOWN ]]; then
                                printf "%c" '^'
			fi
		done
		printf "\n"	
	done	
}

build_map_test
display
