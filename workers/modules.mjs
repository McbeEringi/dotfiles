import{dirname,relative}from'node:path';

export default ({args})=>({

config_default:{
	title:'dot.6ca.me',
	desc:'McbeEring dotfiles'
},
html_tmpl:c=>x=>((
	o=Object.entries({
		cf:'https://dot.6ca.me/',
		gh:'https://mcbeeringi.github.io/dotfiles/'
	}).reduce((a,[i,x])=>args.includes(i)?x:a,'')
)=>({...x,html:`\
<!DOCTYPE html>
<html prefix="og:http://ogp.me/ns#" lang="en"><head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width,initial-scale=1">
	<title>${c.title}</title>
	<meta name="description" content="${c.desc}">
	<link rel="icon" type="image/png" href="${relative(dirname(x.path),'img/favicon.png')}">
	<link rel="icon" type="image/svg+xml" href="${relative(dirname(x.path),'img/favicon.svg')}">
	<link rel="apple-touch-icon" href="${relative(dirname(x.path),'img/apple-touch-icon.png')}">
	<meta property="og:type" content="website">
	<meta property="og:title" content="${c.title}">
	<meta property="og:description" content="${c.desc}">
	<meta property="og:url" content="${new URL(x.path,o)}">
	<meta property="og:image" content="${new URL('img/apple-touch-icon.png',o)}">
	<link href="/src/style.css" rel="stylesheet">
${x.style.length?`\t<style>${x.style.join('\n')}\t</style>\n`:''}\
	<script>document.documentElement.addEventListener('touchstart',_=>_,{passive:true});</script>
</head><body>
${x.html}\
</body></html>
`}))()

});
