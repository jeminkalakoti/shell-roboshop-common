#!/bin/bash

USER_ID=$(id -u)
R='\e[0;31m' # Red
G='\e[0;32m' # Green
Y='\e[0;33m' # Yellow
N='\e[0m'    # No Color

LOGS_FOLDER="/var/log/shell-roboshop/"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 ) # Extract script name without extension
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # Define log file path
START_TIME=$(date +%s) # Get the script start time
SCRIPT_DIR=$PWD # Get the current working directory
MONGODB_HOST=mongodb.kalakoti.fun # MongoDB Host


# -e enables the interpretation of backslash escapes

mkdir -p $LOGS_FOLDER # Create logs folder if not exists
echo "Script started and executed at : $(date)" | tee -a $LOG_FILE # Log script start time

check_root(){
    if [ $USER_ID -ne 0 ]; then
        echo -e "$R ERROR $N:: You must have a root privilege to install packages" 
        exit 1 # Exit the script if not root
    fi
}

VALIDATE(){ # Functions receive arguments like normal scripts
    if [ $1 -ne 0 ]; then
        echo -e "Installing $2 ... $R FAILED $N" | tee -a $LOG_FILE
        exit 1 # Exit the script if installation failed with red color
    else
        echo -e "Installing $2 ... $G SUCCESSFUL $N" | tee -a $LOG_FILE # Print success message in green color
    fi 

}

nodejs_setup(){
    dnf module disable nodejs -y &>>$LOG_FILE # Disable the default nodejs module
    VALIDATE $? "Disabling NodeJS module" # Validate the last command

    dnf module enable nodejs:20 -y &>>$LOG_FILE # Enable the nodejs 20 module
    VALIDATE $? "Enabling NodeJS 20 module" # Validate the last command

    dnf install nodejs -y &>>$LOG_FILE # Install NodeJS
    VALIDATE $? "Installing NodeJS"    # Validate the last command

    npm install &>>$LOG_FILE # Download the application dependencies
    VALIDATE $? "Installing Application Dependencies"    # Validate the last command
}

app_setup(){
    mkdir -p /app #Create application directory if not exists 
    VALIDATE $? "Creating Application Directory"    # Validate the last command

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE # Download the application code
    VALIDATE $? "Downloading $app_name Application Code"    # Validate the last command

    cd /app 
    VALIDATE $? "Changing Directory to /app"    # Validate the last command

    rm -rf /app/* # Remove any existing application code
    VALIDATE $? "Removing the existing Application Code"    # Validate the last command

    unzip /tmp/$app_name.zip &>>$LOG_FILE # Unzip the application code
    VALIDATE $? "Unzipping $app_name Application Code"    # Validate the last command 
}

systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service # Copy the service file
    VALIDATE $? "Copying Service File"    # Validate the last command

    systemctl daemon-reload # Reload systemd to register the service
    VALIDATE $? "Reloading SystemD"    # Validate the last command

    systemctl enable $app_name &>>$LOG_FILE # Enable the service
    VALIDATE $? "Enabling $app_name Service"    # Validate the last command

    systemctl start $app_name # Start the service
    VALIDATE $? "Starting $app_name Service"    # Validate the last command

}

app_restart(){
    systemctl restart $app_name # Restart the service
    VALIDATE $? "Restarting $app_name Service"    # Validate the last command

}

print_total_time(){
    END_TIME=$(date +%s) # Get the script end time
    TOTAL_TIME=$((END_TIME - START_TIME)) # Calculate the total time taken
    echo -e "Total time taken to execute the script:$Y $TOTAL_TIME seconds $N" 
}   