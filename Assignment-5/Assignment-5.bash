#!/usr/bin/env bash

caesar_cipher() {
    # use passed in arguments
    # $1 is the text
    # $2 is the shift
    # $3 is whether to encrypt or decrypt
    # $4 is the output file
    
    local text="$1"
    local shift="$2"
    local mode="$3"
    local result=""

    # loop through each character in the text
    for (( i=0; i<${#text}; i++ )); do
        char="${text:$i:1}"
        ascii_val=$(printf '%d' "'$char")

        # check if the character is a letter
        if [[ $char =~ [a-zA-Z] ]]; then
            # shift the character by the specified amount
            if [[ $mode == "encrypt" ]]; then
                ascii_val=$(( (ascii_val - 65 + shift) % 26 + 65 ))
            elif [[ $mode == "decrypt" ]]; then
                ascii_val=$(( (ascii_val - 65 - shift + 26) % 26 + 65 ))
            fi
            char=$(printf '\\$(printf '%03o' $ascii_val)')
        fi

        result="$result$char"
    done

    echo "$result" >> "$4"
}

rot13() {
    # use the caesar cipher function to encrypt the text with a shift of 13
    # $1 is the text
    # $2 is whether to encrypt or decrypt
    # $3 is the output file
    caesar_cipher "$1" 13 "$2" "$3"
}


