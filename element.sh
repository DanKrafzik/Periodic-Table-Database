#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

ELEMENT=$1

if [[ $ELEMENT =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ELEMENT")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ELEMENT")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ELEMENT")
  
  if [[ -z $ATOMIC_NUMBER || -z $NAME || -z $SYMBOL ]]
  then
    echo "I could not find that element in the database."
    exit 0
  fi

  TYPE=$($PSQL "SELECT type FROM types FULL JOIN properties ON types.type_id = properties.type_id FULL JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.atomic_number = $ELEMENT")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ELEMENT")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ELEMENT")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ELEMENT")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
else
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$ELEMENT' OR symbol = '$ELEMENT'")
  NAME=$($PSQL "SELECT name FROM elements WHERE name = '$ELEMENT' OR symbol = '$ELEMENT'")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$ELEMENT' OR symbol = '$ELEMENT'")
  
  if [[ -z $ATOMIC_NUMBER || -z $NAME || -z $SYMBOL ]]
  then
    echo "I could not find that element in the database."
    exit 0
  fi

  TYPE=$($PSQL "SELECT type FROM types FULL JOIN properties ON types.type_id = properties.type_id FULL JOIN elements ON properties.atomic_number = elements.atomic_number WHERE name = '$ELEMENT' OR symbol = '$ELEMENT'")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties FULL JOIN elements ON properties.atomic_number = elements.atomic_number WHERE name = '$ELEMENT' OR symbol = '$ELEMENT'")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties FULL JOIN elements ON properties.atomic_number = elements.atomic_number WHERE name = '$ELEMENT' OR symbol = '$ELEMENT'")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties FULL JOIN elements ON properties.atomic_number = elements.atomic_number WHERE name = '$ELEMENT' OR symbol = '$ELEMENT'")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
