#!/bin/bash

FOOD="\033[1;32mo\033[0m"
MONSTER="\033[1;31m#\033[0m"
BOARD="\033[46;36mX\033[0m"

function get_config {
cat snake.conf | grep $1 | cut -d' ' -f2
}


function show_menu {
	clear
	echo -e "\n\n\t\t MENU\n"
	echo "1) play"
	echo "2) how to play"
	echo "3) change difficult [`get_config DIFFICULT`]"
	echo "4) best scores"
	echo "5) credits"
	echo "q) quit"
}


function best_scores {
	clear
	echo -e "\n\n\t\t BEST SCORES\n"
	cat best_scores.txt | column -t | sort -n -r -k2 | head -20
	echo -e "\npress any key to quit best scores"
	read -n 1 x
	if [[ ! -z $x ]]; then
		show_menu
		menu
	fi
}


function instruction {
	clear
	echo -e "\n\n\t\t INSTRUCTION\n"
	echo "Snake's head - @"
	echo "Snake's body - O"
	echo -e "Food - $FOOD"
	echo -e "Monster - $MONSTER"
	echo -e "Board border - $BOARD"
	echo
	echo "press 'w' to move up"
	echo "press 's' to move down"
	echo "press 'd' to move right"
	echo "press 'a' to move left"
	echo
	echo "press any other key to pause the game"
	echo -e "game ends if you crash with $BOARD or $MONSTER or eat yourself"
	echo -e "\npress any key to quit instructions"
	read -n 1 x
	if [[ ! -z $x ]]; then
		show_menu
		menu
	fi
}


function credits {
	clear
	echo -e "\n\n\t\t CREDITS\n"
	echo "Author: Mikolaj Glodziak"
	echo "This game is a part of Udemy course:  "
	read -n 1 x
	if [[ ! -z $x ]]; then
		show_menu
		menu
	fi
}


function change_difficult {
current_difficult=`get_config DIFFICULT`
if [[ $current_difficult = "easy" ]]; then
	sed -i 's/DIFFICULT easy/DIFFICULT medium/' snake.conf
	sed -i 's/NUMBER_OF_MONSTERS 0/NUMBER_OF_MONSTERS 4/' snake.conf
	sed -i 's/NUMBER_OF_FOOD 12/NUMBER_OF_FOOD 9/' snake.conf
	sed -i 's/BLANK 80/BLANK 60/' snake.conf
	sed -i 's/SCORE 1/SCORE 2/' snake.conf

elif [[ $current_difficult = "medium" ]]; then
	sed -i 's/DIFFICULT medium/DIFFICULT hard/' snake.conf
	sed -i 's/NUMBER_OF_MONSTERS 4/NUMBER_OF_MONSTERS 8/' snake.conf
	sed -i 's/NUMBER_OF_FOOD 9/NUMBER_OF_FOOD 6/' snake.conf
	sed -i 's/BLANK 60/BLANK 40/' snake.conf
	sed -i 's/SCORE 2/SCORE 3/' snake.conf

elif [[ $current_difficult = "hard" ]]; then
	sed -i 's/DIFFICULT hard/DIFFICULT easy/' snake.conf
	sed -i 's/NUMBER_OF_MONSTERS 8/NUMBER_OF_MONSTERS 0/' snake.conf
	sed -i 's/NUMBER_OF_FOOD 6/NUMBER_OF_FOOD 12/' snake.conf
	sed -i 's/BLANK 40/BLANK 80/' snake.conf
	sed -i 's/SCORE 3/SCORE 1/' snake.conf
fi

show_menu
menu
}


function menu {
	echo  ""
	read -n 1 -p "Your choice: " choice

	case $choice in
		1) 	echo -e "\npress 'w' or 'a' or 's' or 'd' to start game"
		./game.sh ;;

		2) instruction ;;

		3) change_difficult ;;

		4) best_scores ;;

		5) credits ;;

		q|Q) 	echo ""
		exit ;;

		*) echo "Wrong choice. Try one more time."
		show_menu
		menu ;;
	esac
}

show_menu
menu
