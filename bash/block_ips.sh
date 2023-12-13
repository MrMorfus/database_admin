  GNU nano 4.8                                                                                        block_ips.sh
#!/bin/bash

# Check if a file path is provided as an argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <data_file_path>"
  exit 1
fi

data_file="$1"

# Check if the file exists
if [ ! -f "$data_file" ]; then
  echo "Error: File not found - $data_file"
  exit 1
fi

# Declare an associative array to track processed IPs
declare -A processed_ips

# Loop through each line in the data file
while IFS= read -r line; do
  # Extract the IP address from each line
  ip_address=$(echo "$line" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

  # If an IP address is found and not processed, add the corresponding iptables command
  if [ -n "$ip_address" ] && [ -z "${processed_ips[$ip_address]}" ]; then
    iptables -A INPUT -s "$ip_address" -j DROP
    processed_ips["$ip_address"]=1
    echo "Blocked unique IP address: $ip_address"
  fi

done < "$data_file"

netfilter-persistent save
netfilter-persistent restart
