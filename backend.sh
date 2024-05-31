#!/bin/bash

source ./common.sh

check_root   

echo "Please enter db password"
read -s mysql_root_password

dnf module disable nodejs -y &>> $LOG_FILE
VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y &>> $LOG_FILE
VALIDATE $? "Enabling node js 20 version"

dnf install nodejs -y &>> $LOG_FILE
VALIDATE $? "Installing node js"


id expense &>> $LOG_FILE
if [ $? -ne 0 ]
then
    useradd expense  &>> $LOG_FILE
    VALIDATE $? "Adding expense user"
else 
    echo -e "expense user already exists $Y SKIPPING $N"   
fi


mkdir -p /app &>> $LOG_FILE 
VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>> $LOG_FILE
VALIDATE $? "Downloading the code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>> $LOG_FILE
VALIDATE $? "Extracted backend code"

npm install &>> $LOG_FILE
VALIDATE $? "installing nodejs dependecies"


cp /home/ec2-user/expense-shell1/backend.service /etc/systemd/system/backend.service &>> $LOG_FILE
VALIDATE $? "Copying the backend service"

systemctl daemon-reload &>> $LOG_FILE
VALIDATE $? "Reloading the daemon"

systemctl start backend &>> $LOG_FILE
VALIDATE $? "Stating the backend service"

systemctl enable backend &>> $LOG_FILE
VALIDATE $? "Enabling the backend service"

dnf install mysql -y &>> $LOG_FILE
VALIDATE $? "installing mysql"


#mysql -h 172.31.27.17 -uroot -pExpenseApp@1 < /app/schema/backend.sql
mysql --host=54.82.112.45 --user=root --password=${mysql_root_password} < /app/schema/backend.sql &>> $LOG_FILE
VALIDATE $? "Schema loading"

systemctl restart backend &>> $LOG_FILE
VALIDATE $? "restarting backend" 

###