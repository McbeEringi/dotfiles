import MarkdownItAsync from'markdown-it-async';
import{codeToHtml}from'shiki';
import{fromAsyncCodeToHtml}from'@shikijs/markdown-it/async';

const
copy=md=>(f=>md.renderer.rules.fence=(...arg)=>`<div class="fence">${f(...arg)}<button>📎</button></div>`)(md.renderer.rules.fence),
default_plugins=[
	[fromAsyncCodeToHtml(codeToHtml,{
		themes:{light:'one-light',dark:'one-dark-pro'},
		defaultColor:false,
	})],
	[copy]
],
MD=(use=default_plugins)=>use.reduce((a,x)=>(a.use(...x),a),MarkdownItAsync()),
client_js=['body',{element:e=>e.append(`\
<script>
document.querySelectorAll('.fence>button').forEach((e,x)=>(
	x=e.textContent,
	e.onclick=async _=>(
		await navigator.clipboard.writeText(e.previousElementSibling.textContent),
		e.textContent='☑️',setTimeout(_=>e.textContent=x,500)
	)
));
</script>
`,{html:1})}];

export{copy,default_plugins,MD,client_js};
