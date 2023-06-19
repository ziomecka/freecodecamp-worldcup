#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


$PSQL "TRUNCATE games, teams"

cat ./games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals; do
# echo $year $round $winner $opponent $winner_goals $opponent_goals

  # add winner to teams
  WINNER_TEAM=$($PSQL "SELECT name FROM teams WHERE name='$winner'")

  if [[ -z $winner || $winner == "winner" ]]; then
    echo Empty winner
  else
    if [[ -z $WINNER_TEAM ]]; then
      echo $winner

      WINNER_TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES ('$winner')")
      echo $WINNER_TEAM_INSERT

      if [[ "$WINNER_TEAM_INSERT" == "INSERT O 1" ]]; then
        echo "Inserted $winner"
      else
        echo "Not inserted $winner"
      fi

    fi
  fi

  # add opponent to teams
   WINNER_TEAM=$($PSQL "SELECT name FROM teams WHERE name='$opponent'")

  if [[ -z $opponent || $opponent == "opponent" ]]; then
    echo Empty opponent
  else
    if [[ -z $WINNER_TEAM ]]; then
      echo $opponent

      WINNER_TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES ('$opponent')")
      echo $WINNER_TEAM_INSERT

      if [[ "$WINNER_TEAM_INSERT" == "INSERT O 1" ]]; then
        echo "Inserted $opponent"
      else
        echo "Not inserted $opponent"
      fi

    fi
  fi


  # add game to games

  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
  echo "Winner id '$WINNER_ID'"

  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
  echo "Opponent id '$OPPONENT_ID'"

  if [[ -n WINNER_ID && -n OPPONENT_ID ]]; then
    GAME_INSERT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$year', '$round', '$WINNER_ID', '$OPPONENT_ID', '$winner_goals', '$opponent_goals')")

    echo $GAME_INSERT
  fi

done