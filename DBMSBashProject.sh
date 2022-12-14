#!/bin/bash

clear

echo "|--------------------------------------------------|"
echo "|              Hello  to our DBMS project          |"
echo "|--------------------------------------------------|"


function MainMenu {
select option in "1. Create Database" "2. Connect to Database " "3. List Databases " "4. Drop Database" "5. Exit" 
do
    case $REPLY in
    1) CreateDatabases ;;
    2) ConnectToDatabase ;;
    3) ListDatabases ;;
    4) DropDatabases ;;
    5) exit ;;
    *) echo $REPLY is not one of the choices ;;
esac
done 
}
function CreateDatabases {
    echo Enter your database name
    read dbname 
    # check special characters and spaces and number before database name  ***************************************************
   
		
	if [[ $dbname =~ [/.:*\|\-] ]]; then
		echo -e "You can't enter these characters => . / : * $ & - | \n"
	
	elif [[ $dbname =~ ^[0-9] ]]; then
		echo -e "You can't start DB name with number \n"
    elif [ -d $dbname ] 
    then
        echo Database already exists
    else 
        mkdir ./$dbname
        echo -e "$dbname Created Successfully \n" 
    fi
    MainMenu
}
function ListDatabases {
     ls -F | grep /
     # check special characters and spaces and number before database name  ***************************************************
        echo -e "Listed Successfully \n" 
    MainMenu
}
function ConnectToDatabase {
    echo Enter your database name
    read dbname
    # check special characters and spaces and number before database name  ***************************************************
    if [ -d $dbname ]
    then
        cd ./$dbname
        echo -e "Connected Successfully to $dbname  \n"
    else
        echo -e "Connected Failed, There is no database named ($dbname) \n"
    fi
} 
function DropDatabases {
    echo "Enter database name you want to drop :"
    read dbname
    # check special characters and spaces and number before database name  ***************************************************
    if [ -d $dbname ]
    then 
        rm -r ./$dbname
        echo -e "Database Droped Successfully \n"
    else
      echo -e "There is no database named ($dbname) \n "
    fi
    MainMenu
}

##function CheckDataType {
##if [[ $dbname =~ [/.:*\|\-] ]]; 
##then
##		echo -e "You can't enter these characters => . / : * $ & - | \n"
	
##	elif [[ $dbname =~ ^[0-9] ]];
 ##then
##		echo -e "You can't start DB name with number \n"
##fi
##} 

MainMenu


