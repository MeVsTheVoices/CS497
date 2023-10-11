#!/bin/bash

encrypt() {
	local message="$1"
	local offset="$2"
	local encrypted=""

	# I was tempted to use tr for this, but, this is a good excuse to
	# demonstrate basic looping and string manipulation in bash
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

decrypt() {
	local encrypted="$1"
	local offset="$2"
	local decrypted=""

	# Now the FAR simpler solution, we use bash substring expansion
	# I was tempted to use PERL, this is the kind of thing that it excels with
	# But, the Bash solution was fairly simple, so, here it is
	# This was originally written as the encryption method was, but,
	# Bash was having a hard time doing modulus on a negative number
	# So, I just did it the easy way
	# It would be equivalent to use tr for the same purpose

	upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	lower="abcdefghijklmnopqrstuvwxyz"
	# The logic here goes as follows, start at offset, and go to the end of the string
	# Then, go from the beginning of the string to offset
	decrypted=$(echo "$encrypted" | sed "y/${upper:$offset}${upper::$offset}${lower:$offset}${lower::$offset}/$upper$lower/")

	echo "$decrypted"
}

keep_going_string=""
while [[ ! $keep_going_string =~ ^[nN]$ ]]; do
	file_or_stdin=""
	while [[ ! $file_or_stdin =~ ^[fF]$ && ! $file_or_stdin =~ ^[sS]$ ]]; do
		read -p "Read from file or stdin (f/s): " file_or_stdin
	done
	if [[ $file_or_stdin =~ ^[fF]$ ]]; then
		file_name=""
		while [[ ! -f $file_name ]]; do
			read -p "Enter the file name: " file_name
		done
		message=$(cat "$file_name")
	else
		read -p "Enter the message: " message
	fi
	use_rot13_or_caesar=""
	while [[ ! $use_rot13_or_caesar =~ ^[rR]$ && ! $use_rot13_or_caesar =~ ^[cC]$ ]]; do
		read -p "Use ROT13 or Caesar cipher (r/c): " use_rot13_or_caesar
	done
	if [[ $use_rot13_or_caesar =~ ^[rR]$ ]]; then
		offset=13
	else
		offset=""
		while [[ ! $offset =~ ^[0-9]+$ ]]; do
			read -p "Enter the offset: " offset
		done
	fi

	# Determine whether to encrypt or decrypt
	encrypt_or_decrypt=""
	while [[ ! $encrypt_or_decrypt =~ ^[eE]$ && ! $encrypt_or_decrypt =~ ^[dD]$ ]]; do
		read -p "Encrypt or decrypt (e/d): " encrypt_or_decrypt
	done

	# Enter name of output file
	output_file_name=""
	while [[ -z "$output_file_name" ]]; do
		read -p "Enter the output file name (must be nonexistant): " output_file_name
	done

	# Perform the encryption or decryption
	if [[ $encrypt_or_decrypt =~ ^[eE]$ ]]; then
		encrypted_message=$(encrypt "$message" "$offset")
		echo "$encrypted_message"
		echo "$encrypted_message" > "$output_file_name"
	else
		decrypted_message=$(decrypt "$message" "$offset")
		echo "$decrypted_message"
		echo "$decrypted_message" > "$output_file_name"
	fi

	keep_going_string=""
	while [[ ! $keep_going_string =~ ^[yYnN]$ ]];do
		read -p "Keep encrypting and decrypting (y/n): " keep_going_string
	done
done




