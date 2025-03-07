#!/bin/bash


	
while IFS=: read -r \
    username _ uid _ _ _ shell _ password _; do
	if [[ "$shell" == "/usr/bin/bash" || "$shell" == "/usr/bin/zsh" || "$shell" == "/usr/bin/sh" ]]; then
		if [[ "$password" != "!" && "$password" != "*" ]]; then
			echo "Login account: $username"
		else
			echo "Non-Login account: $username"
    		fi

  	else
    		echo "Non-Login account: $username"
  	fi
done < <(paste -d: /etc/passwd /etc/shadow)
