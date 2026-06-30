#!/usr/bin/env -S bun --install=force
import{parseArgs}from'util';

const
args=parseArgs({
	options:{
		silence_level:{type:'string',default:'-35dB'},
		silence_min_duration:{type:'string',default:'2'},
		segment_min_duration:{type:'string',default:'2'},
		segment_times:{type:'string'},
		dry:{type:'boolean',default:false}
	},
	allowPositionals:true
}),
split=async({
	file,
	dir=file+'.part',
	x:{
		silence_level,
		silence_min_duration,
		segment_min_duration,
		segment_times,
		dry
	}=args.values
})=>(
	dry||await Bun.$`mkdir -p "${dir}"`,
	segment_times??(
		segment_times=[
			...new TextDecoder().decode(
				(await Bun.$`ffmpeg -i "${file}" -af silencedetect=noise=${silence_level}:d=${silence_min_duration} -f null -`.quiet()).stderr
			).matchAll(/silence_start: (?<start>[.\d]+).*?silence_end: (?<end>[.\d]+)/sg).map(x=>(x=x.groups,[+x.start,+x.end])),
			Array(2).fill(await Bun.$`ffprobe -v error -show_entries format=duration -of csv=p=0 "${file}"`.json())
		].reduce((a,x)=>(
			x[0]-a.at(-1)[1]<segment_min_duration?
				(a.at(-1)[1]=x[1]):
				a.push(x),
			a
		),[[0,0]]).map((x,i,{length:l})=>(i?i<l-1?(x[0]+x[1])/2:x[1]:x[0]).toFixed(3)),
		//.slice(1,-1).map(x=>((x[0]+x[1])/2).toFixed(3)).join(),
		console.log({
			file,
			segments:segment_times.length-1,
			durations:segment_times.slice(1).reduce((a,x)=>(a.a.push((x=>`${x/60|0}:${((x%60|0)+'').padStart(2,0)}`)(x-a.x)),a.x=x,a),{x:segment_times[0],a:[]}).a,
			segment_times:segment_times=segment_times.slice(1,-1).join(),
		})
	),
	dry||await Bun.$`ffmpeg -v error -i "${file}" -f segment -segment_start_number 1 -segment_times ${
		segment_times||0
	} -reset_timestamps 1 -c copy "${dir}/%02d${file.match(/\..+?$/)?.[0]??''}"`
);

console.log(JSON.stringify(args,0,'\t'))
// await Bun.argv.slice(2).reduce(async(a,x)=>(await a,await split({file:x})),0);
await Promise.all(args.positionals.map(x=>split({file:x})));
