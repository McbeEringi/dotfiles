class BrightnessService extends Service{
	static{
		Service.register(this,
			{'screen-changed':['float']},
			{'screen-value':['float','rw']}
		);
	}
	#exponent=2;
	#device=Utils.exec("sh -c 'ls -w1 /sys/class/backlight | head -1'");
	#screenValue=0;
	get screen_value(){return this.#screenValue;}
	set screen_value(x){Utils.execAsync(`brightnessctl s ${Math.max(0,Math.min(x,1))*100}% -q -e${this.#exponent} -d${this.#device}`);}
	constructor(){
		super();
		Utils.monitorFile(`/sys/class/backlight/${this.#device}/brightness`,_=>this.#onChange());
		this.#onChange();
	}
	#onChange(_){
		_=Utils.exec(`brightnessctl i -e${this.#exponent} -d${this.#device}`).match(/\((\d+)%\)/)[1]/100;
		this.changed('screen-value');
		this.emit('screen-changed', this.#screenValue=_);
	}
	connect(event='screen-changed',callback){return super.connect(event,callback);}
}
const brightness=new BrightnessService;
export{brightness};