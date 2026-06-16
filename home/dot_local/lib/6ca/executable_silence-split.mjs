#!/usr/bin/env -S bun --install=force

const
split=async({
	file=Bun.argv[2],
	dir=file+'.part',
	silence_level='-30dB',
	silence_min_duration=.5,
	segment_min_duration=1,
	times
})=>(
	await Bun.$`mkdir -p "${dir}"`,
	times=[
		...new TextDecoder().decode(
			(await Bun.$`ffmpeg -i "${file}" -af silencedetect=noise=${silence_level}:d=${silence_min_duration} -f null -`.quiet()).stderr
		).matchAll(/silence_start: (?<start>[.\d]+).*?silence_end: (?<end>[.\d]+)/sg).map(x=>(x=x.groups,[+x.start,+x.end])),
		Array(2).fill(await Bun.$`ffprobe -v error -show_entries format=duration -of csv=p=0 "${file}"`.json())
	].reduce((a,x)=>(
		x[0]-a.at(-1)[1]<segment_min_duration?
			(a.at(-1)[1]=x[1]):
			a.push(x),
		a
	),[[0,0]]).slice(1,-1).map(x=>((x[0]+x[1])/2).toFixed(3)),
	await Bun.$`ffmpeg -i "${file}" -f segment -segment_times ${
		times.join()||0
	} -reset_timestamps 1 -c copy "${dir}/%02d${file.match(/\..+?$/)?.[0]??''}"`
);

// await Bun.argv.slice(2).reduce(async(a,x)=>(await a,await split({file:x})),0);
await Promise.all(Bun.argv.slice(2).map(x=>split({file:x})));
