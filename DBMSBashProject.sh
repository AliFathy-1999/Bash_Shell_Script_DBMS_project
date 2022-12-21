#!/bin/bash 

clear

echo "|--------------------------------------------------|"
echo "|              Hello  to our DBMS project          |"
echo "|--------------------------------------------------|"

RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0m'
YELLOW='\033[1;32m'
BLUE='\033[0;34m'
function MainMenu {
    echo -e "\n |-------------------Main Menu-------------------------| \n "
select option in "Create Database" "Connect to Database " "List Databases " "Drop Database" "Exit" 
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
    echo -e "\n Enter your database name : \c"
    read dbname 
    if [[ $dbname = "" ]]; then
        echo -e "${RED}You entered empty value ${NOCOLOR}\n"
    elif [[ $dbname == *['!'@#\$%^\&*()_+/.#+=-{}[]:?]* ]];
    then
        echo -e "${RED} You can't enter these characters => . / : * $ @ ^ % ( ) ! + _ # & - | ${NOCOLOR}\n"
    elif [[ $dbname =~ ^[0-9] ]];
    then
		echo -e "\n  ${RED}You can't start Database name with number ${NOCOLOR}\n"
    elif [ -d $dbname ] 
    then
        echo -e "\n ${RED} Database already exists ${NOCOLOR}\n"
    else 
        mkdir ./$dbname
        echo -e "\n ${GREEN} $dbname Created Successfully ${NOCOLOR}\n" 
    fi
    MainMenu
}

function ListDatabases {
     ls -F | grep /
        echo -e "\n ${GREEN} Listed Successfully ${NOCOLOR}\n" 
    MainMenu
}

function ConnectToDatabase {
    echo -e "\n Enter your database name : \c"
    read dbname 
    if [ -d $dbname ] && [[ $dbname != "" ]]
    then
        cd ./$dbname
        echo -e "\n ${GREEN}Connected Successfully to $dbname  ${NOCOLOR}\n"
        TableMenu
    else
        echo -e "\n ${RED}Connecting Failed, please enter valid database name  ${NOCOLOR}\n"
        ConnectToDatabase
    fi
} 

function DropDatabases {
    echo -e "\n Enter database name you want to drop : \c"
    read dbname
    if [ -d $dbname ]
    then 
        rm -r ./$dbname
        echo -e "${GREEN}Database Droped Successfully ${NOCOLOR}\n"
    else
      echo -e "${RED} There is no database named ($dbname) ${NOCOLOR}\n "
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
    echo -e "\n Enter your table name : \c"
    read tablename 
   
    if [[ $tablename == *['!'@#\$%^\&*()_+]* ]];
    then
        echo -e "\n ${RED}You can't enter these characters => . / : * $ @ ^ % ( ) ! + _ # & - | ${NOCOLOR}\n"
        CreateTable
    elif [[ $tablename =~ ^[0-9] ]];
    then
		echo -e "\n ${RED}You can't start Table name with number ${NOCOLOR} \n"
        CreateTable
    elif [[ $tablename == "" ]]; then
        echo -e "\n ${RED}You can't enter empty value ${NOCOLOR} \n"
        CreateTable
    elif [ -f ./$tablename/$tablename ] 
    then
        echo -e "\n ${RED}Table already exists${NOCOLOR}"
        TableMenu
    fi
        echo -e "Enter Number of Fields (Column) : \n" 
        read colno 
        if [[ $colno != *[0-9]* ]]; then
            echo -e "${RED}\n Number of Fields (Column) must be Integar \n ${NOCOLOR}"
            CreateTable
        fi
        separator=":"
        metaDataFormate="Field Name|Field Type|Primary key"
        typeset -i i=1
        primarykey=""
        data=""
        fname=""
        space="\n"
        while [ $i -le $colno ]
        do
            echo -e "\n Enter name of Field (Column $i) : \n"
            read Fieldname
            if [[ $Fieldname == *['!'@#\$%^\&*()_+]* ]];
             then
                echo -e "\n ${RED}You can't enter these characters in field name => . / : * $ @ ^ % ( ) ! + _ # & - | ${NOCOLOR}\n"
                continue
            elif [[ $Fieldname == "" ]]; then
                echo -e "\n ${RED}You can't enter empty value ${NOCOLOR} \n"
                continue
            elif [[ $Fieldname =~ ^[0-9] ]];
                then
                    echo -e "\n ${RED}You can't start Field name with number ${NOCOLOR}\n"
                    continue
            else            
            echo -e "Enter Type of $Fieldname (Column $i) : \n"
            select var in "int" "str"
            do
            case $var in
                int ) FieldType="int"; break;;
                str ) FieldType="str"; break;;
                * ) echo -e "${RED} Wrong Choice ${NOCOLOR}" ;;
            esac
            done
            if [[ $primarykey == "" ]]; then
                echo -e "\n Make This Field PrimaryKey ??? "
                select var in "yes" "no"
                do
                    case $var in
                    yes ) primarykey="PK";
                        data+=$Fieldname$separator$FieldType$separator$primarykey;
                    break;;
                    no )
                        data+=$Fieldname$separator$FieldType$separator""$space;
                    break;;
                    * ) echo -e "${RED} Wrong Choice ${NOCOLOR}" ;;
                    esac
                done
            else
                data+=$space$Fieldname$separator$FieldType$separator"";
            fi
            ((i++))
            fi
            fname+=$Fieldname"|"
        done
                mkdir -p $tablename
                touch ./$tablename/$tablename
                touch ./$tablename/$tablename-metadata 
                echo  "No of columns:$colno" >> ./$tablename/$tablename-metadata
                echo $metaDataFormate >> ./$tablename/$tablename-metadata
                echo -e $data >> ./$tablename/$tablename-metadata;
                echo -e "${GREEN}$tablename created successfully ${NOCOLOR}\n"
                echo $fname  >> ./$tablename/$tablename
               
        
    TableMenu
}
 function ListTables {
	ls -F | grep /
	echo -e "${GREEN}\n Tables listed Successfully ${NOCOLOR}\n" 
    TableMenu
 }
 function DropTable {
	echo -e "\n Enter the table name you want to drop : \c" 
	read DropT
	if [ -d $DropT ] && [[ $DropT != "" ]]
    then 
            rm -r $DropT
            echo -e "\n ${GREEN}The Table $DropT Droped Successfully ${NOCOLOR} \n"
    else
      echo -e "${RED}\n You entered invalid Table Name  ${NOCOLOR} \n "
      DropTable
    fi
    TableMenu
 }
function InsertintoTable {
        echo -e "Enter the table name you want to insert into : \n"
        read tablename
        if ! [ -d ./$tablename ];then
            echo -e "\n ${RED}The Table $tablename doesn't exists .${NOCOLOR} \n"
            InsertintoTable
        elif [[ $tablename == "" ]]; then
            echo -e "${RED} You can't enter empty value .${NOCOLOR} \n"
            InsertintoTable 
        else
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
                echo -e "\n Enter value of $Fieldname of type $FieldType : \c"
                read data
                if [[ $data == "" ]];then
                        echo -e "${RED} You entered empty value ${NOCOLOR}\n"
                        InsertintoTable    
                else
                    if [[ $FieldType == "int" ]] ; then
                        while ! [[ $data == *[0-9]* ]]; do
                                echo -e "${RED} $data isn't integar ${NOCOLOR}"
                                echo -e "Enter value of $Fieldname of type $FieldType : \c"
                                read data
                        done
                    fi
                        FieldColNum=`cut -d: -f3 ./$tablename/$tablename-metadata | grep -n -w "^PK$" | cut -d: -f1` 
                        Key=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $3}' ./$tablename/$tablename-metadata)
                        if [[ $Key == 'PK' ]]; then
                            while [ true ]; do
                            countPk=`cut -d '|' -f"$FieldColNum" ./$tablename/$tablename | grep -c -w "$data"`  
                                if [[ $countPk != 0 ]]; then
                                    echo -e "\t ${RED} $data is already used (Duplicated primary key)! ${NOCOLOR} \n"
                                    echo -e "Enter value of $Fieldname of type $FieldType : \c"
                                    read data
                                else
                                    break
                                fi
                            done
                        fi                      
                fi
                alldata+=$data$separator
            done
        fi
            if [[ $data == "" ]]; then
                echo -e "\n ${RED} Error in Inserting data ${NOCOLOR} \n "
                InsertintoTable
            else
                echo $alldata >>./$tablename/$tablename
                echo -e "${GREEN} \n Data inserted Successfully :) ${NOCOLOR}"
            fi
            TableMenu
}
function DeleteFromTable {
        echo -e "\n Enter the table name : \c"
            read TableName
        if ! [[ -d $TableName ]];then
            echo "${RED} Table is not Exist!!! ${NOCOLOR}"
            DeleteFromTable
        fi
        if [[ $TableName == "" ]];then
            echo "${RED} You can't enter empty value ${NOCOLOR}"
            DeleteFromTable
        fi        
            echo -e "\n Enter Column name : \c"
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
        echo -e "\n Enter Table name : \c"
        read tableName
        if [[ $tableName != "" ]] && [[ -d $tableName ]]; then
            echo -e "\n"
            column -t -s '|' ./$tableName/$tableName 2>> /dev/null |  head -1
            echo -e "*----------------------------------------------*\n"
            column -t -s ':' ./$tableName/$tableName 2>> /dev/null | tail -n +2
            echo -e "\n"
            echo -e "*----------------------------------------------*\n"
        else
            echo -e "\n ${RED} You entered invalid value ${NOCOLOR} \n "
            SelectAll
        fi
         SelectMenu
    }

    function SelectByCondition {
        echo -e "Enter the table name : \c"
	    read TableName
        if [[ $TableName != "" ]] && [[ -d $TableName ]]; then
            echo -e "\n  Please, Enter Column name : \c"
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
            if [[ $colName == "" ]];then
                echo -e "\n ${RED} You entered empty value ${NOCOLOR} \n "
                SelectByCondition 
            else
                if [[ $field == "" ]];then
                    echo -e "\n ${RED} Column is not exist!!! ${NOCOLOR} \n "
                    SelectByCondition
                else
                    echo -e "\n Enter the value : \c \n"	
                    read value

                result=$(awk 'BEGIN{FS=":"} { if ( $'$field' == "'$value'") print $'$field' }' ./$TableName/$TableName)
                if [[ $result == "" ]]
                    then
                        echo -e "\n ${RED} The Value is not Exist!!! ${NOCOLOR} \n "
                        SelectByCondition
                else
                echo -e "\n" 
                    NR=$(awk 'BEGIN{FS=":"}{ if ($'$field'=="'$value'") print NR }' ./$TableName/$TableName)
                    sed -n ''$NR'p' ./$TableName/$TableName
                    echo -e "\n ${GREEN}Row selected Successfully ${NOCOLOR} \n "
                    SelectMenu
                    fi
                fi	
                fi
            else
                    echo -e "\n ${RED} You entered invalid tablename ${NOCOLOR} \n"
                    SelectByCondition 
            fi
        
        SelectMenu
    }


function SelectByColName {
	echo "Enter Table Name :"
	read tableName
	echo "Enter Column Name :"
	read colName
    if [[ $colName = "" ]]
    then
    echo "You Can't Enter Empty Space!"
    else
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
            }' ./$tableName/$tableName)
    awk 'BEGIN{FS=":"; ORS = " \n "}{print  $'$colName'}' ./$tableName/$tableName | tail -n +2

    fi	
        SelectMenu
    }


function UpdateTable {
	
        echo  -e "\n Enter Table Name: \c "
        read tableName
        if [ -d $tableName ]
            then 
            echo -e "\n\n ${GREEN}Table accessed successfully :) ${NOCOLOR} \n\n"
        else
            echo -e "\n \t ${RED} There is no Table named ($tableName)  ${NOCOLOR} \n"
            UpdateTable
        fi
        echo -e "Enter Column name: \c"
        read field
        if  [[ $field = "" ]];then
            echo -e "\n ${RED} You entered empty value ${NOCOLOR} \n"
            UpdateTable
        else
            checkfid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' ./$tableName/$tableName)
            if [[ $checkfid == "" ]]
            then
                echo -e "\n \t ${RED} You entered invalid data ${NOCOLOR} \n"
                UpdateTable
            else
                echo -e "\n Enter The Condition Value: \c"
                read value
                result=$(awk 'BEGIN{FS=":"}{if ($'$checkfid'=="'$value'") print $'$checkfid'}' ./$tableName/$tableName 2>>./.error.log)
                if [[ $result == "" ]] && [[ $value == "" ]]
                then
                    echo -e "\n \t ${RED} You entered invalid data ${NOCOLOR} \n"
                    UpdateTable
                else
                    echo  -e "\n Enter Column name to set into : \c"
                    read setField
                    Fieldname=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$setField'") print i}}}' ./$tableName/$tableName)
                if [[ $Fieldname == "" ]] 
                then
                    echo -e "\n \t ${RED} You entered invalid data ${NOCOLOR} \n"
                    UpdateTable
                elif [[ $setField == "" ]];then
                    echo -e "\n \t ${RED} You entered empty value ${NOCOLOR} \n"
                    UpdateTable
                else
                echo -e "\n Enter new Value to set: \c"
                read newValue
                FieldColNum=`awk 'END{print NR}' ./$tableName/$tableName-metadata`
                            for (( i = 2; i <= $FieldColNum; i++ )); do
                                ColNum=`cut -d: -f3 ./$tableName/$tableName-metadata | grep -n -w "^PK$" | cut -d: -f1` 
                                Key=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $3}' ./$tableName/$tableName-metadata)
                                if [[ $Key == 'PK' ]]; then
                                    while [ true ]; do
                                    countPk=`cut -d '|' -f"$ColNum" ./$tableName/$tableName | grep -c -w "$newValue"`  

                                    if [[ $countPk != 0 ]]; then
                                        echo -e "\n \t ${RED} Duplcated PK ${NOCOLOR} \n"
                                        UpdateTable
                                    else
                                        break;
                                    fi

                                    done
                                fi
                            done
                        NR=$(awk 'BEGIN{FS=":"}{if ($'$checkfid' == "'$value'") print NR}' ./$tableName/$tableName 2>>./.error.log)
                        oldValue=$(awk 'BEGIN{FS=":"}{if(NR=='$NR'){for(i=1;i<=NF;i++){if(i=='$Fieldname') print $i}}}' ./$tableName/$tableName 2>>./.error.log)
                        echo $oldValue
                        sed -i ''$NR's/'$oldValue'/'$newValue'/g' ./$tableName/$tableName 2>>./.error.log
                        echo -e "${GREEN}Row Updated Successfully ${NOCOLOR} \n"
                        TableMenu
                    fi
                    fi
                fi
        fi
}

MainMenu


