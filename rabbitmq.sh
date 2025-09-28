#!/bin/bash

source ./common.sh

check_root

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE # Copy the repo file

dnf install rabbitmq-server -y &>>$LOG_FILE # Install RabbitMQ
VALIDATE $? "Installing RabbitMQ"    # Validate the last command

systemctl enable rabbitmq-server &>>$LOG_FILE # Enable RabbitMQ service
VALIDATE $? "Enabling RabbitMQ"    # Validate the last command

systemctl start rabbitmq-server &>>$LOG_FILE # Start RabbitMQ service
VALIDATE $? "Starting RabbitMQ"    # Validate the last command

rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE # Add application user
VALIDATE $? "Adding Application User to RabbitMQ"    # Validate the last command

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE # Set permissions to the application user
VALIDATE $? "Setting Permissions to Application User"    # Validate the last command

print_total_time
