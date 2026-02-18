#!/bin/bun

import{codeToHtml}from'shiki';

const
w=await({
	cf:_=>({
		og:{
			type:'website',
			title:'dot.6ca.me',
			description:'McbeEringi dotfiles',
			url:'https://dot.6ca.me/',
			image:'https://mcbeeringi.dev/img/icon.png'
		},
		style:['https://mcbeeringi.dev/src/style.css']
	}),
	gh:_=>({
		og:{
			type:'website',
			title:'dotfiles',
			description:'McbeEringi dotfiles',
			url:'https://mcbeeringi.github.io/dotfiles/',
			image:'https://mcbeeringi.github.io/img/icon.png'
		},
		style:['https://mcbeeringi.github.io/src/style.css']
	})
}[Bun.argv[2]]??(_=>Promise.reject(`Unknown dst "${Bun.argv[2]}"`)))();

await Bun.write(
	'index.html',
	await new HTMLRewriter()
	.on('div.md',{element:async e=>e.append(
		await(async(w,r,a,i=0)=>(
			a=await Promise.all([...w.matchAll(r)].map(([_,lang,x])=>codeToHtml(x,{lang,theme:'one-dark-pro'}))),
			w.replace(r,_=>a[i++])
		))(
			Bun.markdown.html(await Bun.file(e.getAttribute('data-path')).text()),
			/<pre><code class="language-(.+?)">(.+?)<\/code><\/pre>/sg
		),
		{html:1}
	)})
	.on('title',{element:e=>e.append(w.og.title)})
	.on('meta[name="description"]',{element:e=>e.setAttribute('content',w.og.description)})
	.on('meta[og]',{element:e=>e.replace(
		Object.entries(w.og).reduce((a,[k,v])=>`${a}<meta property="og:${k}" content="${v}">`,''),
		{html:1}
	)})
	.on('meta[style]',{element:e=>e.replace(
		w.style.map(x=>`<link rel="stylesheet" href="${x}">`).join(''),
		{html:1}
	)})
	.transform(await Bun.file('index.tmpl.html').text())
);

