#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


# 
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINGOALS OPPGOALS
do
    if [[ $OPPONENT != "opponent" ]]
    then 
        TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  
        if [[ -z $TEAM_ID ]]
        then
        INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) VALUES('$OPPONENT')")
            if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
            then
                echo insert team, $OPPONENT
            fi
        fi
    fi
    if [[ $WINNER != "winner" ]]
    then
        TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  
        if [[ -z $TEAM_ID ]]
        then
        INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) VALUES('$WINNER')")
            if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
            then
                echo insert team, $WINNER
            fi
        fi
    fi

done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINGOALS OPPGOALS
do
    if [[ $YEAR != "year" ]]
    then
        WINNER_ID=$($PSQL "SELECT team_id from teams WHERE name = '$WINNER'")
        OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name = '$OPPONENT'")
        INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) Values($YEAR, '$ROUND',$WINNER_ID,$OPPONENT_ID,$WINGOALS,$OPPGOALS)")
        if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
        then
            echo "insert game, $WINNER X $OPPONENT in $ROUND" 
        fi
    fi
done