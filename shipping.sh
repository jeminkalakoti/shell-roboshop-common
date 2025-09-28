#!/bin/bash

source ./common.sh # Source the common.sh file to use its functions
app_name=user # Define the application name

check_root
app_setup  # Call the app setup function from common.sh
java_setup_setup # Call the NodeJS setup function from common.sh
systemd_setup # Call the systemd setup function from common.sh

dnf install mysql -y &>>$LOG_FILE # Install MySQL Client
VALIDATE $? "Installing MySQL Client"    # Validate the last command

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities' &>>$LOG_FILE # Check if the DB already exists
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE # Load the schema
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE # Load the schema
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE # Load the schema
    exit 1 # Exit the script if MySQL connection failed
else
    echo -e "Shipping data is already loaded ... $G SUCCESSFUL $N"
fi

app_restart # Call the app restart function from common.sh
print_total_time # Call the print total time function from common.sh