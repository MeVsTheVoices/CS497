#!/bin/bash

encrypt() {
	local encrypted="$1"
	local offset="$2"
	local decrypted=""

	upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	lower="abcdefghijklmnopqrstuvwxyz"
	# The logic here is simple, we're transpoing by a specific offset
	decrypted=$(echo "$encrypted" | tr "\[$upper$lower\]" "\[${upper:$offset}${upper::$offset}${lower:$offset}${lower::$offset}\]")

	echo "$decrypted"
}

decrypt() {
	local encrypted="$1"
	local offset="$2"
	local decrypted=""

	upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	lower="abcdefghijklmnopqrstuvwxyz"
	# All we need to do is swap the ordering of our parameters to work backwords from where we started
	decrypted=$(echo "$encrypted" | tr "\[${upper:$offset}${upper::$offset}${lower:$offset}${lower::$offset}\]" "\[$upper$lower\]")

	echo "$decrypted"
}

keep_going_string=""
while [[ ! $keep_going_string =~ ^[nN]$ ]]; do
	# There's a simple thing we keep doing here, we'll keep looping until the user enters output
	# in the format that we're expecting
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
		if [[ $offset -gt 26 ]];then
			offset=$(( $offset % 26 ))
		fi
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




