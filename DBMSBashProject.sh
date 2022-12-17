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
    
    if [[ $dbname == *['!'@#\$%^\&*()_+]* ]];
    then
        echo -e "You can't enter these characters => . / : * $ @ ^ % ( ) ! + _ # & - | \n"
    elif [[ $dbname =~ ^[0-9] ]];
    then
		echo -e "You can't start Database name with number \n"
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
   
     if [[ $tablename == *['!'@#\$%^\&*()_+]* ]];
    then
        echo -e "You can't enter these characters => . / : * $ @ ^ % ( ) ! + _ # & - | \n"
    elif [[ $tablename =~ ^[0-9] ]];
    then
		echo -e "You can't start Table name with number \n"
     elif [ -f ./$tablename/$tablename ] 
    then
        echo Table already exists
    fi
        mkdir -p $tablename
        touch ./$tablename/$tablename
        touch ./$tablename/$tablename-metadata
        echo -e "$tablename Created Successfully \n" 
        separator="|"
        metaDataFormate="Field Name"$separator"Field Type"$separator"Primary key"
        echo $metaDataFormate >>./$tablename/$tablename-metadata
        echo -e "Enter Number of Fields (Column) : \n" 
        read colno 
        echo $colno > ./$tablename/$tablename-metadata
        array[$colno]
        typeset -i i=1

        while [ $i -le $colno ]
        do
        #\c
            echo -e " Enter name of Field (Column $i) : \n"
            read Fieldname
            #echo $Fieldname >>./$tablename/$tablename-metadata
            echo -e "Enter Type of $Fieldname (Column $i) : \n"
            # select type in "1. String" "2. Integar "  
            # do
            #     case $REPLY in
            #     1) Fieldtype="String"; echo $Fieldtype >>./$tablename/$tablename-metadata; break;;
            #     2) FieldType="Integar"; echo $Fieldtype >>./$tablename/$tablename-metadata; break;;
            #     *) echo $REPLY is not one of the choices ;;
            # esac
            # done 
            select var in "int" "str"
            do
            case $var in
                int ) array[$i]="int"; echo ${array[$i]} >>./$tablename/$tablename-metadata; break;;
                str ) array[$i]="str"; echo ${array[$i]} >>./$tablename/$tablename-metadata; break;;
                * ) echo "Wrong Choice" ;;
            esac
            done
            
            #read Fieldtype
            #echo $Fieldtype >>./$tablename/$tablename-metadata

            #i=$i+1
            ((i++))
        done
    
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


