#!/bin/bash

# Path to the password file
PASSWORD_FILE="auth"

rm $PASSWORD_FILE
touch $PASSWORD_FILE

# Read the usernames and passwords from the input file
while IFS=: read -r username password; do
    # Add each user to the password file
    htpasswd -B -b "$PASSWORD_FILE" "$username" "$password"
    echo $username
done < "./users.txt"