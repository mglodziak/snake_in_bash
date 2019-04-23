#!/bin/bash

var_width_game=32
var_height_game=18
var_width_game_half=$[$var_width_game/2]
var_height_game_half=$[$var_height_game/2]
var_snake_length=2
var_score=0

var_position_x=0 #player position
var_position_y=0

var_number_of_eats=15

for (( i=1; $i<=$var_number_of_eats; i++ )); do
tab_eat_position_x[$i]=0 #eat positions
tab_eat_position_y[$i]=0
done


function make_place {

        rm place
        touch place
        for (( i=1;$i<=$var_height_game;i++ )); do
                  for (( j=1; $j<=$var_width_game; j++ )); do
                          if [[ $i -eq 1 || $j -eq 1 || $j -eq $var_width_game  || $i -eq $var_height_game ]]; then
                                 printf "X"  >> place
                  else
                                 printf " " >> place
                          fi
                  done
                  printf '\n' >> place
                done
}

function show_place {
        echo -e "\n\n\n\n\n"
        printf "\t\t     Score: $var_score\n\n"
cat place
  }


    function set_player_start_point {

var_start_x=$1
var_start_y=$2
var_object=$3
var_position_x=$var_start_x
var_position_y=$var_start_y

           gawk -v start_y="$var_start_y"\
                 -v start_x="$var_start_x"\
                  -v height="$var_height_game"\
                   -v object="$var_object"\
                  -i inplace -F "" 'BEGINFILE{NF=height; OFS=""} {if(NR==start_y) {$start_x=object} {print $0}}' place
  }

  function end_game {
        echo -e "\n"
        printf "\t\t Game over!\n\n "
        printf "\t"
        read -p "Enter your name: " name
        date=`date +"%H:%M  %d.%m.%y"`
        echo -e "$name \t $var_score \t $date" >> best_scores.txt

./start.sh
exit
}

function delete_old_P {
         gawk -v x="$1"\
                 -v y="$2"\
                   -v height="$var_height_game"\
                    -i inplace -F "" 'BEGINFILE{NF=height; OFS=""} {if(NR==y) {$x=" "} {print $0}}' place

}


function set_new_P {
         gawk -v x="$1"\
                 -v y="$2"\
                  -v object=$3\
                   -v height="$var_height_game"\
                  -i inplace -F "" 'BEGINFILE{NF=height; OFS=""} {if(NR==y) {$x=object} {print $0}}' place

}
function move_player {
if [[ $var_position_x -eq 1 ||\
        $var_position_y -eq 1 ||\
        $var_position_x -eq $var_width_game  ||\
        $var_position_y -eq $var_height_game ]];
then
        end_game

else
        read -t 0.1 -n 1 key

if [[ ! -z $key ]]; then
key2=$key
fi
delete_old_P $var_position_x $var_position_y
        case $key2 in

        w|W) 
                var_position_y=$[$var_position_y-1] ;;

        a|A) 
                var_position_x=$[$var_position_x-1] ;;

        s|S) 
                var_position_y=$[$var_position_y+1] ;;
        d|D) 
                var_position_x=$[$var_position_x+1] ;;

        *) move_player  ;;

        esac
	is_kill2
set_new_P $var_position_x $var_position_y '@'
fi

}

 function set_eat_start_points {
for (( i=1; $i<=$var_number_of_eats; i++ )); do

random_eat_xy
var_start_x=${tab_eat_position_x[$i]}
var_start_y=${tab_eat_position_y[$i]}
var_object=$1

           gawk -v start_y="$var_start_y"\
                 -v start_x="$var_start_x"\
                  -v height="$var_height_game"\
                   -v object="$var_object"\
                  -i inplace -F "" 'BEGINFILE{NF=height; OFS=""} {if(NR==start_y) {$start_x=object} {print $0}}' place

   done
  }


function stay_eats {
for (( i=1; $i<=$var_number_of_eats; i++ )); do
 set_new_P ${tab_eat_position_x[$i]} ${tab_eat_position_y[$i]} 'o'
done
}

function is_eaten {
for (( i=1; $i<=$var_number_of_eats; i++ )); do


        if [[ $var_position_x -eq ${tab_eat_position_x[$i]} && $var_position_y -eq ${tab_eat_position_y[$i]} ]]; then

        var_score=$[$var_score+1]
	var_snake_length=$[$var_snake_length+1]
        random_xy_generator
        tab_eat_position_x[$i]=$var_random_x
        tab_eat_position_y[$i]=$var_random_y


        fi
        done
}


function random_xy_generator {
var_random_x=$(( $RANDOM % $[$var_width_game-2] + 2 ))
var_random_y=$(( $RANDOM % $[$var_height_game-2] + 2 ))
}


function random_eat_xy {
        for (( i=1; $i<=$var_number_of_eats; i++ )); do

        random_xy_generator
while [[ 1 ]]; do
if [[ $var_random_x -gt 23 && $var_random_x -lt 29 && $var_random_y -gt 8 && $var_random_y -lt 14 ]]; then
        random_xy_generator

else

tab_eat_position_x[$i]=$var_random_x
tab_eat_position_y[$i]=$var_random_y
break
fi
done

done
}


function build_snake {
      
	tmp_x=`tac positions | sed -n "2,2"p | tr ' ' '\n' | head -1`
        tmp_y=`tac positions | sed -n "2,2"p | tr ' ' '\n' | tail -1`
	set_new_P $tmp_x $tmp_y 'O'


	tmp_x=`tac positions | sed -n "$var_snake_length,$var_snake_length"p | tr ' ' '\n' | head -1`
	tmp_y=`tac positions | sed -n "$var_snake_length,$var_snake_length"p | tr ' ' '\n' | tail -1`
	delete_old_P $tmp_x $tmp_y
	#done

}



function is_kill2 {
cat place | gawk -v x="$var_position_x"\
                 -v y="$var_position_y"\
                  -v object='O'\
                   -v height="$var_height_game"\
		   -F "" 'BEGINFILE{NF=height; OFS=""} {if(NR==y && $x=="O") {print "1"}}' > xxx
tmp=`cat xxx`
if [[ $tmp -eq 1 ]]; then
	printf "\n You ate yourself...\n"
end_game
fi

}
function game {

	rm positions
  make_place
  set_player_start_point $var_width_game_half $var_height_game_half '@'
  echo "$var_position_x $var_position_y" >> positions
  set_eat_start_points 'o'
 
  while [[ 1 ]]; do
  stay_eats
  move_player
  echo "$var_position_x $var_position_y" >> positions
  is_eaten
  build_snake
  clear
  show_place
  done

  }

  game

