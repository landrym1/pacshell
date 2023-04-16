#!/bin/bash

# Pac-Man in a linux terminal
mpg321 background.mp3 &
MAP_WIDTH=28
MAP_HEIGHT=28
#MAP_WIDTH=7
#MAP_HEIGHT=7

ELEMENT_EMPTY=0
ELEMENT_WALL=1
ELEMENT_DOT=2
ELEMENT_BIG_DOT=3
ELEMENT_GHOST=4
ELEMENT_GHOST_WALL=5

ELEMENT_PACMAN_LEFT=6
ELEMENT_PACMAN_UP=7
ELEMENT_PACMAN_RIGHT=8
ELEMENT_PACMAN_DOWN=9

DO_DISPLAY_OVERWRITE=1

declare -A map

score=0
num_dots=233
lives=3
won=0

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

function build_map {
	map0=(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
        map1=(1 2 2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 2 2 1)
        map2=(1 2 1 1 1 1 2 1 1 1 1 1 2 1 1 2 1 1 1 1 1 2 1 1 1 1 2 1)
        map3=(1 3 1 1 1 1 2 1 1 1 1 1 2 1 1 2 1 1 1 1 1 2 1 1 1 1 3 1)
        map4=(1 2 1 1 1 1 2 1 1 1 1 1 2 1 1 2 1 1 1 1 1 2 1 1 1 1 2 1)
        map5=(1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1)
        map6=(1 2 1 1 1 1 2 1 1 2 1 1 1 1 1 1 1 1 2 1 1 2 1 1 1 1 2 1)
	map7=(1 2 1 1 1 1 2 1 1 2 1 1 1 1 1 1 1 1 2 1 1 2 1 1 1 1 2 1)
	map8=(1 2 2 2 2 2 2 1 1 2 2 2 2 1 1 2 2 2 2 1 1 2 2 2 2 2 2 1)
	map9=(1 1 1 1 1 1 2 1 1 1 1 1 0 1 1 0 1 1 1 1 1 2 1 1 1 1 1 1)
	map10=(0 0 0 0 0 1 2 1 1 1 1 1 0 1 1 0 1 1 1 1 1 2 1 0 0 0 0 0)
	map11=(0 0 0 0 0 1 2 1 1 1 1 1 0 1 1 0 1 1 1 1 1 2 1 0 0 0 0 0)
	map12=(0 0 0 0 0 1 2 1 1 1 0 0 0 0 0 0 0 0 1 1 1 2 1 0 0 0 0 0)
	map13=(1 1 1 1 1 1 2 1 1 1 0 1 1 5 5 1 1 0 1 1 1 2 1 1 1 1 1 1)
	map14=(0 0 0 0 0 0 2 0 0 0 0 1 0 0 0 0 1 0 0 0 0 2 0 0 0 0 0 0)
	map15=(1 1 1 1 1 1 2 1 1 1 0 1 1 1 1 1 1 0 1 1 1 2 1 1 1 1 1 1)
	map16=(0 0 0 0 0 1 2 1 1 1 0 0 0 0 0 0 0 0 1 1 1 2 1 0 0 0 0 0)
	map17=(0 0 0 0 0 1 2 1 1 1 0 1 1 1 1 1 1 0 1 1 1 2 1 0 0 0 0 0)
	map18=(1 1 1 1 1 1 2 1 1 1 0 1 1 1 1 1 1 0 1 1 1 2 1 1 1 1 1 1)
	map19=(1 2 2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 2 2 1)
	map20=(1 2 1 1 1 1 2 1 1 1 1 1 2 1 1 2 1 1 1 1 1 2 1 1 1 1 2 1)
	map21=(1 3 1 1 1 1 2 1 1 1 1 1 2 1 1 2 1 1 1 1 1 2 1 1 1 1 3 1)
	map22=(1 2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 2 1)
	map23=(1 1 1 2 1 1 2 1 1 2 1 1 1 1 1 1 1 1 2 1 1 2 1 1 2 1 1 1)
	map24=(1 2 2 2 2 2 2 1 1 2 2 2 2 1 1 2 2 2 2 1 1 2 2 2 2 2 2 1)
	map25=(1 2 1 1 1 1 1 1 1 1 1 1 2 1 1 2 1 1 1 1 1 1 1 1 1 1 2 1)
	map26=(1 2 2 2 2 2 2 2 2 2 2 2 2 6 2 2 2 2 2 2 2 2 2 2 2 2 2 1)
	map27=(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
        pacman_location=(26 13)
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
                                printf "\033[35m%c\033[35m" '#'
			elif [[ ${map[$r,$c]} -eq $ELEMENT_DOT ]]; then
                                printf "\033[36m%c\033[35m" '.'
			elif [[ ${map[$r,$c]} -eq $ELEMENT_BIG_DOT ]]; then
                                printf "%c" 'o'
			elif [[ ${map[$r,$c]} -eq $ELEMENT_GHOST ]]; then
                                printf "%c" 'G'
			elif [[ ${map[$r,$c]} -eq $ELEMENT_GHOST_WALL ]]; then
                                printf "%c" '-'
			elif [[ ${map[$r,$c]} -eq $ELEMENT_PACMAN_LEFT ]]; then
				printf "\033[33m%c\033[35m" ')'
			elif [[ ${map[$r,$c]} -eq $ELEMENT_PACMAN_UP ]]; then
                                printf "\033[33m%c\033[35m" 'U'
			elif [[ ${map[$r,$c]} -eq $ELEMENT_PACMAN_RIGHT ]]; then
                                printf "\033[33m%c\033[35m" '('
			elif [[ ${map[$r,$c]} -eq $ELEMENT_PACMAN_DOWN ]]; then
                                printf "\033[33m%c\033[35m" '^'
			fi
		done
		printf "\n"	
	done	
}

function update { 
	# row, col
	# find new location based on direction
	declare -a new_location
	pacman_direction=$(cat direction.txt)
	rm direction.txt
	if [[ $pacman_direction -eq 0 ]]; then
		new_location[0]=${pacman_location[0]}
		new_location[1]=$(( ${pacman_location[1]} - 1 ))
		if [[ new_location[1] -lt 0 ]]; then 
			new_location[1]=$(( $MAP_WIDTH - 1 ))
		fi
	elif [[ pacman_direction -eq 1 ]]; then
		new_location[0]=$(( ${pacman_location[0]} - 1 ))
                new_location[1]=${pacman_location[1]}
	elif [[ pacman_direction -eq 2 ]]; then
		new_location[0]=${pacman_location[0]}
                new_location[1]=$(( ${pacman_location[1]} + 1 ))
		if [[ new_location[1] -eq $MAP_WIDTH ]]; then
                        new_location[1]=0
                fi
	else
		new_location[0]=$(( ${pacman_location[0]} + 1 ))
                new_location[1]=${pacman_location[1]}
	fi
	# check new location for dot, wall, etc
	# ghost comes later
	new_cell=${map[${new_location[0]},${new_location[1]}]}
	if [[ $new_cell -eq $ELEMENT_DOT ]]; then
		(( score += 10 ))
		(( num_dots-- ))
	elif [[ $new_cell -eq $ELEMENT_BIG_DOT ]]; then
                (( score += 50 ))
		(( num_dots-- ))
	fi
	if [[ $new_cell -ne $ELEMENT_WALL ]] && [[ $new_cell -ne $ELEMENT_GHOST_WALL ]]; then
		map[${pacman_location[0]},${pacman_location[1]}]=$ELEMENT_EMPTY
		pacman_location[0]=${new_location[0]}
		pacman_location[1]=${new_location[1]}
	fi
	if [[ $pacman_direction -eq 0 ]]; then
                map[${pacman_location[0]},${pacman_location[1]}]=$ELEMENT_PACMAN_LEFT
        elif [[ $pacman_direction -eq 1 ]]; then
                map[${pacman_location[0]},${pacman_location[1]}]=$ELEMENT_PACMAN_UP
        elif [[ $pacman_direction -eq 2 ]]; then
                map[${pacman_location[0]},${pacman_location[1]}]=$ELEMENT_PACMAN_RIGHT
        else
                map[${pacman_location[0]},${pacman_location[1]}]=$ELEMENT_PACMAN_DOWN
        fi

	if [[ $num_dots -eq 0 ]]; then
		won=1
	fi
}

function get_input {
	read -rs -n 1 -t 0.05 arrow
        case $arrow in
        	'w') direction=1;;
                's') direction=3;;
                'd') direction=2;;
                'a') direction=0;;
		*) ;;
        esac
	echo $direction > direction.txt
}

function main {
	#build_map_test
	#file="background.mp3"
	#mplayer "$file" &
	build_map
	display
	if [[ $DO_DISPLAY_OVERWRITE -eq 1 ]]; then
		tput civis
		stty -echo
	fi
	while [ $won -eq 0 ]; do
		get_input
		{ time get_input; } 2> time.txt
		timing=$(cat time.txt | grep "real" | sed "s|0m||" | sed "s|\s||g" | sed "s|[a-z]||g")
		rm time.txt
		update
		if [[ $DO_DISPLAY_OVERWRITE -eq 1 ]]; then
			for((j = 0; j < $MAP_HEIGHT + 1; ++j)) do
				printf "[F"
			done
		fi
		display
		delay=$(echo "0.10 - $timing" | bc)
		sleep $delay
	done
	if [[ $DO_DISPLAY_OVERWRITE -eq 1 ]]; then
		tput cnorm
		stty echo
	fi
	echo "You won!"

	pid=$(pgrep mpg321)
	kill $pid
}

main


