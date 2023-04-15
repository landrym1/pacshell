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

score=0
lives=3

declare -a pacman_location
declare -i pacman_direction

function build_map_test {
	map0=(1 1 1 1 1 1 1)
	map1=(1 0 2 2 2 0 1)
	map2=(1 0 1 1 1 0 1)
	map3=(1 3 1 4 1 3 1)
	map4=(1 0 1 1 1 0 1)
	map5=(1 2 2 6 0 0 1)
	map6=(1 1 1 1 1 1 1)
	pacman_location=(5 3)
	pacman_direction=0
	for ((r = 0; r < $MAP_HEIGHT; r++)); do
		printf -v row "map%d" $r
                for ((c = 0; c < $MAP_WIDTH; c++)); do
			printf -v cell "%s[%d]" $row $c
			map[$r,$c]=$(echo ${!cell})
		done
	done
}

function display {
	printf "Score: %d           Lives: %d\n" $score $lives
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

function update { 
	# row, col
	# find new location based on direction
	declare -a new_location
	if [[ $pacman_direction -eq 0 ]]; then
		new_location[0]=${pacman_location[0]}
		new_location[1]=$(( ${pacman_location[1]} - 1 ))
	elif [[ pacman_direction -eq 1 ]]; then
		new_location[0]=$(( ${pacman_location[0]} - 1 ))
                new_location[1]=${pacman_location[1]}
	elif [[ pacman_direction -eq 2 ]]; then
		new_location[0]=${pacman_location[0]}
                new_location[1]=$(( ${pacman_location[1]} + 1 ))
	else
		new_location[0]=$(( ${pacman_location[0]} + 1 ))
                new_location[1]=${pacman_location[1]}
	fi
	# check new location for dot, wall, etc
	# ghost comes later
	new_cell=${map[${new_location[0]},${new_location[1]}]}
	if [[ $new_cell -eq $ELEMENT_DOT ]]; then
		(( score += 10 ))
	elif [[ $new_cell -eq $ELEMENT_BIG_DOT ]]; then
                (( score += 50 ))
	fi
	if [[ $new_cell -ne $ELEMENT_WALL ]]; then
		map[${pacman_location[0]},${pacman_location[1]}]=$ELEMENT_EMPTY
		pacman_location[0]=${new_location[0]}
		pacman_location[1]=${new_location[1]}
		if [[ $pacman_direction -eq 0 ]]; then
			map[${pacman_location[0]},${pacman_location[1]}]=$ELEMENT_PACMAN_LEFT
		elif [[ $pacman_direction -eq 1 ]]; then
                        map[${pacman_location[0]},${pacman_location[1]}]=$ELEMENT_PACMAN_UP
		elif [[ $pacman_direction -eq 2 ]]; then
                        map[${pacman_location[0]},${pacman_location[1]}]=$ELEMENT_PACMAN_RIGHT
		else
                        map[${pacman_location[0]},${pacman_location[1]}]=$ELEMENT_PACMAN_DOWN
		fi
	fi
}

function main {
	build_map_test
	for ((i = 0; i < 5; i++)); do
		display
		update
		sleep 1
	done
	echo "Finished!"
}

main
