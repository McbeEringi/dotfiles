#!/usr/bin/env -S bun --install=force

const
file=Bun.argv[2],
dir=file+'.part',
ext=file.match(/\.[^.]+$/)?.[0]??'',
d=(
	await Bun.stdin.text()
)
	.matchAll(/(?<m>\d{2}):(?<s>\d{2})\s*(?<name>.*?)\s*\n/g)
	.reduce((a,{groups:{m,s,name}})=>(a.t.push(+s+60*m),a.n.push(name),a),{t:[],n:[]});

await Bun.$`mkdir ${dir}`;
await Bun.$`ffmpeg -v error -i "${file}" -map 0:a -c:a copy -f segment -segment_times ${d.t.slice(1).join(',')} -reset_timestamps 1 "${dir}/%d${ext}"`
await Promise.all(d.n.map((x,i)=>Bun.$`mv "${dir}/${i}${ext}" "${dir}/${x}${ext}"`))
