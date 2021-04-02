#!/bin/bash

var_no_monsters=`cat count_of_monsters`
var_no_eats=`cat count_of_eats`

function show_menu {
	
	clear
	echo -e "\n\n\t\t MENU\n"
	echo "1) play"
	echo "2) how to play"

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
echo "Snake's head is '@'"
echo "Snake is 'O'"
echo "Eat is 'o'"
echo ""
echo "press 'w' to move up"
echo "press 's' to move down"
echo "press 'd' to move right"
echo "press 'a' to move left"
echo ""
echo "press any other key to pause the game"
echo "game ends if you crash with 'X' (end of chart) or eat yourself"
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
echo "Special thanks to Daria Gryla for testing, patience and assistance"
echo ""
echo "Copyrights by Mikolaj Glodziak, AGH - University of science and technology, Cracow, Poland, 2019"
echo -e "\npress any key to quit credits"
read -n 1 x
  if [[ ! -z $x ]]; then
                show_menu
                menu
                fi


}

function menu {
echo  ""
read -n 1 -p "Your choice: " choice

case $choice in
	1) 	echo -e "\npress 'w' or 'a' or 's' or 'd' to start game"
		./game.sh $var_no_monsters $var_no_eats ;;

	2) instruction ;;

	

	4) best_scores ;;

	5) credits ;;

	q|Q) 	echo ""
		exit ;;

	*) echo "Wrong choice. Try one more time." 
		show_menu
		menu ;;
esac
}

printf "\n\n Welcome to snake bash-game!\n\n"

show_menu
menu
