#!/bin/bash

USERID=$(id -u)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


#

VALIDATE(){
    if [ $1 -ne 0 ]
    then
       echo -e "$2...$R  FAILURE $N"
       exit 1
    else 
       echo -e "$2... $G  SUCCESS $N"
    fi
}

check_root(){

    if [ $USERID -ne 0 ]
    then 
       echo "Please run with super user"
       exit 1
    else 
       echo "You are a super user"
    fi
}

