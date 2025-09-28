#!/bin/bash

source ./common.sh

check_root

dnf install mysql-server -y &>>$LOG_FILE # Install MySQL
VALIDATE $? "Installing MySQL"    # Validate the last command

systemctl enable mysqld &>>$LOG_FILE # Enable MySQL service
VALIDATE $? "Enabling MySQLd"    # Validate the last command

systemctl start mysqld  &>>$LOG_FILE # Start MySQL service
VALIDATE $? "Starting MySQLd"    # Validate the last command

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE # Set the root password
VALIDATE $? "Setting MySQL Root Password"    # Validate the last command

print_total_time
