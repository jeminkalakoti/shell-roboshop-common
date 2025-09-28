#!/bin/bash

source ./common.sh
app_name=redis # Define the application name
check_root

dnf module disable redis -y &>>$LOG_FILE # Disable the default redis module
VALIDATE $? "Disabling redis module" # Validate the last command

dnf module enable redis:7 -y &>>$LOG_FILE # Enable the redis 7 module
VALIDATE $? "Enabling redis 7 module" # Validate the last command

dnf install redis -y &>>$LOG_FILE # Install redis
VALIDATE $? "Installing redis 7"    # Validate the last command

# Update the redis configuration to allow remote connections
sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Updating redis Configuration by allowing remote connections"    # Validate the last command

systemctl enable redis &>>$LOG_FILE # Enable redis service
VALIDATE $? "Enabling redis"    # Validate the last command

systemctl start redis &>>$LOG_FILE # Start redis service
VALIDATE $? "Starting redis"    # Validate the last command 

print_total_time