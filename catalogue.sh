#!/bin/bash

source ./common.sh # Source the common.sh file to use its functions
app_name=catalogue # Define the application name

check_root 
app_setup  # Call the app setup function from common.sh
nodejs_setup # Call the NodeJS setup function from common.sh
systemd_setup # Call the systemd setup function from common.sh

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo # Copy the repo file
VALIDATE $? "Adding MongoDB Repo" # Validate the last command

dnf install mongodb-mongosh -y &>>$LOG_FILE # Install MongoDB Shell
VALIDATE $? "Installing MongoDB Shell"    # Validate the last command
INDEX=$(mongosh mongodb.kalakoti.fun --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE # Load the schema
    VALIDATE $? "Loading $app_name Products to MongoDB"    # Validate the last command
else
    echo -e "$app_name Products already exists. $Y SKIPPING $N" # Print skipping message in yellow color
fi  

app_restart # Call the app restart function from common.sh
print_total_time # Call the print total time function from common.sh