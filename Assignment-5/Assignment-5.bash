#!/bin/bash

encrypt() {
    local message="$1"
    local offset="$2"
    local encrypted=""

    for ((i=0; i<${#message}; i++)); do
        char="${message:$i:1}"
	# We only want to transform alphabetic characters
        if [[ $char =~ [A-Za-z] ]]; then
            ascii_val=$(printf "%d" "'$char")
            if [[ $char =~ [A-Z] ]]; then
		# To explain (ascii_val - 65 + offset) gives us (ascii_val - 'A' + offset)
		# We then mod 26 (26 characters in the alphabet), then add back 'A'
                ascii_val=$(((ascii_val - 65 + offset) % 26 + 65))
            else
		# Likewise, we operate similarly, except using 'a' = 97 as our starting point
                ascii_val=$(((ascii_val - 97 + offset) % 26 + 97))
            fi
	    # Output three width octal
            encrypted+="$(printf "\\$(printf '%03o' "$ascii_val")")"
        else
	    # If we didn't encounter alphabetic, just append
            encrypted+="$char"
        fi
    done

    echo "$encrypted"
}

read -p "Enter the message: " message
read -p "Enter the offset: " offset

encrypted_message=$(encrypt "$message" "$offset")
echo "Encrypted message: $encrypted_message"

