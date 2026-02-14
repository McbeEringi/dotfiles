#!/bin/bun

const
td=new TextDecoder(),
sock=Bun.spawn({cmd:['socat','STDIO',`"${Bun.env.NIRI_SOCKET}"`],stdin:'pipe',stdout:'pipe',stderr:null}),
e=(e=>((async(r,x)=>{
	while(1){
		x=await r.read();if(x.done)break;
		e.dispatchEvent(new CustomEvent('data',{detail:x.value}));
	}
})(sock.stdout.getReader()),e))(new EventTarget()),
msg=async x=>new Promise((f,r)=>(
	e.addEventListener('data',({detail:x})=>(
		x=JSON.parse(td.decode(x)),
		x.Ok?f(x.Ok):r(x)
	),{once:true}),
	sock.stdin.write(JSON.stringify(x)+'\n')
)),
w={
	ws:(await msg('Workspaces')).Workspaces,
	mon:(await msg('Outputs')).Outputs,
	win:(await msg('Windows')).Windows
},
win=ws=>w.win.filter(x=>x.workspace_id==ws.id&&x.is_floating),
c=w.ws.find(x=>x.is_focused),
s=(_=>(
	_=w.ws.filter((w=>x=>w.every(([k,v])=>x[k]==v))(
		Object.entries(JSON.parse(Bun.argv[2]))
	)),
	1<_.length?_.find(x=>x.output==c.output):_[0]
))(),
mv=(win,ws)=>Promise.all(win.map(async x=>({
	msg:await msg({Action:{MoveWindowToWorkspace:{
		window_id:x.id,focus:false,reference:{Id:ws.id},
	}}}),
	window:x
})));

console.log(s?
	s==c?
		{
			focus:await msg({Action:{SwitchFocusBetweenFloatingAndTiling:{}}})
		}:
		win(s).length?
			{// show
				move:await mv(win(s),c),
				focus:await msg({Action:{FocusFloating:{}}})
			}:
			{// hide
				move:await mv(win(c),s)
			}
:w.ws);

sock.kill();
await sock.exited;
