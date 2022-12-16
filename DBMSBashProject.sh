#!/bin/bash

clear

echo "|--------------------------------------------------|"
echo "|              Hello  to our DBMS project          |"
echo "|--------------------------------------------------|"


function MainMenu {
    echo -e "\n |-------------------Main Menu-------------------------| \n "
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
   
    if [ CheckDataType ]
    then
        CheckDataType
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
        echo -e "Listed Successfully \n" 
    MainMenu
}

function ConnectToDatabase {
    echo Enter your database name
    read dbname
    if [ -d $dbname ]
    then
        cd ./$dbname
        echo -e "Connected Successfully to $dbname  \n"
        TableMenu
    else
        echo -e "Connected Failed, There is no database named ($dbname) \n"
    fi
} 

function DropDatabases {
    echo "Enter database name you want to drop :"
    read dbname
    if [ -d $dbname ]
    then 
        rm -r ./$dbname
        echo -e "Database Droped Successfully \n"
    else
      echo -e "There is no database named ($dbname) \n "
    fi
    MainMenu
}

function CheckDataType {
if [[ $dbname =~ [/.:*\|\-$]* ]]; 
then
		echo -e "You can't enter these characters => . / : * $ & - | \n"
	
	elif [[ $dbname =~ ^[0-9] ]];
 then
		echo -e "You can't start Database name with number \n"
fi
} 

function CheckTableName {
if [[ $tablename =~ [/.:*\|\-$]* ]]; 
then
		echo -e "You can't enter these characters => . / : * $ & - | \n"
	
	elif [[ $tablename =~ ^[0-9] ]];
 then
    #12233tablename =====> You can't enter these characters => . / : * $ & - | \n NOT You can't start Table name with number 
		echo -e "You can't start Table name with number \n"
fi
} 
function TableMenu {
    echo -e "\n |-------------------Table Menu-------------------------| \n"
select option in "1. Create Table" "2. List Table" "3. Drop Table " "4. Insert into Table" "5. Select from Table" "6. Delete From Table" "7. Update Table" "8. Back to Main Menu" "9. Exit" 
do
    case $REPLY in
    1) CreateTable ;;
    2) ListTables ;;
    3) DropTable ;;
    4) InsertintoTable ;;
    5) SelectFromTable ;;
    6) DeleteFromTable ;;
    7) UpdateTable ;;
    8) MainMenu ;;
    9) exit ;;
    *) echo $REPLY is not one of the choices ;;
esac
done 
}

function CreateTable {
    echo Enter your table name
    read tablename 
   
    # if [ CheckTableName ]
    # then
    #     CheckTableName

    # el
    if [ -f ./$tablename/$tablename ] 
    then
        echo Table already exists
    fi
        mkdir -p $tablename
        touch ./$tablename/$tablename
        touch ./$tablename/$tablename-metadata
        echo -e "$tablename Created Successfully \n" 
         echo -e "Enter Number of Fields (Column) : \n" 
        # read colno >> ./$tablename/$tablename-metadata
        read colno 
        echo $colno > ./$tablename/$tablename-metadata
    
    TableMenu
}
 function ListTables {
	ls -F | grep /
	 echo -e "\nTables listed Successfully \n" 
    TableMenu

 }
 function DropTable {
	echo Enter the table name you want to drop 
	read DropT
	if [ -d $DropT ]
    then 
        rm -r $DropT
	
        echo -e "The Table $DropT Droped Successfully \n"
    else
      echo -e "Wrong Table Name ($DropT) \n "
    fi
    TableMenu

 }
# function InsertintoTable {

# }
# function SelectFromTable {

# }
# function DeleteFromTable {

# }
# function UpdateTable {

# }


MainMenu


