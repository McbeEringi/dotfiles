#!/bin/bun

await Bun.write(
	'../index.html',
	await new HTMLRewriter().on('div.md',{element:async e=>e.append(
		Bun.markdown.html(await Bun.file('../README.md').text()),
		{html:1}
	)}).transform(await Bun.file('index.tmpl.html').text())
);

