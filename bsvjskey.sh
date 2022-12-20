#!/usr/bin/env bash

# to print more than 1 keypair at a time just add the amount of keys you want created
# example:
# $ bash bsvjskey.sh 100

npm_installation_check(){
          if [[ ! -f $(command -v npm) && ! -x $(command -v npm) ]]; then
                    echo "install npm"
                    exit 1
          fi
}

bsv_installation_check(){
          if ! npm list bsv &>/dev/null; then
		echo -n "installing bsv js..."
		npm i --prefix "$(pwd)" bsv --save &>/dev/null
		echo -ne "\r"
	fi
}

bsv_js_versions_syntax(){
	if [[ "$(npm list bsv | cut -d '@' -f 2 | awk NR==2 | cut -c -1)" == 2 ]];then
		bsvjs_vkey=PrivKey
	        bsvjs_pkey=PubKey
	elif [[ "$(npm list bsv | cut -d '@' -f 2 | awk NR==2 | cut -c -1)" == 1 ]];then
        	bsvjs_vkey=PrivateKey
	        bsvjs_pkey=PublicKey
	else
                echo "cant find bsv@js version number"
        	exit 1
	fi
}

bsv_javascript_heredoc(){
	node <<- BSVJSKEY
	var bsv = require('bsv')
	var privateKey = bsv.$bsvjs_vkey.fromRandom()
	var publicKey = bsv.$bsvjs_pkey.from$bsvjs_vkey(privateKey)
	console.log(bsv.Address.from$bsvjs_pkey(publicKey).toString(),privateKey.toString())
	BSVJSKEY
}

unset_bsvjsfnvariables(){
	unset bsvjs_vkey bsvjs_pkey bsvjs_keys
}

bitcoinsvjskeygen_main(){
	npm_installation_check
	bsv_installation_check
	bsv_js_versions_syntax
	while [[ "$bsvjs_keys" -gt "0" ]]; do
		bsv_javascript_heredoc
		bsvjs_keys=$((bsvjs_keys - 1))
	done
	unset_bsvjsfnvariables
}

set -e
bsvjs_keys="$1"
[ -z "$1" ] && bsvjs_keys=1
bitcoinsvjskeygen_main
