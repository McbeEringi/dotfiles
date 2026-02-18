#!/bin/bun

console.log(
...((await Bun.file('.assetsignore').text()).match(/^[^#].*$/mg)??[]).reduce((a,x)=>(
	a[x[0]=='!'?'intersection':'union'](new Set([...new Bun.Glob(x).scanSync({dot:true,onlyFiles:false})]))
),new Set())
);
