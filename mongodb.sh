#!/bin/bash

source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo # Copy the repo file
VALIDATE $? "Adding MongoDB Repo" # Validate the last command

dnf install mongodb-org -y &>>LOG_FILE # Install MongoDB
VALIDATE $? "Installing MongoDB"    # Validate the last command

systemctl enable mongod &>>$LOG_FILE # Enable MongoDB service
VALIDATE $? "Enabling MongoDB"    # Validate the last command

systemctl start mongod &>>$LOG_FILE # Start MongoDB service
VALIDATE $? "Starting MongoDB"    # Validate the last command

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing remote connections to MongoDB"

systemctl restart mongod
VALIDATE $? "Restarted MongoDB"

print_total_time
