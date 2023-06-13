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

if [[ -z $1 ]]; then
	number_of_keys=1
else
	number_of_keys=$1
fi

if [[ ! $(npm list | grep runonbitcoin/nimble) ]]; then
	npm install @runonbitcoin/nimble
fi

nimble_keys | tee -a nimblekeys.txt
