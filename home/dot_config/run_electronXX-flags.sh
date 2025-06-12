#!/bin/bash

which pacman >/dev/null && {
	rm $(ls|grep -P 'electron\d+') 2>/dev/null
	W=($(pacman -Qsq electron|grep -oP 'electron\d+'))
	for((i=0;i<${#W[@]};i++))do(
		ln -sf electron-flags.conf ${W[$i]}-flags.conf
	)done
}||true
