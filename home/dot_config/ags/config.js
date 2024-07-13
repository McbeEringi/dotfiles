import {brightness} from './brightness.js';
const
dot=x=>'\u2800⡀⣀⣄⣤⣦⣶⣷⣿'[x*9|0],
s=Object.assign(await'hyprland,notifications,mpris,audio,battery,systemtray'.split(',').reduce(async(a,x,_)=>(_=await Service.import(x),a=await a,a[x]=_,a),{}),{brightness}),
watch=(x,f)=>Utils.watch(f(x),x,_=>f(x)),

Workspaces=_=>Widget.Box({
	class_names:['workspaces'],
	children:s.hyprland.bind('workspaces').as(
		ws=>ws.sort((a,b)=>a.id-b.id).map(x=>Widget.Button({
			on_clicked:_=>s.hyprland.messageAsync('dispatch '+(0<x.id?`workspace ${x.name}`:`togglespecialworkspace ${x.name.slice(8)}`)),
			child:Widget.Label(x.name.split(':').pop()),
			class_name:s.hyprland.active.workspace.bind('id').as(y=>y==x.id?'focused':'')
		}))
	)
}),
ClientTitle=_=>Widget.Label({class_names:['client-title'],label:s.hyprland.active.client.bind('class')}),
Clock=_=>Widget.Label({class_names:['clock'],label:Variable('',{poll:[1000,'date "+%y-%m-%d %H:%M"']}).bind()}),
Media=_=>Widget.Box({
	class_names:['media'],
	children:s.mpris.bind('players').as(w=>w.map(x=>Widget.Button({
		child:Widget.Box({children:[
			Widget.Icon({visible:x.bind('cover_path'),icon:x.cover_path}),
			Widget.Label({visible:x.bind('cover_path').as(x=>!x),label:x.track_title.slice(0,2)})
		]}),
		tooltip_markup:watch(x,x=>'track-title,track-album,track-artists,name'.split(',').flatMap(i=>x[i]||[]).join('\n')),
		on_primary_click:_=>x.playPause(),
		on_secondary_click:_=>x.next(),
		on_middle_click:_=>x.previous()
	})))
}),
SysTray=_=>Widget.Box({
	class_names:['sys-tray'],
	children:s.systemtray.bind('items').as(items=>items.map(x=>Widget.Button({
		child:Widget.Icon({icon:x.bind('icon')}),
		tooltip_markup:x.bind('tooltip_markup'),
		on_primary_click:(_,e)=>x.activate(e),
		on_secondary_click:(_,e)=>x.openMenu(e)
	})))
}),
// Network=_=>Widget.Button({
// 	class_names:['network'],
// 	child:Widget.Icon({icon:s.network.bind('icon-name')}),
// }),
Volume=_=>Widget.Button({
	class_names:['volume'],
	child:Widget.Icon({icon:watch(s.audio.speaker,x=>`audio-volume-${['muted','low','medium','high'][!x.is_muted*Math.ceil(x.volume*3)]||'overamplified'}-symbolic`)}),
	tooltip_text:watch([s.audio.speaker,s.audio.microphone],x=>x.map((y,i)=>`${['Spk','Mic'][i]} ${Math.round(y.volume*100)}% ${y.is_muted?'[MUTED]':''}`).join('\n')),//s.audio.speaker.bind('volume').as(x=>Math.round(x*100)+'%'),
	on_primary_click:_=>Utils.exec('pavucontrol'),
	on_secondary_click:_=>Utils.exec('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'),
	setup:x=>x.on('scroll-event',(_,e)=>s.audio.speaker.volume+=e.get_scroll_deltas()[2]*.1)
}),
Brightness=_=>Widget.Button({
	class_names:['brightness'],
	child:Widget.Icon({icon:watch(s.brightness,x=>`display-brightness-${['off','low','medium'][x.screen_value*4|0]||'high'}-symbolic`)}),
	tooltip_text:s.brightness.bind('screen-value').as(x=>Math.round(x*100)+'%'),
	setup:x=>x.on('scroll-event',(_,e)=>s.brightness.screen_value+=e.get_scroll_deltas()[2])
}),
// CPU=_=>_,
// RAM=_=>_,
Battery=_=>Widget.Button({
	class_names:['battery'],
	visible:s.battery.bind('available'),
	child:Widget.Icon({icon:s.battery.bind('icon-name')}),
	tooltip_text:watch(s.battery,x=>`${x.percent}%\n${x.charged?'Full':'→'+(x.charging?'Full ':'Empty ')+(x=Math.round(x.time_remaining/60),((x/60|0)+':').padStart(3,0)+(x%60+'').padStart(2,0))}`)
}),

Bar=(monitor=0)=>Widget.Window({
	name:`bar-${monitor}`, // name has to be unique
	class_names:['bar'],
	monitor,
	anchor:['top','left','right'],
	margins:[8,8,0,8],
	exclusivity:'exclusive',
	child:Widget.CenterBox({
		start_widget:Widget.Box({spacing:8,children:[
			Workspaces(),
			ClientTitle()
		]}),
		center_widget:Widget.Box({spacing:8,children:[
			Clock()
		]}),
		end_widget:Widget.Box({hpack:'end',spacing:8,children:[
			Media(),
			SysTray(),
			// Network(),
			Volume(),
			Brightness(),
			//CPU(),
			//RAM(),
			Battery()
		]})
	})
});

App.config({
	style:'./style.css',
	iconTheme:'Papirus',
	windows:[
		Bar()
	]
});
