#!/bin/bash

source ./common.sh

check_root

dnf install nginx -y &>> $LOG_FILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>> $LOG_FILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>> $LOG_FILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>> $LOG_FILE
VALIDATE $? "Removing the existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>> $LOG_FILE
VALIDATE $? "Downloading the frontend content"


cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>> $LOG_FILE
VALIDATE $? "Extracting the frontend code"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>> $LOG_FILE
VALIDATE $? "Copying the expense conf"

systemctl restart nginx &>> $LOG_FILE
VALIDATE $? "Restarting nginx server"

