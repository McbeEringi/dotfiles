#!/bin/bash

which vim 2>/dev/null && {
PKGS=(
	https://github.com/joshdick/onedark.vim
	https://github.com/itchyny/lightline.vim
	https://github.com/machakann/vim-sandwich
)
CHK_SEC=$((60*60*24))


echo === vim_pkgmgr.sh ===
printf "\tCHK_SEC=$CHK_SEC\n"
echo

for((i=0;i<${#PKGS[@]};i++))do(
	w=${PKGS[$i]}
	x=${w##*/}
	printf "\t$x\t"
	mkdir -p "pack/$x/opt";cd "pack/$x/opt"
	if [ -d "$x" ];then
		cd "$x"
		(($CHK_SEC<(($(date +%s)-$(stat -c %Y .git/FETCH_HEAD)))))	\
			&&(
				curl -Is -o /dev/null "$w"	\
					&&(echo;echo -----;git pull --depth=1;echo -----;echo)	\
					||printf "$w...? Can't pull!\n"
				)	\
			||printf "Still new. Skipped...\n"
	else
		curl -Is -o /dev/null "$w"	\
			&&(echo;echo -----;git clone --depth=1 "$w" "$x";touch "$x/.git/FETCH_HEAD";echo -----;echo)	\
			||printf "$w...? Can't clone!\n"
	fi
)done
}||true
