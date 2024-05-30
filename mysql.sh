USERID=$(id -u)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "Please enter db password"
read -s mysql_root_password
#
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

if [ $USERID -ne 0 ]
then 
    echo "Please run with super user"
    exit 1
else 
    echo "You are a super user"
fi



dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabling MySQL Server"

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Starting MySQL Server"

#mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE
#VALIDATE $? "Setting up the root password"


#Below code will be useful for idemponent nature
#mysql -h db.swamy.online -uroot -p${mysql_root_password} -e 'show databases;'
#mysql -h db.swamy.online -uroot -pExpenseApp@1  -e 'show databases;'
mysql --host=23.22.163.148 --user=root --password=${mysql_root_password} -e 'SHOW DATABASES;' &>> $LOG_FILE
if [ $? -ne 0 ]
then
   mysql_secure_installation --set-root-pass ${mysql_root_password} &>> $LOG_FILE
   VALIDATE $? "Setting up the root password"
else 
    echo -e "MySQL root password is already setup.. $Y SKIPPING  $N"
fi  
#
#
#



