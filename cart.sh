#!/bin/bash

source ./common.sh # Source the common.sh file to use its functions
app_name=cart # Define the application name

check_root
app_setup  # Call the app setup function from common.sh
nodejs_setup # Call the NodeJS setup function from common.sh
systemd_setup # Call the systemd setup function from common.sh

app_restart # Call the app restart function from common.sh
print_total_time # Call the print total time function from common.sh