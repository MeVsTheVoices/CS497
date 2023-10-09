#!/bin/bash

encrypt() {
    local message="$1"
    local offset="$2"
    local encrypted=""

    for ((i=0; i<${#message}; i++)); do
        char="${message:$i:1}"
        if [[ $char =~ [A-Za-z] ]]; then
            ascii_val=$(printf "%d" "'$char")
            if [[ $char =~ [A-Z] ]]; then
                ascii_val=$(((ascii_val - 65 + offset) % 26 + 65))
            else
                ascii_val=$(((ascii_val - 97 + offset) % 26 + 97))
            fi
            encrypted+="$(printf "\\$(printf '%03o' "$ascii_val")")"
        else
            encrypted+="$char"
        fi
    done

    echo "$encrypted"
}

# Read the message and offset from the user
read -p "Enter the message: " message
read -p "Enter the offset: " offset

# Encrypt the message using the custom offset
encrypted_message=$(encrypt "$message" "$offset")
echo "Encrypted message: $encrypted_message"

