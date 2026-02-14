#!/bin/bun --install=force
import{totp,migurl}from'@mcbeeringi/petit/totp'

const urls=`${Bun.env.HOME}/.totp/urls`;

(async(w,x)=>(
	Bun.stdout.write(x?
		await totp(w[x]||Promise.reject(`${x} not found!`)):
		Object.keys(w).join('\n')
	)
))(
	(await Bun.file(urls).text()).split('\n').flatMap(x=>x&&migurl(x).params).reduce((a,x)=>(x&&(a[(x.issuer?`${x.issuer}: `:'')+x.name]=x),a),{}),
	Bun.argv[2]
);
