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
    if [[ $dbname = "" ]]; then
        echo -e "You entered empty value \n"
    elif [[ $dbname == *['!'@#\$%^\&*()_+]* ]];
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
        CreateTable
    elif [[ $tablename =~ ^[0-9] ]];
    then
		echo -e "You can't start Table name with number \n"
        CreateTable
     elif [ -f .1/$tablename/$tablename ] 
    then
        echo Table already exists
        TableMenu
    fi
        mkdir -p $tablename
        touch ./$tablename/$tablename
        touch ./$tablename/$tablename-metadata
        echo -e "$tablename Created Successfully \n" 
        echo -e "Enter Number of Fields (Column) : \n" 
        read colno 
        echo  "No of columns:$colno" >> ./$tablename/$tablename-metadata
        separator=":"
        metaDataFormate="Field Name|Field Type|Primary key"
        echo $metaDataFormate >> ./$tablename/$tablename-metadata
        typeset -i i=1
        primarykey=""
        data=""
        fname=""
        space="\n"
        while [ $i -le $colno ]
        do
            echo -e " Enter name of Field (Column $i) : \n"
            read Fieldname
            if [[ $Fieldname == *['!'@#\$%^\&*()_+]* ]];
             then
                echo -e "You can't enter these characters in field name => . / : * $ @ ^ % ( ) ! + _ # & - | \n"
                continue
            elif [[ $Fieldname =~ ^[0-9] ]];
                then
                    echo -e "You can't start Field name with number \n"
                    continue
            else            
            echo -e "Enter Type of $Fieldname (Column $i) : \n"
            select var in "int" "str"
            do
            case $var in
                int ) FieldType="int"; break;;
                str ) FieldType="str"; break;;
                * ) echo "Wrong Choice" ;;
            esac
            done
            if [[ $primarykey == "" ]]; then
                echo -e "Make This Field PrimaryKey ??? "
                select var in "yes" "no"
                do
                    case $var in
                    yes ) primarykey="PK";
                    data+=$Fieldname$separator$FieldType$separator$primarykey;
                    break;;
                    no )
                    data+=$space$Fieldname$separator$FieldType$separator""$space;
                    break;;
                    * ) echo "Wrong Choice" ;;
                    esac
                done
            else
                data+=$space$Fieldname$separator$FieldType$separator"";
            fi
            ((i++))
            fi
            fname+=$Fieldname"|"
            
        done
                echo -e $data >> ./$tablename/$tablename-metadata;
                echo -e "Table created successfully \n"
                echo $fname  >> ./$tablename/$tablename
               
        
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
function InsertintoTable {
        echo -e "Enter the table name you want to insert into \n"
        read tablename
        NoOfColumns=`awk 'END{print NR}' ./$tablename/$tablename-metadata ` 
        separator=":"
        typeset -i i
        data=""
        alldata=""
        fname=""
        for (( i=3; i <= $NoOfColumns ; i++ )); do
            Fieldname=`awk 'BEGIN{FS=":"}{ if(NR=='$i') print $1}' ./$tablename/$tablename-metadata`
            FieldType=`awk 'BEGIN{FS=":"}{if(NR=='$i') print $2}' ./$tablename/$tablename-metadata`
            PKorNOT=`awk 'BEGIN{FS=":"}{if(NR=='$i') print $3}' ./$tablename/$tablename-metadata`
            fname+=Fieldname"|"
            echo -e "Enter value of $Fieldname of type $FieldType : "
            read data
            if [[ $data == "" ]]
            then
                echo -e "You entered empty value \n"
                echo -e "Enter value of $Fieldname of type $FieldType : "
                    read data
            elif [[ $FieldType == "int" ]]; then
                 if [[ $data != *[0-9]* ]]; then
                    echo -e "$data isn't integar"
                    echo -e "Enter value of $Fieldname of type $FieldType : "
                    read data
                fi
            fi
            usedPk=$(cut -d ':' -f1 "./$tablename/$tablename" | awk '{if(NR != 1) print $0}' | grep -x -e "$data")
            if ! [[ $usedPk == '' ]]; then
				echo -e "This primary key is already used !"
                echo -e "Enter value of $Fieldname of type $FieldType : "
                read data
            fi
                alldata+=$data$separator
        done
            echo $alldata >>./$tablename/$tablename
            echo -e "Data inserted Successfully :)"
            TableMenu
}
# function SelectFromTable {

# }
# function DeleteFromTable {

# }
# function UpdateTable {

# }


MainMenu


