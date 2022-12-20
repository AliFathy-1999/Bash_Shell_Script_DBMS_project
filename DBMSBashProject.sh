#!/bin/bash -x

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
select option in "Create Table" "List Table" "Drop Table " "Insert into Table" "Select from Table" "Delete From Table" "Update Table" "Back to Main Menu" "Exit" 
do
    case $REPLY in
    1) CreateTable ;;
    2) ListTables ;;
    3) DropTable ;;
    4) InsertintoTable ;;
    5) SelectMenu ;;
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
                        data+=$Fieldname$separator$FieldType$separator""$space;
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
        echo -e "Enter the table name you want to insert into : \n"
        read tablename
        if ! [ -d ./$tablename ];then
            echo -e "The Table $tablename doesn't exists . "
        else
            NoOfColumns=`awk 'END{print NR}' ./$tablename/$tablename-metadata ` 
            separator=":"
            typeset -i i
            data=""
            alldata=""
            fname=""
            for (( i=3; i <= $NoOfColumns ; i++ )); do
            # while [ $i -le $NoOfColumns ]; do
                Fieldname=`awk 'BEGIN{FS=":"}{ if(NR=='$i') print $1}' ./$tablename/$tablename-metadata`
                FieldType=`awk 'BEGIN{FS=":"}{if(NR=='$i') print $2}' ./$tablename/$tablename-metadata`
                PKorNOT=`awk 'BEGIN{FS=":"}{if(NR=='$i') print $3}' ./$tablename/$tablename-metadata`
                fname+=Fieldname"|"
                echo -e "Enter value of $Fieldname of type $FieldType : "
                read data
                if [[ $data == "" ]];then
                    echo -e "You entered empty value \n"
                else
                    if [[ $FieldType == "int" ]] ; then
                        while ! [[ $data = *[0-9]* ]]; do
                                echo -e "$data isn't integar"
                                echo -e "Enter value of $Fieldname of type $FieldType : "
                                read data
                        done
                    fi
                        FieldColNum=`cut -d: -f3 ./$tablename/$tablename-metadata | grep -n -w "^PK$" | cut -d: -f1` 
                        Key=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $3}' ./$tablename/$tablename-metadata)
                        if [[ $Key == 'PK' ]]; then
                            while [ true ]; do
                            countPk=`cut -d '|' -f"$FieldColNum" ./$tablename/$tablename | grep -c -w "$data"`  
                                if [[ $countPk != 0 ]]; then
                                    echo -e "\t $data is already used (Duplicated primary key)! \n"
                                    echo -e "Enter value of $Fieldname of type $FieldType : "
                                    read data
                                else
                                    break
                                fi
                            done
                        fi
                fi
                alldata+=$data$separator
            done
            echo $alldata >>./$tablename/$tablename
            echo -e "Data inserted Successfully :)"
        fi
            TableMenu
}
function DeleteFromTable {
   echo "Enter the table name :"
	read TableName
  if ! [[ -d $TableName ]];then
	echo "Table isn't Exist!!!"
	TableMenu
  fi

	echo "Enter Column name : "
	read colName

field=$(
awk '
BEGIN{FS="|"}
    {
        if(NR==1)
            {
                for(i=1;i<=NF;i++)
                {
                    if("'$colName'"==$i) print i
                }
            }
    }' ./$TableName/$TableName 2>> /dev/null)

   if [[ $field == "" ]];then
	echo "Column is not exist!!!"
	TableMenu
   else
	echo "Enter the value: "	
	read value

result=$(awk 'BEGIN{FS=":"} { if ( $'$field' == "'$value'") print $'$field' }' ./$TableName/$TableName)
if [[ $result == "" ]]
        then
        echo "The Value is not Exist!!! "
        TableMenu
    else
        NR=$(awk 'BEGIN{FS=":"}{ if ($'$field'=="'$value'") print NR }' ./$TableName/$TableName)

        sed -i ''$NR'd' ./$TableName/$TableName
        echo "Row Deleted Successfully"
        TableMenu
    fi
fi	
 }
    function SelectMenu {
    echo -e "\n |-------------------Select Menu-------------------------| \n"
        select option in "Select All (*)" "Select By Column Name" "Select By Condition " "Back to Main Menu" "Back to Table Menu" "Exit" 
            do
            case $REPLY in
            1) SelectAll ;;
            2) SelectByColName ;;
            3) SelectByCondition ;;
            4) MainMenu ;;
            5) TableMenu ;;
            6) exit ;;
            *) echo $REPLY is not one of the choices ;;
            esac
        done 
        echo -e "\n |-------------------------------------------------------| \n"
    }
    function SelectAll {
        typeset -i i
        data=""
        echo -e "\n Enter Table name : \n"
        read tableName
        echo -e "\n"
        column -t -s '|' ./$tableName/$tableName 2>> /dev/null |  head -1
        echo -e "*----------------------------------------------*\n"
        column -t -s ':' ./$tableName/$tableName 2>> /dev/null | tail -n +2
        echo -e "\n"
        echo -e "*----------------------------------------------*\n"
         SelectMenu
    }
    function SelectByColName {
        SelectMenu
    }
    function SelectByCondition {
        echo "Enter the table name :"
	    read TableName
            if ! [[ -d $TableName ]];then
	            echo "Table isn't Exist!!!"
	TableMenu
  fi

	echo "Enter Column name : "
	read colName

field=$(
awk '
BEGIN{FS="|"}
    {
        if(NR==1)
            {
                for(i=1;i<=NF;i++)
                {
                    if("'$colName'"==$i) print i
                }
            }
    }' ./$TableName/$TableName 2>> /dev/null)

   if [[ $field == "" ]];then
	echo "Column is not exist!!!"
	TableMenu
   else
	echo "Enter the value: "	
	read value

result=$(awk 'BEGIN{FS=":"} { if ( $'$field' == "'$value'") print $'$field' }' ./$TableName/$TableName)
if [[ $result == "" ]]
        then
        echo "The Value is not Exist!!! "
        TableMenu
    else
        NR=$(awk 'BEGIN{FS=":"}{ if ($'$field'=="'$value'") print NR }' ./$TableName/$TableName)

        sed -n ''$NR'p' ./$TableName/$TableName
        echo "Row selected Successfully"
        TableMenu
    fi
fi	
        SelectMenu
    }

# function UpdateTable {

# }


MainMenu


