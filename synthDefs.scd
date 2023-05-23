//BitWinds
//A subtractive synthesis powered wind instrument emulator
//----------------------
//Authors: Francesco Colotti, Gioele Fortugno, Matteo Gionfriddo, Marco Granaiola, Emanuele Greco
//----------------------
// SynthDefs file

(
// 1 -> Sawtooth, 2 -> Square, 3 -> Triangle
~osc_type = 1;

// 1 -> Brown, 2 -> Pink, 3 -> White
~noise_type = 1;

// 0 -> None, 1 -> Pan, 2 -> Brass
~timbre_osc_type = 0;
~timbre_noise_type = 0;

~input_bus_timbre_osc=53;
~input_bus_timbre_noise=54;
~output_bus_timbre_osc=55;
~output_bus_timbre_noise=57;

// 3 -> HighPass, 4 -> LowPass
~filter1_osc_type = 3;
~filter2_osc_type = 3;

~input_bus_filter1_osc=55;
~output_bus_filter1_osc=56;
~filter1_osc_on=false;

~input_bus_filter2_osc=56;
~output_bus_filter2_osc=59;
~filter2_osc_on=false;

// 3 -> HighPass, 4 -> LowPass
~filter1_noise_type = 3;
~filter2_noise_type = 3;

~input_bus_filter1_noise=57;
~output_bus_filter1_noise=58;
~filter1_noise_on=false;

~input_bus_filter2_noise=58;
~output_bus_filter2_noise=59;
~filter2_noise_on=false;

// Used to handle first creation of synths
~first=true;
~first_play=true;
~first_timbre_play=true;
~first_filters_osc_play=true;
~first_filters_noise_play=true;
~first_effects_play=true;
~first_final_mixing_play=true;

// 1 - > BitCrusher, 2 -> Reeverb, 3-> Compressor, 4 -> Distortion,
~fx1_type=1;
~fx2_type=1;
~fx3_type=1;
~fx4_type=1;
~fx5_type=1;

~fx1_on=false;
~fx2_on=false;
~fx3_on=false;
~fx4_on=false;
~fx5_on=false;

~input_bus_fx1=59;
~output_bus_fx1=60;

~input_bus_fx2=60;
~output_bus_fx2=61;

~input_bus_fx3=61;
~output_bus_fx3=62;

~input_bus_fx4=62;
~output_bus_fx4=63;

~input_bus_fx5=63;
~output_bus_fx5=64;

~input_bus_final_mixing=64;

u = Group.new;
g = Group.after(u);
o = Group.after(g);


// WAVE SYNTH DEFINITIONS

// FILTERS SYNTH DEFINITIONS
//Low Pass Filter Osc 1 Definition
SynthDef(\lpf_osc, {
	|
	out = 0,
	cutoff, res = 0.1, inBus
	|

	var sig;

	sig = RLPF.ar(In.ar(inBus,1),cutoff,res);
	// Output
	Out.ar(out,sig);
}).add;

//High Pass Filter Osc 1 Definition
SynthDef(\hpf_osc, {
	|
	out = 0,
	cutoff , res = 0.1, inBus
	|

	var sig;

	sig = RHPF.ar(In.ar(inBus,1),cutoff,res);
	// Output
	Out.ar(out,sig);
}).add;

//Low Pass Filter Osc 2 Definition
SynthDef(\lpf2_osc, {
	|
	out = 0,
	cutoff2, res2 = 0.1, inBus
	|

	var sig;

	sig = RLPF.ar(In.ar(inBus,1),cutoff2,res2);
	// Output
	Out.ar(out,sig);
}).add;

//High Pass Filter Osc 2 Definition
SynthDef(\hpf2_osc, {
	|
	out = 0,
	cutoff2 , res2 = 0.1, inBus
	|

	var sig;

	sig = RHPF.ar(In.ar(inBus,1),cutoff2,res2);
	// Output
	Out.ar(out,sig);
}).add;

//Low Pass Filter Noise 1 Definition
SynthDef(\lpf_noise, {
	|
	out = 0,
	cutoff, res = 0.1, inBus
	|

	var sig;

	// Envelope
	sig = In.ar(inBus);
	sig = RLPF.ar(sig,cutoff,res);
	// Output
	Out.ar(out,sig);
}).add;

//High Pass Filter Noise 1Definition
SynthDef(\hpf_noise, {
	|
	out = 0,
	cutoff , res = 0.1, inBus
	|

	var sig;

	// Envelope
	sig = In.ar(inBus);
	sig = RHPF.ar(sig,cutoff,res);
	// Output
	Out.ar(out,sig);
}).add;

//Low Pass Filter Noise 2 Definition
SynthDef(\lpf2_noise, {
	|
	out = 0,
	cutoff2, res2 = 0.1, inBus
	|

	var sig;

	// Envelope
	sig = In.ar(inBus);
	sig = RLPF.ar(sig,cutoff2,res2);
	// Output
	Out.ar(out,sig);
}).add;

//High Pass Filter Noise 2 Definition
SynthDef(\hpf2_noise, {
	|
	out = 0,
	cutoff2 , res2 = 0.1, inBus
	|

	var sig;

	// Envelope
	sig = In.ar(inBus);
	sig = RHPF.ar(sig,cutoff2,res2);
	// Output
	Out.ar(out,sig);
}).add;

//Dummy SynthDef
SynthDef(\dummy, {
	|
	out ,inBus
	|

	var sig;

    sig = In.ar(inBus);
	Out.ar(out,sig);
}).add;

//Dummy with Envelope SynthDef
SynthDef(\dummyEnv, {
	|
	out,att = 0.5
	sus = 0.5, rel = 0.5,
	amp = 1, midinote = 60,
	ampSaw = 1, ampTri = 0,
	ampPul = 0, ampWhi = 0,
	ampBro = 0, ampPin = 0
	|

	var env,sig,saw,tri,pul,wno,bno,pno;

	env = EnvGen.kr(Env([0,1,1,0],[att,sus,rel],[1,0,-1]),doneAction:2);
	saw = Saw.ar(midinote.midicps)*ampSaw;
	tri = LFTri.ar(midinote.midicps,0)*ampTri;
	pul = Pulse.ar(midinote.midicps,0.5)*ampPul;

	wno = WhiteNoise.ar()*ampWhi;
	bno = BrownNoise.ar()*ampBro;
	pno = PinkNoise.ar()*ampPin;

	sig = saw + tri + pul + wno + bno + pno;

	Out.ar(out,sig*env*0.05*amp);
}).add;

// TIMBRE SYNTH DEFINITIONS
//Pan Osc SynthDef
SynthDef(\panOsc, {
	|
	out ,att = 0.2,
	sus = 1, rel = 0.2,
	rq = 7,
	vibrato_freq = 8,
	vibrato_depth = 0.17,
	ntt_ratio=0.6, // noise to tonal ratio
	amp = 1, midinote = 60,
	ampSaw = 1, ampTri = 0,
	ampPul = 0
	|

	var env,sig,vibrato,saw,tri,pul,freq;

	// Midi -> Freq
	freq = midinote.midicps;

	// Envelope
	env = EnvGen.kr(Env([0,1,1,0],[att,sus,rel],[1,0,-1]),doneAction:2);

	//LFO per vibrato
	vibrato = SinOsc.kr(vibrato_freq,mul:vibrato_depth,add:-1*vibrato_depth/2);

	// Processing
	saw = Saw.ar(freq)*ampSaw;
	tri = LFTri.ar(freq,0)*ampTri;
	pul = Pulse.ar(freq,0.5)*ampPul;
	sig = saw + tri + pul;
	sig = RLPF.ar(sig,freq,rq);
	sig = sig*(1+vibrato);

	// Output
	Out.ar(out,sig*env*amp*(1-ntt_ratio));
}).add;

//Brass Osc SynthDef
SynthDef(\brassOsc, {
	|
	out ,att = 0.2,
	dec = 0.2 ,sus = 1,
	rel = 0.1,midinote = 60,
	amp = 1,ampSaw = 1,
	ampTri = 0,ampPul = 0
	|
	// Midi -> freq
	var freq = midinote.midicps;
	var env,sig,tone,lfo,lfo_freq = 8, lfo_depth = 0.7, lfo_env;
	var lpf_env, lpf_freq = freq + (10000-freq)*0.18;
	var lpf_ratio = lpf_freq/10000;
	var growl,growl_env,growl_depth = 0.7;
	var vibrato_env, vibrato_depth = 0.18;
	var vibrato,ntt_ratio=0.15; //noise to tone ratio
	var gate = SinOsc.kr(1);
	var saw,tri,pul;
	gate=1;


	//Envelope
	env = EnvGen.kr(Env([0,1,0.8,0.8,0],[att,dec,sus,rel],[1,0,-1]),doneAction:2);

	// Tremolo
	lfo = SinOsc.kr(lfo_freq, mul:lfo_depth,add:-1*lfo_depth/2);
	lfo_env = Env.new(
		levels: [0.0, 0.0, 1.0, 0],  //AR contour
		times: [att+dec, sus, rel]);
	lfo_env = EnvGen.kr(lfo_env, gate);
	lfo=lfo*lfo_env;

	// Lpf frequency envelope
	lpf_env = Env.new(
		levels: [0, 1, lpf_ratio, 1.1*lpf_ratio, 0],
		times: [att, dec, sus, 0.05]);
	lpf_env = EnvGen.kr(lpf_env, gate);

	// Growl generator
	growl_env = Env.new(
		levels: [1, 0], //AD contour
		times: [0.6]);
	growl_env = EnvGen.kr(growl_env, gate);
	growl = LFTri.kr(80, mul:growl_depth,)*growl_env;

	// Vibrato generator
	vibrato_env = Env.new(
		levels: [0.0, 0.0, 1], //AD contour
		times: [att+dec, sus]);
	vibrato_env = EnvGen.kr(vibrato_env, gate);
	vibrato = LFTri.kr(5,mul:vibrato_depth,add:-1*vibrato_depth/2);

	// Processing
	saw = Saw.ar(freq)*ampSaw;
	tri = LFTri.ar(freq,0)*ampTri;
	pul = Pulse.ar(freq,0.5)*ampPul;
	tone = saw + tri + pul;
	tone = tone*env*(1+lfo);
	sig = RLPF.ar(tone,freq:(10000*lpf_env+1)*(1+growl),rq:1.3);
	//sig = sig * (1+vibrato);

	// Output
	Out.ar(out,sig*amp*(1-ntt_ratio)*0.3);
}).add;
//Pan Noise SynthDef
SynthDef(\panNoise, {
	|
	out ,inBus,att =0.1
	sus = 1, rel = 0.24,
	amp = 1, midinote = 60,
    ampWhi = 0,ampBro = 0,
	ampPin = 0
	|

	var env,sig,harmonics,chiff_env;
	var hpf_freq=midinote.midicps + (20000-midinote.midicps)*0.4;
	var input_noise,noise, chiff;
	var ftc_ratio = 0.9; // fromant noise to chiff ratio
	var ntt_ratio=0.6; //noise to tonal ratio
	var wno,bno,pno;

	 //3 octaves and 3 fifths, to emulate air blowing sound
	harmonics = [1,1.5,2,2*1.5,4,4*1.5,8,8*1.5];

	// Envelope
	env = EnvGen.kr(Env([0,1,0.3,0.3,0],[att,0.2,sus,rel],[1,0,-1]),doneAction:2);

	// Chiff Envelope
	chiff_env = Env.new(
		levels: [1, 0.01],
		times: [0.26]);
	chiff_env = EnvGen.kr(chiff_env);

	// Processing
	wno = WhiteNoise.ar()*ampWhi;
	bno = BrownNoise.ar()*ampBro;
	pno = PinkNoise.ar()*ampPin;
	input_noise = wno + bno + pno;
    input_noise = HPF.ar(input_noise,hpf_freq);
	noise = BBandPass.ar(input_noise,harmonics*midinote.midicps,bw:0.1);
	noise = noise*env;

	// Chiff
	chiff = LPF.ar(input_noise,5000*chiff_env+1,mul:0.3);
	chiff = chiff*chiff_env;

	// Mix
	sig = Mix.arFill(1,[chiff*(1-ftc_ratio) + 6*noise*ftc_ratio]);

	// Output
	Out.ar(out,sig*ntt_ratio*amp);
}).add;
//Brass Noise SynthDef
SynthDef(\brassNoise, {
	|
	out ,att = 0.2
	sus = 1, rel = 0.1,
	midinote = 60, ampWhi = 1,
	ampBro = 0, ampPin = 0,
	amp = 1
	|

	var env,sig,harmonics;
	var hpf_freq = midinote.midicps+(10000-midinote.midicps)*0.28;
	var ntt_ratio = 0.15; // noise to tone ratio
	var wno,bno,pno;

	 // To emulate air blowing sound
	harmonics = [1,1.5,2,2*1.5,4,4*1.5];
	//  Envelope
	env = EnvGen.kr(Env([0,1,0.4,0.4,0],[att,0.2,sus,rel],[1,0,-1]),doneAction:2);

	// Processing
	wno = WhiteNoise.ar()*ampWhi;
	bno = BrownNoise.ar()*ampBro;
	pno = PinkNoise.ar()*ampPin;
    sig =  wno + bno + pno;
	sig = HPF.ar(sig,hpf_freq);
	sig = BBandPass.ar(sig,harmonics*midinote.midicps,bw:0.2,mul:6);
	sig = Mix.arFill(1,[sig]);

	//Output
	Out.ar(out,sig*ntt_ratio*0.3*env*amp);
}).add;

//Dummy Double SynthDef (Used for debugging)
SynthDef(\dummyDouble, {
	|
	out1,out2 ,inBus1, inBus2,
	att1 = 0.25,sus1 = 0.25,rel1 = 0.25,
	att2 = 0.25,sus2 = 0.25,rel2 = 0.25
	|

	var env1,env2,sig1,sig2,snd;

    env1 = EnvGen.kr(Env([0,1,1,0],[att1,sus1,rel1],[1,0,-1]),doneAction:2);
	env2 = EnvGen.kr(Env([0,1,1,0],[att2,sus2,rel2],[1,0,-1]),doneAction:2);

    sig1 = In.ar(inBus1);
	sig2 = In.ar(inBus2);

    Out.ar(out2,sig2*env2);
    Out.ar(out1,sig1*env1);
}).add;

// EFFECTS SYNTH DEFINITION
// BitCrusher Definition
SynthDef(\bitcrushimusMaximus,{
	|
	inBus, sr = 44100, bits = 32,
	out=0
	|
	var in, sig;
	in = In.ar(inBus);
	sig = Decimator.ar(in, rate:sr, bits: bits);
	Out.ar(out,sig);
}
).add;
// Reverb Definition
SynthDef(\reverbior, {
	|
	inBus, size=150, damp=0.5,
	drylevel=0.5, out=0
	|
	var sig;
	sig = In.ar(inBus);
	sig = FreeVerb.ar(sig,drylevel,size,damp);
	Out.ar(out,sig);
}).add;

// Compressor Definition
SynthDef(\compressor, {
	|
	inBus, thresh=1, ratio=1, gain=1, atk=0.15,
	rel=0.15, out
	|
	var in, sig;
	in = In.ar(inBus);
	sig = Compander.ar(in:in, thresh:thresh, slopeAbove: ratio, clampTime: atk, relaxTime: rel, mul: gain);
	Out.ar(out,sig);
}).add;


SynthDef(\winDistort, {
	|
	inBus,pre=1, post=1,dist=1,
	out=0,amp
	|
	var in, sig;
	in = In.ar(inBus);
	sig = CrossoverDistortion.ar(in, amp: amp, smooth: dist, mul: post, add: 0);
	Out.ar(out,sig);
}).add;

//Final Mixing SynthDef
SynthDef(\finalMix, {
	|
	out1=0,out2=1,inBus
	|

	var sig,sig1,sig2;

    sig = In.ar(inBus);
	sig = Limiter.ar(sig,0.1);

	sig1 = sig;
	sig2 = DelayL.ar(sig,0.2,0.01);

	Out.ar(out1,sig1);
	Out.ar(out2,sig2);
}).add;

)