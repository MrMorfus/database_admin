#!/bin/bash

# Get the current date and time in the format YYYY-MM-DD_HH-MM-SS
current_datetime=$(date +"%Y-%m-%d_%H-%M-%S")

# Define the log file name with the current date and time
log_file="clients_list_${current_datetime}.txt"

# Run the Docker logs command and save the results to the log file
docker logs --since=12h CONTAINER_NAME 2>&1 | grep "CLIENT: " > "$log_file"

echo "Results saved to: $log_file"#!/bin/bash

# Get the current date and time in the format YYYY-MM-DD_HH-MM-SS
current_datetime=$(date +"%Y-%m-%d_%H-%M-%S")

# Define the log file name with the current date and time
log_file="clients_list_${current_datetime}.txt"

# Run the Docker logs command and save the results to the log file
docker logs --since=12h CONTAINER_NAME 2>&1 | grep "CLIENT: " > "$log_file"

echo "Results saved to: $log_file"
