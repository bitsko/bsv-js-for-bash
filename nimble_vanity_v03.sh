#!/usr/bin/env bash

nimble_keys(){
	new_keys_js=$(cat <<-NEWKEYS
	const nimble = require('@runonbitcoin/nimble')
	i = 1;
	while (i<=${number_of_keys}){
	const pKey = nimble.PrivateKey.fromRandom()
	console.log(pKey.toAddress().toString(),pKey.toString())
	i = i + 1;
	}
	NEWKEYS
	)
	node <<<"${new_keys_js}"
}


prereqs_check(){
	if [[ ! $(npm list | grep runonbitcoin/nimble) ]]; then
		npm install @runonbitcoin/nimble
	fi

	if [[ -z $1 ]]; then
		echo "what to search for?"
		exit 1
	fi
}

grep_keys(){
	grep -i --color=always "$1" <<<$(awk '{print $1}' <nimblekeys.txt)
}

populate_keyfile(){
	echo "populating keyfile with $number_of_keys keys"
	nimble_keys >> nimblekeys.txt
}

prereqs_check "$1"

number_of_keys=1000

populate_keyfile
found_keys="$(grep_keys $1)"

iteration_count=0
while [[ -z $found_keys ]]; do
	populate_keyfile
	found_keys="$(grep_keys $1)"
	iteration_count=$((iteration_count + 1))
	if [[ $iteration_count == 1 ]]; then
		number_of_keys=$((number_of_keys * 100 / 75))
		iteration_count=0
	fi
done

grep_keys "$1"
