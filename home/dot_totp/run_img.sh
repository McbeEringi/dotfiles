#!/bin/bash

# place otp-migration QR-Code images in `img` dir.
# it'll automaticly scanned when running `chezmoi apply` and `urls` file will be created.

printf ''>urls
for x in ./img/*; do
	ZXingReader -formats QRCode -single -bytes "$x">>urls
	echo>>urls
done
