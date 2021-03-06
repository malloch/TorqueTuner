(
/*
////////////// BiPolar Panner Demo for TorqueTuner //////////////
Run this demo by placing cursor below this comment and press CMD+return.
Stop it by pressing CMD+.
///////////////////////////////////////////////////////////
*/

// Start libmapper
s.waitForBoot({
	a  = Mapper.enable;
	1.wait;
	////////////// Output signals  //////////////


	~mode = Bus.control;
	{
		MapperOutput.kr(In.kr(~mode), 'Modeselektor', 0, 7);
	}.play;


	////////////// Input signals  //////////////

	~resonance = Bus.control;
	{
		Out.kr(~resonance,MapperInput.kr('Resonance', 0, 1));
	}.play;

	~pan = Bus.control;
	{
		Out.kr(~pan, MapperInput.kr('Balance', -1, 1));
	}.play;

	////////////// Synth Defs  //////////////

	// Modeselektor
	Ndef(\modePlay,{ arg mode = 5;
		Out.kr(~mode,mode)
	}).play;

	// Filter - pan
	Ndef(\filter).clear;
	Ndef(\modePlay).set(\mode,1);
	Ndef(\filter_balance,{
		var ctrl_in = 0.3;
		var sig = BLowPass4.ar(LFSaw.ar([99.5,100.5]),ctrl_in.linlin(0,1,20,3000)**[0.99,1.01],In.kr(~resonance).lincurve(0,1,1,0.02,-4));
		var sig2 = BLowPass4.ar(LFSaw.ar([99.5,100.5]*2,0.2),ctrl_in.linlin(0,1,100,5000)**[0.99,1.01],In.kr(~resonance).lincurve(0,1,1,0.02,-4));
		sig = Mix.new((sig + (ctrl_in.lincurve(0,1,0,1,4)*sig2))/2);
		Out.ar(0,Pan2.ar(sig,In.kr(~pan)));
	}).play;

});
)
