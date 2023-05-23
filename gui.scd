//BitWinds
//A subtractive synthesis powered wind instrument emulator
//----------------------
//Authors: Francesco Colotti, Gioele Fortugno, Matteo Gionfriddo, Marco Granaiola, Emanuele Greco
//----------------------
// GUI file
// - Pul vs Tri variables

//TODO: choice between noise and osc
//NEW GUI
(
//StartOfNewGUI
//main window
var seqIsPlaying = false;
var win;
var vw, iv,iv2, ivFX, ivCredits; //vw = userview, iv = image view for main logo, iv2 = image view for background, ivFX = image view for fx logos, ivCredits = self explanatory
var tempVar; //for operations
var font;
var logoPath, backgroundPath; //images paths
var logo,background, credits;
var onIcon,offIcon; //tell the user if something is on or off at a glance
var mouseButton;
var mouseX;
var mouseY;

var tb_menu;
var currentScreen = 0; //0 = synth, 1 = effects, 2 = sequencer, 3 = credits

//presets toolbars
var synth_presets_label;
var noise_presets_label;
var tb_menu_presets_synth;
var tb_menu_presets_noise;
//synth part
var knobA1, knobS1, knobR1,
knobA2, knobS2, knobR2; //ADSR knobs
var tb_S_filters; //toolbar to select the filter to edit
var currFilter=0;
//TEXTS
var osc1text,osc2text;
//pop-up menus
var osc1PUM, osc2PUM;
//Synth filters
var filter1text,filter2text,filter3text,filter4text;
var knobCut1,knobCut2,knobCut3,knobCut4; //cutoff
var knobRes1,knobRes2,knobRes3,knobRes4; //resonance
var filter1PUM,filter2PUM,filter3PUM,filter4PUM; //for choosing filter type
var filter1OnOff,filter2OnOff,filter3OnOff,filter4OnOff; //on off knobs

//EFFECTS
var fxM1,fxM2,fxM3,fxM4,fxM5,fxM6,fxM7,fxM8,fxM9,fxM10;
var fx = [fxM1,fxM2,fxM3,fxM4,fxM5,fxM6,fxM7,fxM8,fxM9,fxM10]; //popup menus for effects

var fxChoices = 4; //number of selectable effects per slot
var numEffects = 5; //number of maxiumum allowed effects
var fxB1,fxB2,fxB3,fxB4,fxB5,fxB6,fxB7,fxB8,fxB9,fxB10;
var fx_on_off_buttons = [fxB1,fxB2,fxB3,fxB4,fxB5,fxB6,fxB7,fxB8,fxB9,fxB10]; //on/off buttons
var fxS1,fxS2,fxS3,fxS4,fxS5,fxS6,fxS7,fxS8,fxS9,fxS10;
var fx_switch_buttons = [fxS1,fxS2,fxS3,fxS4,fxS5,fxS6,fxS7,fxS8,fxS9,fxS10]; //to select the effect slot
var fxPa1,fxPa2,fxPa3,fxPa4,fxPa5,fxPa6,fxPa7,fxPa8,fxPa9,fxPa10;
var fx_params = [fxPa1,fxPa2,fxPa3,fxPa4,fxPa5,fxPa6,fxPa7,fxPa8,fxPa9,fxPa10];
//each entry is a dictionary storing parameters for the effect
var initFxParamDictionaries; //this will be a function
var fxText1; //ABCDE
var bitCrusherText1;
var bitCrusherText2; //used to show "Bit Depth" and "Sample Rate" texts on axes
var knobCompATK,knobCompREL,knobCompTHR, knobCompRAT, knobCompGAIN;
//knobs for compressor controls. We'll retrieve the values of these for
//each effect slot from the dictionaries
var knobDistPRE,knobDistPOST,knobDistDIST;
var eqSelectedCircle; //for EQ GUI
var tempX, tempY; //for GUI in general
var eqCircleRadius, tempPos1, tempPos2; //for EQ GUI
var knobVerbSize, knobVerbDecay, knobVerbSpread, knobVerbDamp, knobVerbDry, knobVerbEarlyRef, knobVerbTail;

var fx_statuses;
var logoBitcrush, logoComp,logoVerb,logoDist;
var textFXOnOff, textFXChoice, textFXSwitch;
//keep this below fx.length
//toolbar to select effects
var currFXSlot = 0; //goes from 0 to $numEffects-1, indicates the FX slot
//we're editing
var currFX = 0; //we'll be used to save fx[currFXSlot].value in a convenient way
var prevFX;
var fxView; //we use this to implement effects in a more creative way

var seqView; //we use this UserView for the sequencer
var time; //i don't know how to call this, basically
//the sequencer will update itself over time by a constant value
//(since we can't check for new events at the sample rate)
//Maybe we can use the control rate for this
var seqNotes; //array in which we put "Note" objects.
//Note objects should contain: (beginTime, duration, velocity)
//We can limit ourselves and use a dictionary:
//-one entry per note, inside it you save an array containing
//a [ [startTime1, duration1] , [startTime2,duration2] ,...] for events
//concerning that note
//when you need to make changes always look for the correct place to insert them
//For now we'll save the notes using startTime and duration as integers multiples of subdivisions of the sequencer
var initNotesDictionary, addNewNote,hasNote, notesToSeq; //functions
var numNotes = 12;
var minDurLen; //minimum duration note length on the GUI
var noteHeight; //note height in the GUI
var currSelNote = -1; //i need to save this outside the mouseMoveAction function otherwise it won't work
//-1 = no note selected
var currTool = 0; //in the seqView GUI:
//0: pencil to create a note
//1: extend/shorten note duration
//2: delete note
var iconPencil, iconDur, iconDel; //GUI icons for tools
var seqToolbar; //EPIC controls for the sequencer

var currentOctave = 4; //for the sequencer
//the octaves go from 1 to 7
//(yes we're cutting A0, A#0, B0 and C8 out
//If Moog can do it so can we)
//(but seriously it wouldn't make much sense to play a wind instrument that low or high)
var currentOctaveText;
var iconOctUp, iconOctDown, iconPlaySEQ, iconStopSEQ;
var octToolbar; //controls for octaves
var seqPlayStopToolbar;

var iconPlay, iconStop;
var playStopToolbar;

var tempW, tempH; //just for drawing

var hasDrawn = [false,false,false,false];

//on window change, if all the objects (knobs, texts, whatever) weren't already initialised,
//initialise them
var changeWind = { arg currentScreen;
	switch(currentScreen, 0,{
		//we need to make other views invisible
		//so that they don't interfere with mouse clicks
		seqView.visible_(false);
		fxView.visible_(false);
		ivCredits.visible_(false);
		if(hasDrawn[0]==false,{
			hasDrawn[0]=true;
			tempW = (vw.bounds.width)/2;
			//from now on everything will be duplicated for the two synths
			osc1text = StaticText.new(vw, Rect.new(100,vw.bounds.height/5, 150,50 ));
			osc1text.string = "OSCILLATOR";
			osc1text.stringColor = Color.white;

			osc2text = StaticText.new(vw, Rect.new(tempW + 100,vw.bounds.height/5, 100,
				50 ));
			osc2text.string = "NOISE";
			osc2text.stringColor = Color.white;

			//Wave type selector

			//Preset selectors
			synth_presets_label = StaticText.new(vw, Rect.new(tempW-125,vw.bounds.height/
				5, 100,50 ));
			synth_presets_label.string = "TIMBRE";
			synth_presets_label.stringColor = Color.white;
			tempW = (vw.bounds.width)/2;
			tb_menu_presets_synth = ToolBar(
				MenuAction("None", { ~timbre_osc_type = 0; ~timbre_osc_settings.value;}),
				MenuAction("Pan Flute", { ~timbre_osc_type = 1; ~timbre_osc_settings.value;}),
				MenuAction("Trumpet", { ~timbre_osc_type = 2; ~timbre_osc_settings.value;})
			);
			tb_menu_presets_synth.orientation = \vertical;
			tb_menu_presets_synth.setParent(vw);
			tb_menu_presets_synth.bounds = Rect.new(tempW-150, 175, 100, 200);
			tb_menu_presets_synth.visible_(true); //for some unknown reason, unless you do this
			//this dear thing will not be visible at startup, despite the function
			//BEING CALLED WHEN THE SCRIPT STARTS


			tempW = (vw.bounds.width);
			noise_presets_label = StaticText.new(vw, Rect.new(tempW-125,vw.bounds.height/
				5, 100,50 ));
			noise_presets_label.string = "TIMBRE";
			noise_presets_label.stringColor = Color.white;
			tb_menu_presets_noise = ToolBar(
				MenuAction("None", {~timbre_noise_type = 0; ~timbre_noise_settings.value;}),
				MenuAction("Pan Flute", {~timbre_noise_type = 1; ~timbre_noise_settings.value;}),
				MenuAction("Trumpet", {~timbre_noise_type = 2; ~timbre_noise_settings.value;})
			);
			tb_menu_presets_noise.orientation = \vertical;
			tb_menu_presets_noise.setParent(vw);
			tb_menu_presets_noise.bounds = Rect.new(tempW-150, 175, 100, 200);
			tb_menu_presets_noise.visible_(true);



			//ADSR
			//OSC1:
			tempH = (3.5*vw.bounds.height/5) - 100;
			knobA1 = EZKnob.new(vw, Rect(50, tempH, 90, 90), "A", initVal:
				0.25).setColors(stringColor:Color.white);
			//INSERT CODE FOR OSC1 ATTACK HERE
			knobA1.controlSpec.maxval = 10;
			knobA1.action = ({arg me; me.value.postln; });

			knobS1 = EZKnob.new(vw, Rect(275, tempH, 90, 90), "S", initVal:
				0.25).setColors(stringColor:Color.white);
			//INSERT CODE FOR OSC1 SUSTAIN HERE
			knobS1.controlSpec.maxval = 10;
			knobS1.action = ({arg me; me.value.linlin(0,1,0,5).postln; });

			knobR1 = EZKnob.new(vw, Rect(500, tempH, 90, 90), "R", initVal:
				0.25).setColors(stringColor:Color.white);
			//INSERT CODE FOR OSC1 RELEASE HERE
			knobR1.controlSpec.maxval = 10;
			knobR1.action = ({arg me; me.value.postln;} );

			//OSC2:
			tempW = (vw.bounds.width/2);
			knobA2 = EZKnob.new(vw, Rect(tempW+50, tempH, 90, 90), "A", initVal:
				0.25).setColors(stringColor:Color.white);
			//INSERT CODE FOR OSC2 ATTACK HERE
			knobA2.controlSpec.maxval = 10;
			knobA2.action = ({arg me; me.value.postln; });


			knobS2 = EZKnob.new(vw, Rect(tempW+275, tempH, 90, 90), "S", initVal:
				0.25).setColors(stringColor:Color.white);
			//INSERT CODE FOR OSC2 SUSTAIN HERE
			knobS2.controlSpec.maxval = 10;
			knobS2.action = ({arg me; me.value.linlin(0,1,0,5).postln; });

			knobR2 = EZKnob.new(vw, Rect(tempW+500, tempH, 90, 90), "R", initVal:
				0.25).setColors(stringColor:Color.white);
			//INSERT CODE FOR OSC2 RELEASE HERE
			knobR2.controlSpec.maxval = 10;
			knobR2.action = ({arg me; me.value.postln; });

			//WAVE SELECTOR
			tempH = (vw.bounds.height/5 + 50);
			tempW = (vw.bounds.width/2);

			//TODO check if it's an oscillator or noise, then change this accordingly...
			osc1PUM = EZPopUpMenu.new(vw, Rect(10, tempH, 200, 30),
				"Wave:").setColors(stringColor:Color.white);
			osc1PUM.addItem("Sawtooth",{~osc_type = 1;});
			osc1PUM.addItem("Square",{~osc_type = 2;});
			osc1PUM.addItem("Triangle",{~osc_type = 3;});

			osc2PUM = EZPopUpMenu.new(vw, Rect(tempW+10, tempH, 200, 30),
				"Noise:").setColors(stringColor:Color.white);
			osc2PUM.addItem("Brown",{~noise_type = 1;});
			osc2PUM.addItem("Pink",{~noise_type = 2;});
			osc2PUM.addItem("White",{~noise_type = 3; });


			//filters part

			tempH = 3.5*vw.bounds.height/5;
			/*
			tb_S_filters = ToolBar(
			MenuAction("1 >", { hidePart.value(currentScreen); currentScreen = 0; showPart.value(currentScreen); vw.refresh; }),
			MenuAction("2 >", { hidePart.value(currentScreen);currentScreen = 1;showPart.value(currentScreen); vw.refresh; }),
			MenuAction("3 >", { hidePart.value(currentScreen);currentScreen = 2;showPart.value(currentScreen); vw.refresh; }),
			MenuAction("4", { hidePart.value(currentScreen);currentScreen = 3;showPart.value(currentScreen); vw.refresh; })
			);
			tb_S_filters.setParent(vw);
			tb_S_filters.bounds = Rect.new(25, 3.5*vw.bounds.height/5, tempW, 50);
			*/ //edited, we're gonna use this if the space for the filters is not enough

			//create filter knobs, texts and selectors for each of the four filter the sound goes through

			//FILTER 1
			tempW = 0;
			filter1text = StaticText.new(vw, Rect.new(tempW+50,tempH, 100,50 ));
			filter1text.string = "FILTER 1";
			filter1text.stringColor = Color.white;

			filter1PUM = EZPopUpMenu.new(vw, Rect(tempW+22, tempH+35, 200, 30),
				"Type:").setColors(stringColor:Color.white);
			//INSERT FILTER POPUP MENU FUNCTIONS HERE
			filter1PUM.addItem("HighPass",{~filter1_osc_type = 3; ~filters_osc_creation.value;});
			filter1PUM.addItem("LowPass",{~filter1_osc_type = 4; ~filters_osc_creation.value;});


knobCut1= EZKnob.new(vw, Rect(tempW+50, tempH+100, 90, 90), "CutOff").setColors(stringColor:Color.white);
			//INSERT SYNTH FILTER CUTOFF FUNCTIONS HERE
			knobCut1.controlSpec.minval = 20;
			knobCut1.controlSpec.maxval = 20000;
			knobCut1.value = 10000;
			knobCut1.action = ({arg me; f.set(\cutoff,me.value.postln);});

			knobRes1= EZKnob.new(vw, Rect(tempW+150, tempH+100, 90, 90), "Res", initVal:
				0.25).setColors(stringColor:Color.white);
			knobRes1.controlSpec.minval = 0;
			knobRes1.controlSpec.maxval = 1;
			knobRes1.action = ({arg me; f.set(\res,me.value.postln);});


			//On/off button FOR FILTER 1
			filter1OnOff = Button.new(vw, Rect(tempW+235, tempH+20,
					45,45)).states_([
					["", Color.clear, Color.new255(100, 100, 100)],
					["", Color.clear, Color.new255(120, 120, 120)]
				]).icon_(offIcon)
				.action_({ arg butt;
					//TODO:find a way to know which button was pressed
					if(butt.value==1,{
						butt.icon_(onIcon);
					    ~filter1_osc_on=true;
					    ~filters_osc_creation.value;
					},{
						butt.icon_(offIcon);
					    ~filter1_osc_on=false;
					    ~filters_osc_creation.value;
					});
					filter1OnOff.value(i);
				});
			/*
			filter1OnOff = EZKnob.new(vw, Rect(tempW+225, tempH+65, 90, 90), "Dry/Wet", initVal:
				1).setColors(stringColor:Color.white);
			filter1OnOff.numberView.visible_(false); //hide the box showing the number.
			//the numberView variable was found by directly inspecting the EZKnob source code
			filter1OnOff.action = ({arg me; me.value.postln; });
			*/

			//FILTER 2
			tempW = vw.bounds.width/4;
			filter2text = StaticText.new(vw, Rect.new(tempW+50,tempH, 100,50 ));
			filter2text.string = "FILTER 2";
			filter2text.stringColor = Color.white;

			filter2PUM = EZPopUpMenu.new(vw, Rect(tempW+22, tempH+35, 200, 30),
				"Type:").setColors(stringColor:Color.white);
			//INSERT FILTER POPUP MENU FUNCTIONS HERE
			filter2PUM.addItem("HighPass",{~filter2_osc_type = 3; ~filters_osc_creation.value;});
			filter2PUM.addItem("LowPass",{~filter2_osc_type = 4; ~filters_osc_creation.value;});

			knobCut2= EZKnob.new(vw, Rect(tempW+50, tempH+100, 90, 90), "CutOff").setColors(stringColor:Color.white);

			knobCut2.controlSpec.minval = 20;
			knobCut2.controlSpec.maxval = 20000;
			knobCut2.value = 10000;
			knobCut2.action = ({arg me; h.set(\cutoff2,me.value);});

			knobRes2= EZKnob.new(vw, Rect(tempW+150, tempH+100, 90, 90), "Res", initVal:
				0.25).setColors(stringColor:Color.white);
			knobRes1.controlSpec.minval = 0;
			knobRes1.controlSpec.maxval = 1;
			knobRes2.action = ({arg me; h.set(\res2,me.value);});

			//On/off button FOR FILTER 2
			filter2OnOff = Button.new(vw, Rect(tempW+235, tempH+20,
					45,45)).states_([
					["", Color.clear, Color.new255(100, 100, 100)],
					["", Color.clear, Color.new255(120, 120, 120)]
				]).icon_(offIcon)
				.action_({ arg butt;
					//TODO:find a way to know which button was pressed
					if(butt.value==1,{
						butt.icon_(onIcon);
					    ~filter2_osc_on=true;
					    ~filters_osc_creation.value;
					},{
						butt.icon_(offIcon);
					    ~filter2_osc_on=false;
					    ~filters_osc_creation.value;
					});
					filter2OnOff.value(i);
				});
			/*
			filter2OnOff = EZKnob.new(vw, Rect(tempW+225, tempH+65, 90, 90), "Dry/Wet", initVal:
				1).setColors(stringColor:Color.white);
			filter2OnOff.numberView.visible_(false); //hide the box showing the number.
			//the numberView variable was found by directly inspecting the EZKnob source code
			filter2OnOff.action = ({arg me; me.value.postln; });
*/

			//FILTER 3
			tempW = 2*vw.bounds.width/4;
			filter3text = StaticText.new(vw, Rect.new(tempW+50,tempH, 100,50 ));
			filter3text.string = "FILTER 3";
			filter3text.stringColor = Color.white;

			filter3PUM = EZPopUpMenu.new(vw, Rect(tempW+22, tempH+35, 200, 30),
				"Type:").setColors(stringColor:Color.white);
			//INSERT FILTER POPUP MENU FUNCTIONS HERE
			filter3PUM.addItem("HighPass",{~filter1_noise_type = 3; ~filters_noise_creation.value; });
			filter3PUM.addItem("LowPass",{~filter1_noise_type = 4;  ~filters_noise_creation.value;});

			knobCut3= EZKnob.new(vw, Rect(tempW+50, tempH+100, 90, 90), "CutOff", initVal:
				0.25).setColors(stringColor:Color.white);
			knobCut3.controlSpec.minval = 20;
			knobCut3.controlSpec.maxval = 20000;
			knobCut3.value = 10000;
			knobCut3.action = ({arg me; w.set(\cutoff, me.value); });

			knobRes3= EZKnob.new(vw, Rect(tempW+150, tempH+100, 90, 90), "Res", initVal:
				0.25).setColors(stringColor:Color.white);
			knobRes3.controlSpec.minval = 0;
			knobRes3.controlSpec.maxval = 1;
			knobRes3.action = ({arg me; w.set(\res, me.value); });

			//On/Off button FOR FILTER 3
			filter3OnOff = Button.new(vw, Rect(tempW+235, tempH+20,
					45,45)).states_([
					["", Color.clear, Color.new255(100, 100, 100)],
					["", Color.clear, Color.new255(120, 120, 120)]
				]).icon_(offIcon)
				.action_({ arg butt;
					//TODO:find a way to know which button was pressed
					if(butt.value==1,{
						butt.icon_(onIcon);
					    ~filter1_noise_on=true;
					   ~filters_noise_creation.value;
					},{
						butt.icon_(offIcon);
					    ~filter1_noise_on=false;
					    ~filters_noise_creation.value;
					});
					filter3OnOff.value(i);
				});
			/*
			filter3OnOff = EZKnob.new(vw, Rect(tempW+225, tempH+65, 90, 90), "Dry/Wet", initVal:
				1).setColors(stringColor:Color.white);
			filter3OnOff.numberView.visible_(false); //hide the box showing the number.
			//the numberView variable was found by directly inspecting the EZKnob source code
			filter3OnOff.action = ({arg me; me.value.postln; });
			*/


			//FILTER 4
			tempW = 3*vw.bounds.width/4;
			filter4text = StaticText.new(vw, Rect.new(tempW+50,tempH, 100,50 ));
			filter4text.string = "FILTER 4";
			filter4text.stringColor = Color.white;

			filter4PUM = EZPopUpMenu.new(vw, Rect(tempW+22, tempH+35, 200, 30),
				"Type:").setColors(stringColor:Color.white);
			//INSERT FILTER POPUP MENU FUNCTIONS HERE
			filter4PUM.addItem("HighPass",{~filter2_noise_type = 3;~filters_noise_creation.value;});
			filter4PUM.addItem("LowPass",{~filter2_noise_type = 4; ~filters_noise_creation.value;});

			knobCut4= EZKnob.new(vw, Rect(tempW+50, tempH+100, 90, 90), "CutOff", initVal:
				0.25).setColors(stringColor:Color.white);
			knobCut4.controlSpec.minval = 20;
			knobCut4.controlSpec.maxval = 20000;
			knobCut4.value = 10000;
			knobCut4.action = ({arg me; j.set(\cutoff2, me.value.postln;) });

			knobRes4= EZKnob.new(vw, Rect(tempW+150, tempH+100, 90, 90), "Res", initVal:
				0.25).setColors(stringColor:Color.white);
			knobRes4.controlSpec.minval = 0;
			knobRes4.controlSpec.maxval = 1;
			knobRes4.action = ({arg me; j.set(\res2, me.value.postln;) });

			//ON/OFF Button FOR FILTER 4
			filter4OnOff = Button.new(vw, Rect(tempW+235, tempH+20,
					45,45)).states_([
					["", Color.clear, Color.new255(100, 100, 100)],
					["", Color.clear, Color.new255(120, 120, 120)]
				]).icon_(offIcon)
				.action_({ arg butt;
					//TODO:find a way to know which button was pressed
					if(butt.value==1,{
						butt.icon_(onIcon);
					    ~filter2_noise_on=true;
					    ~filters_noise_creation.value;
					},{
						butt.icon_(offIcon);
					    ~filter2_noise_on=false;
					    ~filters_noise_creation.value;
					});
					filter4OnOff.value(i);
				});
			/*
			filter4OnOff = EZKnob.new(vw, Rect(tempW+225, tempH+65, 90, 90), "Dry/Wet", initVal:
				1).setColors(stringColor:Color.white);
			filter4OnOff.numberView.visible_(false); //hide the box showing the number.
			//the numberView variable was found by directly inspecting the EZKnob source code
			filter4OnOff.action = ({arg me; me.value.postln; });
			*/
			//tb_menu.setColors(stringColor:Color.white);
	})}, //end case currentScreen==0
	1, {
		seqView.visible_(false);
		fxView.visible_(true);
		ivCredits.visible_(false);
		if(hasDrawn[1]==false,{
			hasDrawn[1]=true;
			tempW = (vw.bounds.width/3 + 50);
			tempW = vw.bounds.width - (tempW+(vw.bounds.width/2));
			tempH = (vw.bounds.height/5 + 50);

			//the GUI will be something like
			// | on/off button | effect menu | switch button |
			//for each effect
			for(0,numEffects-1,{arg i;
				fx[i] = EZPopUpMenu.new(vw, Rect(tempW-37, tempH+(45*i), 237,
					45),//these looks like random values but believe me
				//they ensure the effect choice fills the void between
				//the two buttons
					"").setColors(stringColor:Color.white);

				fx[i].addItem("Bitcrusher",{arg me;
					if(fx_params[i].at(\type)!="BitCrusher",{
						//if you're changing effect in the currently
						//selected FX slot you normally
						//wouldn't be able to delete the knobs/whatever
						//the other FX was using in its GUI
						if(i==currFX,
							{		hideEffects.value(fx_params[currFX].at(\type));}
						);
						//clear the parameters
						fx_params[i].clear;
						//add all BitCrusher parameters
						fx_params[i].put(\type,"BitCrusher");
						//(maximum) sample rate and bits
						fx_params[i].put(\sr,Server.default.sampleRate);
						fx_params[i].put(\bits,32);

						if(i == 0, {~fx1_type=1;~effects_creation.value;});
						if(i == 1, {~fx2_type=1;~effects_creation.value;});
						if(i == 2, {~fx3_type=1;~effects_creation.value;});
						if(i == 3, {~fx4_type=1;~effects_creation.value;});
						if(i == 4, {~fx5_type=1;~effects_creation.value;});

						//for the same reason as above, this needs to be
						//called to cover for the case where you're
						//changing FX but not FX slot
						if(i==currFX,
					{showEffects.value(fx_params[currFX].at(\type));}
						);
					});
					//"non fa mai male"
				    fxView.refresh;

					me.value.postln;

				}
				);
				fx[i].addItem("Comp",{arg me;
					if(fx_params[i].at(\type)!="Comp",{
						//clear the parameters
						if(i==currFX,
					{hideEffects.value(fx_params[currFX].at(\type));}
						);
						fx_params[i].clear;
						//add all parameters
						fx_params[i].put(\type,"Comp");
						//https://doc.sccode.org/Classes/Compander.html
						//threshold
						fx_params[i].put(\thresh,1);
						//ratio x:1 (slopeAbove)
						fx_params[i].put(\ratio,1);
						//gain (mul)
						fx_params[i].put(\gain, 1);
						//attack (clampTime)
						fx_params[i].put(\atk, 0.15);
						//release (relaxTime)
						fx_params[i].put(\rel, 0.15);

						if(i == 0, {~fx1_type=3;~effects_creation.value;});
						if(i == 1, {~fx2_type=3;~effects_creation.value;});
						if(i == 2, {~fx3_type=3;~effects_creation.value;});
						if(i == 3, {~fx4_type=3;~effects_creation.value;});
						if(i == 4, {~fx5_type=3;~effects_creation.value;});

						if(i==currFX,
					{showEffects.value(fx_params[currFX].at(\type));}
						);
					});
					fxView.refresh;
					me.value.postln;});
				fx[i].addItem("Distortion",{arg me;
					if(fx_params[i].at(\type)!="Distortion",{
						if(i==currFX,
					{hideEffects.value(fx_params[currFX].at(\type));}
						);
						//we can use
			//https://doc.sccode.org/Classes/AnalogVintageDistortion.html
						//clear the parameters
						fx_params[i].clear;
						//add all BitCrusher parameters
						fx_params[i].put(\type,"Distortion");
						//(maximum) sample rate and bits
						fx_params[i].put(\pre,1);
						fx_params[i].put(\post,1);
						fx_params[i].put(\dist,1);

						if(i == 0, {~fx1_type=4;~effects_creation.value;});
						if(i == 1, {~fx2_type=4;~effects_creation.value;});
						if(i == 2, {~fx3_type=4;~effects_creation.value;});
						if(i == 3, {~fx4_type=4;~effects_creation.value;});
						if(i == 4, {~fx5_type=4;~effects_creation.value;});

						if(i==currFX,
					{showEffects.value(fx_params[currFX].at(\type));}
						);
					});
					fxView.refresh;
					me.value.postln;});
				/*
				//actually doesn't inlcude implemented EQ
				//LIKE A BOSS
				fx[i].addItem("EQ",{arg me;
					if(fx_params[i].at(\type)!="EQ",{
						if(i==currFX,
					{hideEffects.value(fx_params[currFX].at(\type));}
						);
						//clear the parameters
						fx_params[i].clear;
						//add all EQ parameters
						fx_params[i].put(\type,"EQ");
						//just put the 4 peaks locations
						fx_params[i].put(\freq1,100);
						fx_params[i].put(\freq2,2000);
						fx_params[i].put(\freq3,8000);
						fx_params[i].put(\freq4,16000);
						//and their attenuations
						fx_params[i].put(\gain1,1);
						fx_params[i].put(\gain2,1);
						fx_params[i].put(\gain3,1);
						fx_params[i].put(\gain4,1);
						//it would be epic to see a waveform behind the EQ
						if(i==currFX,
					{showEffects.value(fx_params[currFX].at(\type));}
						);
					});
					fxView.refresh;
					me.value.postln;});
				*/

				fx[i].addItem("Reverb",{arg me;
					if(fx_params[i].at(\type)!="Reverb",{
						if(i==currFX,
					{hideEffects.value(fx_params[currFX].at(\type));}
						);
						//clear the parameters
						fx_params[i].clear;
						//add all EQ parameters
						fx_params[i].put(\type,"Reverb");
						//just put the 4 peaks locations
						fx_params[i].put(\size,0.5);
						//and their attenuations
						//fx_params[i].put(\decay,3);
						//fx_params[i].put(\spread,50);
						fx_params[i].put(\damp,0.5);
						fx_params[i].put(\dry,0.5);
						//fx_params[i].put(\earlyref,0.5);
						//fx_params[i].put(\tail,0.5);
						//it would be epic to see a waveform behind the EQ
						if(i == 0, {~fx1_type=2;~effects_creation.value;});
						if(i == 1, {~fx2_type=2;~effects_creation.value;});
						if(i == 2, {~fx3_type=2;~effects_creation.value;});
						if(i == 3, {~fx4_type=2;~effects_creation.value;});
						if(i == 4, {~fx5_type=2;~effects_creation.value;});

						if(i==currFX,
					{showEffects.value(fx_params[currFX].at(\type));}
						);
					});
					fxView.refresh;
					me.value.postln;});

				fx[i].postln;
				//all effects will initially be BitCrushers
				//initialise them to avoid errors
				fx_params[i].put(\type,"BitCrusher");
				fx_params[i].put(\sr,Server.default.sampleRate);
				fx_params[i].put(\bits,32);


				fx_on_off_buttons[i] = Button.new(vw, Rect(tempW, tempH+(45*i),
					45,45)).states_([
					["", Color.clear, Color.new255(100, 100, 100)],
					["", Color.clear, Color.new255(120, 120, 120)]
				]).icon_(offIcon)
				.action_({ arg butt;
					//TODO:find a way to know which button was pressed
					if(butt.value==1,{
						butt.icon_(onIcon);
						if(i == 0, {~fx1_on=true;~effects_creation.value;});
						if(i == 1, {~fx2_on=true;~effects_creation.value;});
						if(i == 2, {~fx3_on=true;~effects_creation.value;});
						if(i == 3, {~fx4_on=true;~effects_creation.value;});
						if(i == 4, {~fx5_on=true;~effects_creation.value;});
					},{
						butt.icon_(offIcon);
						if(i == 0, {~fx1_on=false;~effects_creation.value;});
						if(i == 1, {~fx2_on=false;~effects_creation.value;});
						if(i == 2, {~fx3_on=false;~effects_creation.value;});
						if(i == 3, {~fx4_on=false;~effects_creation.value;});
						if(i == 4, {~fx5_on=false;~effects_creation.value;});
					});
					fxOnOffButtonPressed.value(i);
				});

				fx_switch_buttons[i] = Button.new(vw, Rect(tempW+200, tempH+(45*i),
					45,45)).states_([
					["", Color.new255(255, 255, 255), Color.new255(60,60,60)],
					["", Color.new255(255, 255, 255), Color.new255(60,60,60)]
				]).icon_(offIcon)
				.action_({ arg butt;
					//TODO:find a way to know which button was pressed
					if(butt.value==1,{
						butt.icon_(onIcon);
					},{
						butt.icon_(offIcon);
					});
					fxSwitchButtonPressed.value(i);
				});

			});//end for
			fx_switch_buttons[currFX].icon_(onIcon);

			textFXOnOff = StaticText.new(vw,
				Rect.new(tempW-25,tempH + (numEffects*45) + 45,
					100,50 ));
			textFXOnOff.align = \center;
			textFXOnOff.string = "FX\nON/OFF";
			textFXOnOff.stringColor = Color.white;

			textFXChoice = StaticText.new(vw,
				Rect.new(tempW+75,tempH + (numEffects*45) + 90,
					100,50 ));
			textFXChoice.align = \center;
			textFXChoice.string = "FX\nTYPE";
			textFXChoice.stringColor = Color.white;

			textFXSwitch = StaticText.new(vw,
				Rect.new(tempW+175,tempH + (numEffects*45) + 135,
					100,50 ));
			textFXSwitch.align = \center;
			textFXSwitch.string = "TWEAK\nFX";
			textFXSwitch.stringColor = Color.white;


			//VARIOUS KNOBS FOR EFFECTS
			//COMPRESSOR
			tempW = 100;
			tempH = fxView.bounds.height-150;


			knobCompTHR = EZKnob.new(fxView, Rect(tempW, tempH, 90, 90), "Threshold", initVal:
				0.25).setColors(stringColor:Color.white);
			knobCompTHR.controlSpec.minval = 0;
			knobCompTHR.controlSpec.maxval = 1;
			knobCompTHR.action = ({arg me; fx_params[currFX].put(\thresh, me.value);
				if(currFX == 0, {q.set(\thresh, me.value);});
				if(currFX == 1, {z.set(\thresh, me.value)});
				if(currFX == 2, {v.set(\thresh, me.value)});
				if(currFX == 3, {r.set(\thresh, me.value)});
				if(currFX == 4, {l.set(\thresh, me.value)});
				fxView.refresh;//refresh the view to see graphical updates
			});

			knobCompRAT = EZKnob.new(fxView, Rect(tempW+100, tempH, 90, 90), "Ratio", initVal:
				0.25).setColors(stringColor:Color.white);
			knobCompRAT.controlSpec.maxval = 1.5;
			knobCompRAT.controlSpec.minval = 0.05; //20x less loud than original
			knobCompRAT.action = ({arg me; fx_params[currFX].put(\ratio, me.value);
				if(currFX == 0, {q.set(\ratio, me.value)});
				if(currFX == 1, {z.set(\ratio, me.value)});
				if(currFX == 2, {v.set(\ratio, me.value)});
				if(currFX == 3, {r.set(\ratio, me.value)});
				if(currFX == 4, {l.set(\ratio, me.value)});
				fxView.refresh});

			knobCompGAIN= EZKnob.new(fxView, Rect(tempW+200, tempH, 90, 90), "Gain", initVal:
				1).setColors(stringColor:Color.white);
			knobCompGAIN.controlSpec.minval = 0;
			knobCompGAIN.controlSpec.maxval = 2;
			knobCompGAIN.action = ({arg me; fx_params[currFX].put(\gain, me.value);
				if(currFX == 0, {q.set(\gain, me.value)});
				if(currFX == 1, {z.set(\gain, me.value)});
				if(currFX == 2, {v.set(\gain, me.value)});
				if(currFX == 3, {r.set(\gain, me.value)});
				if(currFX == 4, {l.set(\gain, me.value)});
				fxView.refresh});

			knobCompATK= EZKnob.new(fxView, Rect(tempW+300, tempH, 90, 90), "ATK", initVal:
				0.25).setColors(stringColor:Color.white);
			knobCompATK.controlSpec.minval = 0;
			knobCompATK.controlSpec.maxval = 2;
			knobCompATK.action = ({arg me; fx_params[currFX].put(\atk, me.value);
				if(currFX == 0, {q.set(\atk, me.value)});
				if(currFX == 1, {z.set(\atk, me.value)});
				if(currFX == 2, {v.set(\atk, me.value)});
				if(currFX == 3, {r.set(\atk, me.value)});
				if(currFX == 4, {l.set(\atk, me.value)});
				fxView.refresh;});

			knobCompREL= EZKnob.new(fxView, Rect(tempW+400, tempH, 90, 90), "REL", initVal:
				0.25).setColors(stringColor:Color.white);
			knobCompREL.controlSpec.minval = 0;
			knobCompREL.controlSpec.maxval = 2;
			knobCompREL.action = ({arg me; fx_params[currFX].put(\rel, me.value);
				if(currFX == 0, {q.set(\rel, me.value)});
				if(currFX == 1, {z.set(\rel, me.value)});
				if(currFX == 2, {v.set(\rel, me.value)});
				if(currFX == 3, {r.set(\rel, me.value)});
				if(currFX == 4, {l.set(\rel, me.value)});
				fxView.refresh;});
			hideEffects.value("Comp");

			//DISTORTION
			knobDistPRE = EZKnob.new(fxView, Rect(tempW, tempH, 90, 90), "PRE", initVal:
				1).setColors(stringColor:Color.white);
			knobDistPRE.controlSpec.minval = 0;
			knobDistPRE.controlSpec.maxval = 2;
			knobDistPRE.action = ({arg me; fx_params[currFX].put(\pre, me.value);
				if(currFX == 0, {q.set(\amp, me.value)});
				if(currFX == 1, {z.set(\amp, me.value)});
				if(currFX == 2, {v.set(\amp, me.value)});
				if(currFX == 3, {r.set(\amp, me.value)});
				if(currFX == 4, {l.set(\amp, me.value)});
				fxView.refresh;});

			knobDistDIST = EZKnob.new(fxView, Rect(tempW+150, tempH, 90, 90), "DIST", initVal:
				0.25).setColors(stringColor:Color.white);
			knobDistDIST.action = ({arg me; fx_params[currFX].put(\dist, me.value);
				if(currFX == 0, {q.set(\dist, me.value)});
				if(currFX == 1, {z.set(\dist, me.value)});
				if(currFX == 2, {v.set(\dist, me.value)});
				if(currFX == 3, {r.set(\dist, me.value)});
				if(currFX == 4, {l.set(\dist, me.value)});
				fxView.refresh;});

			knobDistPOST = EZKnob.new(fxView, Rect(tempW+300, tempH, 90, 90), "POST", initVal:
				1).setColors(stringColor:Color.white);
			knobDistPOST.controlSpec.minval = 0;
			knobDistPOST.controlSpec.maxval = 2;
			knobDistPOST.action = ({arg me; fx_params[currFX].put(\post, me.value);
				if(currFX == 0, {q.set(\post, me.value)});
				if(currFX == 1, {z.set(\post, me.value)});
				if(currFX == 2, {v.set(\post, me.value)});
				if(currFX == 3, {r.set(\post, me.value)});
				if(currFX == 4, {l.set(\post, me.value)});
				fxView.refresh;});
            hideEffects.value("Distortion");


			//REVERB
			knobVerbSize = EZKnob.new(fxView, Rect(tempW+10, tempH-100, 90, 90), "Size",
				initVal:150).setColors(stringColor:Color.white);
			knobVerbSize.controlSpec.minval = 0;
			knobVerbSize.controlSpec.maxval = 1;
			knobVerbSize.value = 0.5;
			knobVerbSize.action = ({arg me; fx_params[currFX].put(\size, me.value);
				if(currFX == 0, {q.set(\size, me.value)});
				if(currFX == 1, {z.set(\size, me.value)});
				if(currFX == 2, {v.set(\size, me.value)});
				if(currFX == 3, {r.set(\size, me.value)});
				if(currFX == 4, {l.set(\size, me.value)});
				fxView.refresh;});

			/* These could be used in future for a more complex reverb implementation
			knobVerbDecay = EZKnob.new(fxView, Rect(tempW+110, tempH-100, 90, 90), "Decay", initVal:
				3).setColors(stringColor:Color.white);
			knobVerbDecay.controlSpec.minval = 0;
			knobVerbDecay.controlSpec.maxval = 30;
			knobVerbDecay.value = 3;
			knobVerbDecay.action = ({arg me; fx_params[currFX].put(\decay, me.value);
				/*if(currFX == 0, {q.set(\decay, me.value)});
				if(currFX == 1, {z.set(\decay, me.value)});
				if(currFX == 2, {v.set(\decay, me.value)});
				if(currFX == 3, {r.set(\decay, me.value)});
				if(currFX == 4, {l.set(\decay, me.value)});*/
				fxView.refresh;});
*/
			/*
			knobVerbSpread = EZKnob.new(fxView, Rect(tempW+210, tempH-100, 90, 90), "Spread", initVal:
				50).setColors(stringColor:Color.white);
			knobVerbSpread.controlSpec.minval = 0;
			knobVerbSpread.controlSpec.maxval = 100;
			knobVerbSpread.value = 50;
			knobVerbSpread.action = ({arg me; fx_params[currFX].put(\spread, me.value);
				/*if(currFX == 0, {q.set(\spread, me.value)});
				if(currFX == 1, {z.set(\spread, me.value)});
				if(currFX == 2, {v.set(\spread, me.value)});
				if(currFX == 3, {r.set(\spread, me.value)});
				if(currFX == 4, {l.set(\spread, me.value)});*/
				fxView.refresh;});
*/
			knobVerbDamp = EZKnob.new(fxView, Rect(tempW+160, tempH-100, 90, 90), "Damp", initVal:
				1).setColors(stringColor:Color.white);
			knobVerbDamp.controlSpec.minval = 0;
			knobVerbDamp.controlSpec.maxval = 1;
			knobVerbDamp.value = 0.5;
			knobVerbDamp.action = ({arg me; fx_params[currFX].put(\damp, me.value);
				if(currFX == 0, {q.set(\damp, me.value)});
				if(currFX == 1, {z.set(\damp, me.value)});
				if(currFX == 2, {v.set(\damp, me.value)});
				if(currFX == 3, {r.set(\damp, me.value)});
				if(currFX == 4, {l.set(\damp, me.value)});
				fxView.refresh;});

			knobVerbDry = EZKnob.new(fxView, Rect(tempW+310, tempH-100, 90, 90), "Dry", initVal:
				1).setColors(stringColor:Color.white);
			knobVerbDry.controlSpec.minval = 0;
			knobVerbDry.controlSpec.maxval = 1;
			knobVerbDry.value = 0.5;
			knobVerbDry.action = ({arg me; fx_params[currFX].put(\dry, me.value);
				if(currFX == 0, {q.set(\drylevel, me.value)});
				if(currFX == 1, {z.set(\drylevel, me.value)});
				if(currFX == 2, {v.set(\drylevel, me.value)});
				if(currFX == 3, {r.set(\drylevel, me.value)});
				if(currFX == 4, {l.set(\drylevel, me.value)});
				fxView.refresh;});
/*
			knobVerbEarlyRef = EZKnob.new(fxView, Rect(tempW+160, tempH, 90, 90), "Early Ref", initVal:
				0.5).setColors(stringColor:Color.white);
			knobVerbEarlyRef.controlSpec.minval = 0;
			knobVerbEarlyRef.controlSpec.maxval = 1;
			knobVerbEarlyRef.value = 0.5;
			knobVerbEarlyRef.action = ({arg me; fx_params[currFX].put(\earlyref, me.value);

				if(currFX == 0, {q.set(\earlyref, me.value)});
				if(currFX == 1, {z.set(\earlyref, me.value)});
				if(currFX == 2, {v.set(\earlyref, me.value)});
				if(currFX == 3, {r.set(\earlyref, me.value)});
				if(currFX == 4, {l.set(\earlyref, me.value)});
				fxView.refresh;});
*/
			/*
			knobVerbTail = EZKnob.new(fxView, Rect(tempW+260, tempH, 90, 90), "Tail", initVal:
				0.5).setColors(stringColor:Color.white);
			knobVerbTail.controlSpec.minval = 0;
			knobVerbTail.controlSpec.maxval = 1;
			knobVerbTail.value = 0.5;
			knobVerbTail.action = ({arg me; fx_params[currFX].put(\tail, me.value);
				if(currFX == 0, {q.set(\tail, me.value)});
				if(currFX == 1, {z.set(\tail, me.value)});
				if(currFX == 2, {v.set(\tail, me.value)});
				if(currFX == 3, {r.set(\tail, me.value)});
				if(currFX == 4, {l.set(\tail, me.value)});
				fxView.refresh;});
			*/
			hideEffects.value("Reverb");


			//remember the fx tab always starts with the bitcrusher as its
			//default effect. Create the texts and display them
			//x axis text
			bitCrusherText1 = StaticText.new(fxView, Rect.new((fxView.bounds.width/2)-75,fxView.bounds.height-45, 150,50 ));
			bitCrusherText1.align_(\center);
			bitCrusherText1.string = "Sample Rate";
			bitCrusherText1.stringColor = Color.white;
			//make this one vertical (y axis)
			bitCrusherText2 = StaticText.new(fxView, Rect.new(15,75, 100,250 ));
			bitCrusherText2.string = "B \ni \nt \n \nD \ne \np \nt \nh";
			bitCrusherText2.stringColor = Color.white;
			//this should already be visible, but just in case
			bitCrusherText1.visible_(true);
			bitCrusherText2.visible_(true);
		});
	},2,{
	//sequencer
		seqView.visible_(true);
		fxView.visible_(false);
		ivCredits.visible_(false);
		//make a view for the sequencer lol
		if(hasDrawn[2]==false,
			{
				hasDrawn[2]=true;
				seqToolbar = ToolBar(
					MenuAction("").icon_(iconPencil).action_({
						currTool = 0;
					}),
					MenuAction("").icon_(iconDur).action_({
						currTool = 1;
					}),
					MenuAction("").icon_(iconDel).action_({
						currTool = 2;
					})
				);
				tempH = vw.bounds.height/5;
				seqToolbar.setParent(vw);
				seqToolbar.bounds =
				Rect.new(vw.bounds.width/2 - 53, tempH+5,106, 30);
				seqToolbar.visible_(true);

				octToolbar = ToolBar(
					MenuAction("").icon_(iconOctDown).action_({
						if(currentOctave > 1, {
							currentOctave = currentOctave -1;
							currentOctaveText.string = "C"++currentOctave;
						}
						)
					}),
					MenuAction("").icon_(iconOctUp).action_({
						if(currentOctave <7, {
							currentOctave = currentOctave + 1;
							currentOctaveText.string = "C"++currentOctave;
						}
						)
					})
				);
				octToolbar.setParent(vw);
				octToolbar.bounds = Rect.new(100, vw.bounds.height-45,106, 30);
				octToolbar.visible_(true);

			currentOctaveText = StaticText.new(seqView, Rect.new(25,seqView.bounds.height-45, 150,50 ));
			currentOctaveText.string = "C"++currentOctave;
			currentOctaveText.stringColor = Color.black;
				currentOctaveText.visible_(true);

			seqPlayStopToolbar = ToolBar(
					MenuAction("").icon_(iconPlaySEQ).action_({
						if(seqIsPlaying == false,{

						var noteSequence;
						var ampS;
						var ampPu;
						var ampT;
						var ampW;
						var ampB;
						var ampPi;

						var allDur = Array.fill(12, {arg i; i=[
							0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,
							0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,
							0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,
							0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25
						];});

						var allAmp = Array.fill(12, {arg i; i=[
							0,0,0,0,0,0,0,0,
							0,0,0,0,0,0,0,0,
							0,0,0,0,0,0,0,0,
							0,0,0,0,0,0,0,0
						];});
						seqIsPlaying = true;
						~seqPbind = Array.fill(12,{});
						~seqPbind2 = Array.fill(12,{});
						noteSequence = notesToSeq.value;


						for(0,31,{arg i;
								if(noteSequence[i] != nil,{
								if(noteSequence[i] != -1,{
								var note_seq =  noteSequence[i][0][0];
								var loca_seq =  noteSequence[i][0][1];
								var dura_seq = noteSequence[i][0][2];
									if (note_seq == 0, {allAmp[note_seq][loca_seq] = dura_seq;});
									if (note_seq == 1, {allAmp[note_seq][loca_seq] = dura_seq;});
									if (note_seq == 2, {allAmp[note_seq][loca_seq] = dura_seq;});
									if (note_seq == 3, {allAmp[note_seq][loca_seq] = dura_seq;});
									if (note_seq == 4, {allAmp[note_seq][loca_seq] = dura_seq;});
									if (note_seq == 5, {allAmp[note_seq][loca_seq] = dura_seq;});
									if (note_seq == 6, {allAmp[note_seq][loca_seq] = dura_seq;});
									if (note_seq == 7, {allAmp[note_seq][loca_seq] = dura_seq;});
									if (note_seq == 8, {allAmp[note_seq][loca_seq] = dura_seq;});
									if (note_seq == 9, {allAmp[note_seq][loca_seq] = dura_seq;});
									if (note_seq == 10, {allAmp[note_seq][loca_seq] = dura_seq;});
									if (note_seq == 11, {allAmp[note_seq][loca_seq] = dura_seq;});
								});
								});
							});

						for(0,11,{arg i;
							var wholeDur = allDur[i];
							var wholeAmp = allAmp[i];

							for(0,31,{arg i;
								var currAmp = wholeAmp[i];
								if(currAmp == 1, {wholeAmp[i] = 1});
								if(currAmp > 1,{
									wholeDur[i] = currAmp*0.25;
									wholeAmp[i] = 1;

									for(i+1,i+currAmp-1,{arg k;
										wholeDur[k] = 0;
									});
									i = i + currAmp;
								});
							});
							allDur[i] = wholeDur;
							allAmp[i] = wholeAmp;
						});



						if(~osc_type == 1,{ampS = 1; ampPu = 0; ampT = 0;});
						if(~osc_type == 2,{ampS = 0; ampPu = 1; ampT = 0;});
						if(~osc_type == 3,{ampS = 0; ampPu = 0; ampT = 1;});

						if(~noise_type == 1,{ampW = 0; ampB = 1; ampPi = 0;});
						if(~noise_type == 2,{ampW = 0; ampB = 0; ampPi = 1;});
						if(~noise_type == 3,{ampW = 1; ampB = 0; ampPi = 0;});

						if(~timbre_osc_type == 0,{
							for(0,11,{arg i;
								~seqPbind[i] = Pbind(\instrument, \dummyEnv,
									\group ,u,
									\att, knobA1.value,
									\sus, Pseq(allDur[i],inf),
									\rel, knobR1.value,
									\out, ~output_bus_timbre_osc,
									\dur, Pseq(allDur[i],inf),
									\amp, Pseq(allAmp[i],inf),
									\midinote, Pseq([12+i+(12*currentOctave)], inf),
									\ampSaw, ampS,
									\ampPul, ampPu,
									\ampTri, ampT,
									\ampWhi,0,
									\ampBro,0,
									\ampPin,0
								).play;
							});
						});

						if(~timbre_osc_type == 1,{
							for(0,11,{arg i;
								~seqPbind[i] = Pbind(\instrument, \panOsc,
									\group ,u,
									\att, knobA1.value,
									\sus, Pseq(allDur[i],inf),
									\rel, knobR1.value,
									\out, ~output_bus_timbre_osc,
									\dur, Pseq(allDur[i],inf),
									\amp, Pseq(allAmp[i],inf),
									\midinote, Pseq([12+i+(12*currentOctave)], inf),
									\ampSaw, ampS,
									\ampPul, ampPu,
									\ampTri, ampT,
									\ampWhi,0,
									\ampBro,0,
									\ampPin,0
								).play;
							});
						});

						if(~timbre_osc_type == 2,{
							for(0,11,{arg i;
								~seqPbind[i] = Pbind(\instrument, \brassOsc,
									\group ,u,
									\att, knobA1.value,
									\sus, Pseq(allDur[i],inf),
									\rel, knobR1.value,
									\out, ~output_bus_timbre_osc,
									\dur, Pseq(allDur[i],inf),
									\amp, Pseq(allAmp[i],inf),
									\midinote, Pseq([12+i+(12*currentOctave)], inf),
									\ampSaw, ampS,
									\ampPul, ampPu,
									\ampTri, ampT,
									\ampWhi,0,
									\ampBro,0,
									\ampPin,0
								).play;
							});
						});

						if(~timbre_noise_type == 0,{
							for(0,11,{arg i;
								~seqPbind2[i] = Pbind(\instrument, \dummyEnv,
									\group ,u,
									\att ,knobA2.value,
									\sus, Pseq(allDur[i],inf),
									\rel, knobR2.value,
									\out, ~output_bus_timbre_noise,
									\dur, Pseq(allDur[i],inf),
									\amp, Pseq(allAmp[i],inf),
									\ampSaw, 0,
									\ampPul, 0,
									\ampTri, 0,
									\ampWhi,ampW,
									\ampBro,ampB,
									\ampPin,ampPi
								).play;
							});
						});

						if(~timbre_noise_type == 1,{
							for(0,11,{arg i;
								~seqPbind2[i] = Pbind(\instrument, \panNoise,
									\group ,u,
									\att, knobA2.value,
									\sus, Pseq(allDur[i],inf),
									\rel, knobR2.value,
									\out, ~output_bus_timbre_noise,
									\dur, Pseq(allDur[i],inf),
									\amp, Pseq(allAmp[i],inf),
									\ampSaw, 0,
									\ampPul, 0,
									\ampTri, 0,
									\ampWhi,ampW,
									\ampBro,ampB,
									\ampPin,ampPi
								).play;
							});
						});

						if(~timbre_noise_type == 2,{
							for(0,11,{arg i;
								~seqPbind2[i] = Pbind(\instrument, \brassNoise,
									\group ,u,
									\att, knobA2.value,
									\sus, Pseq(allDur[i],inf),
									\rel, knobR2.value,
									\out, ~output_bus_timbre_noise,
									\dur, Pseq(allDur[i],inf),
									\amp, Pseq(allAmp[i],inf),
									\ampSaw, 0,
									\ampPul, 0,
									\ampTri, 0,
									\ampWhi,ampW,
									\ampBro,ampB,
									\ampPin,ampPi
								).play;
							});
						});

						});
					}),
					MenuAction("").icon_(iconStopSEQ).action_({

						if(seqIsPlaying == true,{
							for(0,11,{arg i;
							~seqPbind[i].stop;
							~seqPbind2[i].stop;
						});
							seqIsPlaying = false;
						});


					})
				);
				seqPlayStopToolbar.setParent(vw);
				seqPlayStopToolbar.bounds = Rect.new(vw.bounds.width - 170, vw.bounds.height-45,106, 30);
				seqPlayStopToolbar.visible_(true);

		});
		currentOctaveText.string = "C"++currentOctave;
	},3,{
		//credits
		seqView.visible_(false);
		fxView.visible_(false);
		ivCredits.visible_(true);
		if(hasDrawn[3]==false,
			{
				hasDrawn[3]=true;
		});
	}
	);

}; //end changeWind()

//this is the best way i found to handle different buttons
//i probably should have thought about this sooner than half project in...
var fxOnOffButtonPressed = {
	arg buttonID;
	//TODO: BUS CONTROL STUFF HERE
};
var fxSwitchButtonPressed = {
	arg buttonID;
	//disable all buttons

	for(0,numEffects-1,{arg i;
		fx_switch_buttons[i].icon_(offIcon);
	});
	fx_switch_buttons[buttonID].icon_(onIcon);
	hideEffects.value(fx_params[currFX].at(\type));
	prevFX = currFX;
	currFX = buttonID;
	showEffects.value(fx_params[currFX].at(\type));
	fxView.refresh;
	//TODO: call something to show the plugin controls here (if needed)
};

var hidePart = { arg part=0; //0 = synth, 1 = effects, 2 = seq, 3 = credits
	switch(part, 0, {
		//hide texts
		[osc1text,osc2text].do({arg item, i; item.visible_(false)});
		//hide ADSR knobs
		[knobA1,knobS1,knobR1].do({arg item, i; item.visible_(false)});
		[knobA2,knobS2,knobR2].do({arg item, i; item.visible_(false)});
		//hide popup menus
		[osc1PUM,osc2PUM].do({arg item, i; item.visible_(false)});

		//hide filters
		//hide filter texts
		[filter1text,filter2text,filter3text,filter4text].do({arg item, i; item.visible_(false)});
		//hide filter knobs
		[knobCut1,knobCut2,knobCut3,knobCut4,knobRes1,knobRes2,knobRes3,knobRes4].do({arg item, i;
			item.visible_(false)});
		//hide filter popup menus
		[filter1PUM,filter2PUM,filter3PUM,filter4PUM].do({arg item, i; item.visible_(false)});
		[filter1OnOff,filter2OnOff,filter3OnOff,filter4OnOff].do({arg item, i; item.visible_(false)});
		//hide preset selection toolbars
		tb_menu_presets_synth.visible_(false);
		tb_menu_presets_noise.visible_(false);
		synth_presets_label.visible_(false);
		noise_presets_label.visible_(false);
	}, 1,{
		//hide effects
		for(0,numEffects-1,{arg i;
			fx[i].visible_(false); //this needs to be treated like this because of how we define them
		//before...We weren't able to define them using a do because it would have acted on a copy
		fx_switch_buttons[i].visible_(false);
		fx_on_off_buttons[i].visible_(false);});

		[textFXOnOff,textFXChoice,textFXSwitch].do({arg item, i;
			item.visible_(false)});//<- this works with no issues whatsoever
		//though... Don't ask me
		hideEffects.value(fx_params[currFX].at(\type));
	},2,{
		seqToolbar.visible_(false);
		octToolbar.visible_(false);
		currentOctaveText.visible_(false);
		seqPlayStopToolbar.visible_(false);
	},3,{});
};//end hidePart()

var showPart = { arg part;
	switch(part, 0, {
		~freqScope.visible_(true);
		//show texts
		[osc1text,osc2text].do({arg item, i; item.visible_(true)});
		//show ADSR
		[knobA1,knobS1,knobR1].do({arg item, i; item.visible_(true)});
		[knobA2,knobS2,knobR2].do({arg item, i; item.visible_(true)});
		//show popup menus
		[osc1PUM,osc2PUM].do({arg item, i; item.visible_(true)});

		//show filters
		//show filter texts
		[filter1text,filter2text,filter3text,filter4text].do({arg item, i; item.visible_(true)});
		//show filter knobs
		[knobCut1,knobCut2,knobCut3,knobCut4,knobRes1,knobRes2,knobRes3,knobRes4].do({arg item, i;
			item.visible_(true)});
		//show filter popup menus
		[filter1PUM,filter2PUM,filter3PUM,filter4PUM].do({arg item, i; item.visible_(true)});
		[filter1OnOff,filter2OnOff,filter3OnOff,filter4OnOff].do({arg item, i; item.visible_(true)});
		//show preset selection toolbars
		tb_menu_presets_synth.visible_(true);
		tb_menu_presets_noise.visible_(true);
		synth_presets_label.visible_(true);
		noise_presets_label.visible_(true);
	}, 1,{
		//show effects
		~freqScope.visible_(true);
		~freqScope.active_(true);
		for(0,numEffects-1,{arg i;
			fx[i].visible_(true);
			fx_switch_buttons[i].visible_(true);
			fx_on_off_buttons[i].visible_(true);
		});
		[textFXOnOff,textFXChoice,textFXSwitch].do({arg item, i; item.visible_(true)});
		showEffects.value(fx_params[currFX].at(\type));
	},2,{
		~freqScope.visible_(true);
		//for some reason, despite having done this
		//so far, if we call visible on seqToolbar
		//and it hasn't been created yet we get a error
		if(hasDrawn[2]==true,
			{seqToolbar.visible_(true);
			octToolbar.visible_(true);
			currentOctaveText.visible_(true);
			seqPlayStopToolbar.visible_(true);
		});

	},3,{
		~freqScope.visible_(true);

	});
};//end showpart

var hideEffects = {arg prevFX;
switch(prevFX,
			"BitCrusher",{
			//hide the axes labels
				bitCrusherText1.visible_(false);
			    bitCrusherText2.visible_(false);
			},
			"Comp",{
			[knobCompATK,knobCompREL,knobCompTHR, knobCompRAT,knobCompGAIN].do({arg item,i;
				item.visible_(false);});
			},
			"Distortion",{
			[knobDistPRE,knobDistPOST,knobDistDIST].do({arg item,i;
				item.visible_(false);});
			},
			"EQ",{
			},
		"Reverb",{
			//[knobVerbSize, knobVerbDecay, knobVerbSpread, knobVerbDamp, knobVerbDry, knobVerbEarlyRef, knobVerbTail].do({
			[knobVerbSize, knobVerbDamp, knobVerbDry].do({
				arg item, i;
				item.visible_(false);});
		}
		);//end switch
};//end hideEffects
var showEffects  = {arg newFX;
//knobCompATK,knobCompREL,knobCompTHR, knobCompRAT, knobCompGAIN
	switch(newFX,
			"BitCrusher",{
			//Show the axes labels
			    bitCrusherText1.visible_(true);
			    bitCrusherText2.visible_(true);
			},
			"Comp",{
			[knobCompATK,knobCompREL,knobCompTHR, knobCompRAT,knobCompGAIN].do({arg item,i;
				item.visible_(true);});
			knobCompATK.value_(fx_params[currFX].at(\atk));
			knobCompREL.value_(fx_params[currFX].at(\rel));
			knobCompTHR.value_(fx_params[currFX].at(\thresh));
			knobCompRAT.value_(fx_params[currFX].at(\ratio));
			knobCompGAIN.value_(fx_params[currFX].at(\gain));
			},
			"Distortion",{
[knobDistPRE,knobDistPOST,knobDistDIST].do({arg item,i;
				item.visible_(true);});
			knobDistPRE.value_(fx_params[currFX].at(\pre));
			knobDistPOST.value_(fx_params[currFX].at(\post));
			knobDistDIST.value_(fx_params[currFX].at(\dist));
			},
			"EQ",{
			},
		"Reverb",{
			//[knobVerbSize, knobVerbDecay, knobVerbSpread, knobVerbDamp, knobVerbDry, knobVerbEarlyRef, knobVerbTail].do({
			[knobVerbSize, knobVerbDamp, knobVerbDry].do({
				arg item, i;
				item.visible_(true);});
			knobVerbSize.value_(fx_params[currFX].at(\size));
			//knobVerbDecay.value_(fx_params[currFX].at(\decay));
			//knobVerbSpread.value_(fx_params[currFX].at(\spread));
			knobVerbDamp.value_(fx_params[currFX].at(\damp));
			knobVerbDry.value_(fx_params[currFX].at(\dry));
			//knobVerbEarlyRef.value_(fx_params[currFX].at(\earlyref));
			//knobVerbTail.value_(fx_params[currFX].at(\tail));
		}
		);//end switch
};//end showEffects

Window.closeAll;
win = Window.new("BitWinds",Rect.new(0,0,1200,720), resizable:false)
.front; //set resizable to false until we're able to scale the userview with the window

//font stuff
font = Font.new("Kristen ITC",18);
Font.setDefault(font);

//draw the images in the background
//the logo is commented for now until we create a better logo

//show the logo
logoPath = thisProcess.nowExecutingPath.dirname+/+"images/logo.png";
logo = Image.new(logoPath); // add a path to your image
logo.scalesWhenResized = true;
logo.setSize(175,175);

backgroundPath = thisProcess.nowExecutingPath.dirname+/+"images/interface.png";
background = Image.new(backgroundPath);

onIcon = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/icon_on.png");
offIcon = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/icon_off.png");
//yes i didn't keep the same naming system "xxIcon"
iconPencil= Image.new(thisProcess.nowExecutingPath.dirname+/+"images/icon_pencil.png");
iconDur = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/icon_dur.png");
iconDel = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/icon_del.png");

//octaves icons
iconOctUp = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/icon_oct_up.png");
iconOctDown = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/icon_oct_down.png");
//SEQ play stop icons
iconPlaySEQ = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/icon_play_SEQ.png");
iconStopSEQ = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/icon_stop_SEQ.png");

//load effects logos
logoBitcrush = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/logo_bitcrush.png");
logoComp = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/logo_comp.png");
logoVerb = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/logo_reverb.png");
logoDist = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/logo_dist.png");

iconPlay = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/icon_play.png");
iconStop = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/icon_stop.png");

credits = Image.new(thisProcess.nowExecutingPath.dirname+/+"images/credits.png");
//SHOW THE IMAGE ON THE WINDOW
//create a new view to contain the image

iv2 = View.new(win, background.bounds);
iv2.setBackgroundImage(background);
iv = View.new(win, logo.bounds);
iv.setBackgroundImage(logo);
iv.bounds = Rect.new(win.bounds.width - 150,0,150,150);
//now we draw on top of those images
//userview to use Pen
vw = UserView(win, win.bounds);


//make the play/stop toolbar
playStopToolbar = ToolBar(
	MenuAction("", {
		//TODO:PLAY
		if(~first == true, {~first = false;  ~filters_osc_creation.value; ~filters_noise_creation.value; ~effects_creation.value; ~final_mixing_creation.value; ~timbre_creation.value;} ,{~timbre_creation.value;});
		vw.refresh; }).icon_(iconPlay),

	MenuAction("", {


		vw.refresh; }
).icon_(iconStop));
//We will make it visible later, at the end of the drawing part
//in order to not make it hidden

ivCredits = View.new(vw,credits.bounds);
ivCredits.setBackgroundImage(credits);
ivCredits.bounds = Rect.new(vw.bounds.width/4, (vw.bounds.height/5 + 50), 640,400 );
ivCredits.visible_(false);


fx_statuses = Array(numEffects);
numEffects.do({fx_statuses.add(1)});


vw.drawFunc = {
	//uncomment this to set a uniform colored background
	/*
	Pen.fillColor = Color.new255(33,37,43,255);
	Pen.addRect(Rect(0,0, vw.bounds.width,vw.bounds.height));
	Pen.fill;
	*/
	changeWind.value(currentScreen);
	//switch(var, test1, function1, ...)
	Pen.strokeColor = Color.white;
			Pen.moveTo(((vw.bounds.width/2)@
				(0)));
			Pen.lineTo((vw.bounds.width/2)@
				(vw.bounds.height/5));
	Pen.moveTo((0)@(vw.bounds.height/5));
			Pen.lineTo((vw.bounds.width)@(vw.bounds.height/5));
	switch(currentScreen,
		0, {
			//SYNTH
			//make a small line underlining "Synth"
			Pen.strokeColor = Color.white;
			Pen.moveTo(((vw.bounds.width/2 + 7)@
				(125)));
			Pen.lineTo((vw.bounds.width/2+68)@
				(125));



			Pen.strokeColor = Color.white;
			Pen.moveTo((vw.bounds.width/2)@(vw.bounds.height/5));
			Pen.lineTo((vw.bounds.width/2)@(3.5*vw.bounds.height/5));
			Pen.moveTo((0)@(3.5*vw.bounds.height/5));
			Pen.lineTo((vw.bounds.width)@(3.5*vw.bounds.height/5));

			Pen.fillStroke;

			Pen.strokeColor = Color.white;
			Pen.moveTo((vw.bounds.width/4)@(3.5*vw.bounds.height/5));
			Pen.lineTo((vw.bounds.width/4)@(vw.bounds.height));
			Pen.moveTo((2*vw.bounds.width/4)@(3.5*vw.bounds.height/5));
			Pen.lineTo((2*vw.bounds.width/4)@(vw.bounds.height));
			Pen.moveTo((3*vw.bounds.width/4)@(3.5*vw.bounds.height/5));
			Pen.lineTo((3*vw.bounds.width/4)@(vw.bounds.height));

			Pen.fillStroke;
		},
		1, {
			//EFFECTS

			Pen.strokeColor = Color.white;

			Pen.moveTo(((vw.bounds.width/2 + 75)@
				(125)));
			Pen.lineTo((vw.bounds.width/2+155)@
				(125));

			//draw a rectangle that will contain the effect controls
			//this will be vw.bounds.width/2 x 450 pixels
			tempW = (vw.bounds.width/3 + 50);
			tempH = (vw.bounds.height/5 + 50);
			Pen.strokeColor = Color.white;
			Pen.moveTo((tempW)@(tempH));
			Pen.lineTo((tempW)@(tempH + 450));
			Pen.moveTo((tempW)@(tempH + 450));
			Pen.lineTo((tempW+(vw.bounds.width/2))@(tempH+450));
			Pen.moveTo((tempW+(vw.bounds.width/2))@(tempH+450));
			Pen.lineTo((tempW+(vw.bounds.width/2))@(tempH));
			Pen.moveTo((tempW+(vw.bounds.width/2))@(tempH));
			Pen.lineTo((tempW)@(tempH));
			//draw the generic shape containing the effect menu
			//external rectangle:
			tempW = vw.bounds.width - (tempW+(vw.bounds.width/2));

			Pen.moveTo(tempW @ tempH);
			Pen.lineTo((tempW+200)@(tempH));
			Pen.moveTo((tempW+200)@(tempH));
			//extra parentheses because supercollider has its weird way of
			//defining the order of operations
			Pen.lineTo((tempW+200)@(tempH+ (45*(numEffects))));
			Pen.moveTo((tempW+200)@(tempH+ (45*(numEffects))));
			Pen.lineTo((tempW)@(tempH+(45*(numEffects))));
			Pen.moveTo((tempW)@(tempH+(45*(numEffects))));
			Pen.lineTo((tempW)@(tempH));

			//draw a line to make the order of effects clearer ("bus")
			Pen.moveTo(tempW -50 @ tempH);
			Pen.lineTo((tempW -50)@(tempH+(45*(numEffects))));
			//draw a small arrow at the end :)
			Pen.moveTo(tempW-50 @ (tempH+(45*(numEffects))));
			Pen.lineTo(tempW-55 @ (tempH+(45*(numEffects))-10));
			Pen.moveTo(tempW-50 @( tempH+(45*(numEffects))));
			Pen.lineTo(tempW-45 @ (tempH+(45*(numEffects))-10));

			//connect the first slot to the bus visually (didn't want to do this inside the for)
			Pen.moveTo(tempW @ (tempH+(45/2)));
			Pen.lineTo(tempW-50 @ (tempH+(45/2)));
			//draw a small arrow at the end :)
			Pen.moveTo(tempW-50 @ (tempH+(45/2)));
			Pen.lineTo(tempW-40 @ (tempH+(45/2)+5));
			Pen.moveTo(tempW-50 @ (tempH+(45/2)));
			Pen.lineTo(tempW-40 @ (tempH+(45/2)-5));

			Pen.fillStroke;

			//at this point get the number of active effects.
			//Let's say we have N active effects
			//draw N-1 white lines, then (Ntot) - (N-1) white lines
			//for now we'll only use white lines
			//maximum 10 effects
			for(1, numEffects-1, {arg i;
				Pen.strokeColor = Color.white;
				Pen.moveTo((tempW) @ (tempH + (i*45)));
				Pen.lineTo((tempW+200)@(tempH+(i*45)));

				//connect it visually to the "bus"
				Pen.moveTo(tempW @ (tempH+(i*45)+(45/2)));
				Pen.lineTo(tempW-50 @ (tempH+(i*45)+(45/2)));
				//draw a small arrow at the end :)
				Pen.moveTo(tempW-50 @ (tempH+(i*45)+(45/2)));
				Pen.lineTo(tempW-40 @ (tempH+(i*45)+(45/2)+5));
				Pen.moveTo(tempW-50 @ (tempH+(i*45)+(45/2)));
				Pen.lineTo(tempW-40 @ (tempH+(i*45)+(45/2)-5));


				Pen.fillStroke;
			});
			//draw two lines we'll later use to indicate things
			tempW = (vw.bounds.width/3 + 50);
			tempW = vw.bounds.width - (tempW+(vw.bounds.width/2));
			tempH = (vw.bounds.height/5 + 50);
			Pen.moveTo(tempW+25 @ (tempH+(numEffects*45)));
			Pen.lineTo(tempW+25 @ (tempH+(numEffects*45)+(45)));
			Pen.moveTo(tempW+125 @ (tempH+(numEffects*45)));
			Pen.lineTo(tempW+125 @ (tempH+(numEffects*45)+(90)));
			Pen.moveTo(tempW+225 @ (tempH+(numEffects*45)));
			Pen.lineTo(tempW+225 @ (tempH+(numEffects*45)+(135)));
			Pen.fillStroke;
		},
		2, {
			//SEQUENCER
			Pen.strokeColor = Color.white;
			Pen.moveTo(((vw.bounds.width/2 + 162)@
				(125)));
			Pen.lineTo((vw.bounds.width/2+270)@
				(125));

			Pen.fillStroke;

			Pen.color_(Color.new255(143, 143, 143));
			Pen.addRect(Rect(vw.bounds.width/2 - 50,vw.bounds.height/5 + 5,100,30 ));
			Pen.fill;
		},
		3, {
			//CREDITS
			Pen.strokeColor = Color.white;

			Pen.moveTo(((vw.bounds.width/2 + 275)@
				(125)));
			Pen.lineTo((vw.bounds.width/2+355)@
				(125));

			Pen.fillStroke;
			//make a rectangle
			tempW = vw.bounds.width/4;
			tempH = vw.bounds.height/5 + 50;
			Pen.moveTo(tempW @ tempH);
			Pen.addRect(Rect(tempW,tempH,2*tempW,400));
			Pen.fillColor_(Color.new255(0,0,0,0));
			Pen.strokeColor_(Color.white);
			Pen.fillStroke;

		}
	);//end switch
}; //end vw drawFunc






//TOOLBAR MENU
tempH = (vw.bounds.height/5 + 50);
tempW = (vw.bounds.width/2);


//The toolbar menu lets the user access different parts of the
//synth. When the user selects a choice, the program hides the current screen using hidePart, updates the currentScreen variable keeping track of the screen to draw and then calls showPart to draw it
//unfortunately it doesn't seem possible to customise the style of this
tb_menu = ToolBar(
	MenuAction("Synth", { hidePart.value(currentScreen); currentScreen = 0;
		showPart.value(currentScreen); vw.refresh; }),
	MenuAction("Effects", {changeWind.value(1); hidePart.value(currentScreen);currentScreen = 1;
		showPart.value(currentScreen); vw.refresh; }),
	MenuAction("Sequencer", { hidePart.value(currentScreen);
		currentScreen = 2;showPart.value(currentScreen); vw.refresh; }),
	MenuAction("Credits", { hidePart.value(currentScreen);currentScreen = 3;
		showPart.value(currentScreen); vw.refresh; })
);
//tb_menu.actions[1].postln; //test, unluckily it seems like it's
//not possible to change the appearance of a ToolBar MenuAction
//Unless we make icons that have the look we want. I personally think that's pretty stupid...
tb_menu.setParent(vw);
tb_menu.bounds = Rect.new(tempW, 50, tempW, 100);




//EFFECTS USERVIEW
/*
This part is dedicated to the 2D FX UserView (2DFXUV in short).
This is a UserView we use to make effects more user friendly
*/
tempW = (vw.bounds.width/3 + 50);
tempH = (vw.bounds.height/5 + 50);

~freqScope = FreqScopeView(vw, Rect(640,10,430, 70));
~freqScope.active_(true);
~freqScope.dbRange(200);
vw.onClose_({ ~freqScope.kill;
	for(0,11,{arg i;
							~seqPbind[i].stop;
							~seqPbind2[i].stop;
						});
	s.quit; });

fxView = UserView(vw,Rect(tempW,tempH,vw.bounds.width/2, 450));
ivFX = View.new(fxView, logoVerb.bounds);
ivFX.setBackgroundImage(logoVerb);
ivFX.bounds = Rect.new(fxView.bounds.width - 400,25,300,100);
ivFX.alwaysOnTop_(false);
ivFX.visible_(false);

//We define these functions to be able to deal
//with the "drag" actions in effects in a easy way
/*
Mouse Actions - arguments:
from https://doc.sccode.org/Classes/View.html#Mouse%20actions
    view - the view
    x - the x coordinate
    y - the y coordinate
    modifiers - A bitwise or of integers indicating the modifier keys in effect. For a list of these, see Modifier Keys.
    buttonNumber - 0-left, 1-right, 2-middle, etc.
    clickCount - the number of clicks within the system click time limit. At least 1.
*/
eqCircleRadius = 6;
fxView.mouseDownAction = {
	| view, x, y, modifiers, buttonNumber, clickCount|
	switch(fx_params[currFX].at(\type),
		"EQ",{
			//find out if it's touching a circle
			//circles have a 20x20 rectangular hitbox
			//the +10 accounts for the fact circles are actually drawn in the
			//center of a rectangular shape
			tempX = fx_params[currFX].at(\freq1) / (Server.default.sampleRate/2) * fxView.bounds.width;
			tempY = fxView.bounds.height - ((fx_params[currFX].at(\gain1) / 2) * fxView.bounds.height);
			if( (abs(x - tempX) <=eqCircleRadius) &&  (abs(y-tempY)<=eqCircleRadius),
				{eqSelectedCircle = 0;}
			);

			tempX = fx_params[currFX].at(\freq2) / (Server.default.sampleRate/2) * fxView.bounds.width;
			tempY = fxView.bounds.height - ((fx_params[currFX].at(\gain2) / 2) * fxView.bounds.height);
			if( (abs(x - tempX) <=eqCircleRadius) &&  (abs(y-tempY)<=eqCircleRadius),
				{eqSelectedCircle = 1;}
			);

			tempX = fx_params[currFX].at(\freq3) / (Server.default.sampleRate/2) * fxView.bounds.width;
			tempY = fxView.bounds.height - ((fx_params[currFX].at(\gain3) / 2) * fxView.bounds.height);
			if( (abs(x - tempX) <=eqCircleRadius) &&  (abs(y-tempY)<=eqCircleRadius),
				{eqSelectedCircle = 2;}
			);

			tempX = fx_params[currFX].at(\freq4) / (Server.default.sampleRate/2) * fxView.bounds.width;
			tempY = fxView.bounds.height - ((fx_params[currFX].at(\gain4) / 2) * fxView.bounds.height);
			if( (abs(x - tempX) <=eqCircleRadius) &&  (abs(y-tempY)<=eqCircleRadius),
				{eqSelectedCircle = 3;}
			);
		}
	);
};
fxView.mouseUpAction = {
	| view, x, y, modifiers, buttonNumber |
	x.postln;
	switch(fx_params[currFX].at(\type),
		"EQ",{
			//if it was touching a circle, release it
			if(eqSelectedCircle != -1,{eqSelectedCircle = -1;});
		}
	);
};

//note that this is active ONLY if the mouse is currently down
fxView.mouseMoveAction = {
	|view, x, y, modifiers|
	//check the screen we're in
	switch(currentScreen,0,{
		//just in case we need it later
	},1,{
		switch(fx_params[currFX].at(\type),
			"BitCrusher",{
				tempVar = ((x)/fxView.bounds.width) * Server.default.sampleRate;
				if(tempVar<1, {
					tempVar = 1;
				});
				if(tempVar>Server.default.sampleRate, {
					tempVar = Server.default.sampleRate;
				});
				fx_params[currFX].put(\sr,round(tempVar));

				if(currFX == 0, {q.set(\sr, round(tempVar))});
				if(currFX == 1, {z.set(\sr, round(tempVar))});
				if(currFX == 2, {v.set(\sr, round(tempVar))});
				if(currFX == 3, {r.set(\sr, round(tempVar))});
				if(currFX == 4, {l.set(\sr, round(tempVar))});

				tempVar = (1 - ((y)/fxView.bounds.height)) * 32;
				if(tempVar<1, {
					tempVar = 1;
				});
				if(tempVar>32, {
					tempVar = 32;
				});

				fx_params[currFX].put(\bits, round(tempVar));

				if(currFX == 0, {q.set(\bits, round(tempVar))});
				if(currFX == 1, {z.set(\bits, round(tempVar))});
				if(currFX == 2, {v.set(\bits, round(tempVar))});
				if(currFX == 3, {r.set(\bits, round(tempVar))});
				if(currFX == 4, {l.set(\bits, round(tempVar))});
			},
			"Comp",{
			},
			"Distortion",{
			},
			"EQ",{

				if(eqSelectedCircle != -1, {
					tempVar = ((x)/fxView.bounds.width) * (Server.default.sampleRate/2);
				if(tempVar<1, {
					tempVar = 1;
				});
				if(tempVar>(Server.default.sampleRate/2), {
						tempVar = Server.default.sampleRate/2;
				});
				tempX = tempVar;

				tempVar = ((y)/fxView.bounds.height) * 2;
				tempVar = 2 - tempVar;
				if(tempVar<0, {
					tempVar = 0;
				});
				if(tempVar>2, {
					tempVar = 2;
				});
				tempY = tempVar;

					//we're actually obtaining the "true" values, not the
					//positions
				switch(eqSelectedCircle,
						0,{
							fx_params[currFX].put(\freq1, min(round(tempX),600));
					fx_params[currFX].put(\gain1, tempY);
					},1,{
							//make it so one point can not cross the previous
							tempX = max(tempX,1500);
					fx_params[currFX].put(\freq2, min(round(tempX),4500));
					fx_params[currFX].put(\gain2, tempY);
					},2,{
							tempX = max(tempX,5500);
					fx_params[currFX].put(\freq3, min(round(tempX),14000));
					fx_params[currFX].put(\gain3, tempY);
					},3,{
							tempX = max(tempX,15000);
					fx_params[currFX].put(\freq4, round(tempX));
					fx_params[currFX].put(\gain4, tempY);
					});//end circle switch
				});//end if selectedCircle
			}//end case "EQ"
		);//end switch (FX type)
		fxView.refresh;
	},2,{},3,{}
	);//end switch
};//end mouseMoveAction
//fxView.view.background_(Color.new255(45, 74, 92));
fxView.drawFunc = {
	//check we're in the FX screen
	if(currentScreen==1,{
		//draw
/*
		Pen.color = Color.new255(12, 12, 12,255);
		Pen.addRect(
			Rect(0,0,fxView.bounds.width,fxView.bounds.height);
		);
		Pen.fill;
*/
		//Pen.perform(\stroke \fill);

		Pen.color = Color.new255(255, 255, 255);
		Pen.strokeColor = Color.white;
		Pen.color = Color.new255(255, 255, 255);
		switch(fx_params[currFX].at(\type),
			"BitCrusher",{
				ivFX.visible_(false);
				Pen.color = Color.new255(30, 12, 12,255);
				Pen.addRect(
					Rect(0,0,fxView.bounds.width,fxView.bounds.height);
				);
				Pen.fill;
				Pen.color = Color.new255(255, 255, 255);
				Pen.strokeColor = Color.white;
				Pen.color = Color.new255(255, 255, 255);

				//this is purely cosmetic
				x = ControlSpec.new(minval: 0, maxval: 6,
					warp:'linear',step: 1);
				y = ControlSpec.new(minval: 0, maxval:4, warp: 'lin',
					step: 1);
				d = DrawGrid(Rect(0,0,fxView.bounds.width,
					fxView.bounds.height),
				GridLines.new(x),GridLines.new(y));
				d.draw;
				Pen.strokeColor = Color.white;

				Pen.color = Color.new255(255,255,255);

				Pen.addOval(
					Rect(
((fx_params[currFX].at(\sr)/Server.default.sampleRate) * (fxView.bounds.width)) - 10,(fxView.bounds.height -((fx_params[currFX].at(\bits) / 32 )*(fxView.bounds.height))) - 10,20,20);
				);

				Pen.fill;
			},
			"Comp",{
				ivFX.setBackgroundImage(logoComp);
				ivFX.visible_(true);
				Pen.color = Color.new255(30, 12, 12,255);
				Pen.addRect(
					Rect(0,0,fxView.bounds.width,fxView.bounds.height);
				);
				Pen.fill;
				Pen.color = Color.new255(255, 255, 255);
				Pen.strokeColor = Color.white;
				Pen.color = Color.new255(255, 255, 255);
				//thresh
				//ratio
				//ratio
				//atk
				//rel
				tempVar = fx_params[currFX].at(\thresh);
				tempVar.postln;
				tempVar = 100*tempVar;
				Pen.strokeColor = Color.white;
				Pen.fillColor = Color.new255(12, 12, 12,0);
				Pen.addRect(
					Rect(50,50,100,100);
				);
				Pen.fillStroke;
				Pen.strokeColor = Color.white;
				Pen.color = Color.new255(255,255,255,100);
				Pen.addOval(
					Rect((47+tempVar),(147 - tempVar),6,6);
				);
				Pen.fillStroke;
				Pen.strokeColor = Color.white;
				Pen.moveTo(50 @ 150);
				Pen.lineTo((50+tempVar) @ (150 - tempVar));
				Pen.moveTo((50+tempVar) @ (150 - tempVar));
				if(fx_params[currFX].at(\ratio) <= 1,{
					Pen.lineTo((150)@( (150 - tempVar)- ((100-tempVar)* (fx_params[currFX].at(\ratio)))));},
				{
					Pen.lineTo(max(50+tempVar,( (150-tempVar) + ((tempVar)/ (fx_params[currFX].at(\ratio)))))@(50));
				});
				Pen.fillStroke;
			},
			"Distortion",{
				ivFX.setBackgroundImage(logoDist);
				ivFX.visible_(true);
				Pen.color = Color.new255(30, 12, 12,255);
				Pen.addRect(
					Rect(0,0,fxView.bounds.width,fxView.bounds.height);
				);
				Pen.fill;
				Pen.color = Color.new255(255, 255, 255);
				Pen.strokeColor = Color.white;
				Pen.color = Color.new255(255, 255, 255);

				Pen.moveTo(100 @ 100);
				Pen.lineTo(400 @ 100);
				Pen.fillStroke;
			},
			"EQ",{
				/*
				//if this worked it would be epic, as we could see
				//the waveform under the EQ
				~freqScope = FreqScopeView(vw, fxView.bounds);
				~freqScope.active_(true);
				fxView.onClose_({ ~freqScope.kill });
				*/
				Pen.color = Color.new255(40, 12, 12,200);
				Pen.addRect(
					Rect(0,0,fxView.bounds.width,fxView.bounds.height);
				);
				Pen.fill;
				Pen.color = Color.new255(255, 255, 255);
				Pen.strokeColor = Color.white;
				Pen.color = Color.new255(255, 255, 255);
				tempX = fxView.bounds.width;
				tempY = fxView.bounds.height/2;
				Pen.moveTo(0 @ tempY);
				Pen.lineTo(tempX @ tempY);
				Pen.fillStroke;
				//Here we're essentially doing the BitCrusher thing
				//...but on steroids

				//draw all the circles. We chose arbitrary colors
				//Pen.strokeColor = Color.white;
				//circle 1
				Pen.color = Color.new255(46, 34, 156);
				//circles have a radius of eqCircleRadius
				tempX = fx_params[currFX].at(\freq1);
				tempY = fx_params[currFX].at(\gain1);
				tempX = ( tempX/(Server.default.sampleRate / 2))*fxView.bounds.width;
				tempY = (1 - ( tempY / 2)) * fxView.bounds.height;
				Pen.addOval(
					Rect(tempX - eqCircleRadius,tempY - eqCircleRadius, 2*eqCircleRadius,2*eqCircleRadius);
				);
				Pen.fillStroke;
/*
				//i started implementing a visual parametric EQ but i abandoned it because i wasn't able to properly sum different curves. If someone wants to help you're welcome to
				Pen.strokeColor = Color.white;
				Pen.moveTo(0 @ (fxView.bounds.height/2));
				tempVar = tempY - (fxView.bounds.height/2);
				//for some unknown reason, unless I re-add 225 (which is fxView.bounds.height/2) the curves appear bugged. I tried all possible combinations ( don't subtract to tempVar, don't add on curveTo, don't do either, but this is the only way i could get a non bugged result)
				Pen.curveTo((tempX @ tempY), ( (tempX/3) @ (tempVar/2 + 225)), ((2*tempX/3) @ (tempVar + 225)) );
				tempVar = Point.new(tempX, tempY);
				Pen.fillStroke;
				tempPos1 = tempX;
				tempPos2 = tempY;
				*/
				//circle 2
				Pen.color = Color.new255(19, 143, 23);
				//circles have a radius of eqCircleRadius
				tempX = fx_params[currFX].at(\freq2);
				tempY = fx_params[currFX].at(\gain2);
				tempX = ( tempX/(Server.default.sampleRate / 2))*fxView.bounds.width;
				tempY = (1 - ( tempY / 2)) * fxView.bounds.height;
				Pen.addOval(
					Rect(tempX- eqCircleRadius,tempY-eqCircleRadius, 2*eqCircleRadius,2*eqCircleRadius);
				);
				Pen.fillStroke;
				/*
				Pen.strokeColor = Color.white;
				Pen.moveTo(tempVar);
				tempVar = tempY - (fxView.bounds.height/2);
				tempX.postln;
				//and here it works...
				//great, just great
				Pen.curveTo((tempX @ tempY), (tempPos1+(tempX/3)) @ (tempY), (tempPos1+(2*tempX/3)) @ (tempY));
				tempVar = Point.new(tempX, tempY);
				Pen.fillStroke;
*/
				//circle 3
				Pen.color = Color.new255(135, 16, 121);
				//circles have a radius of eqCircleRadius
				tempX = fx_params[currFX].at(\freq3);
				tempY = fx_params[currFX].at(\gain3);
				tempX = ( tempX/(Server.default.sampleRate / 2))*fxView.bounds.width;
				tempY = (1 - ( tempY / 2)) * fxView.bounds.height;
				Pen.addOval(
					Rect(tempX-eqCircleRadius,tempY-eqCircleRadius, 2*eqCircleRadius,2*eqCircleRadius);
				);
				Pen.fillStroke;

				//circle 4
				Pen.color = Color.new255(214, 167, 24);
				//circles have a radius of eqCircleRadius
				tempX = fx_params[currFX].at(\freq4);
				tempY = fx_params[currFX].at(\gain4);
				tempX = ( tempX/(Server.default.sampleRate / 2))*fxView.bounds.width;
				tempY = (1 - ( tempY / 2)) * fxView.bounds.height;
				Pen.addOval(
					Rect(tempX-eqCircleRadius,tempY-eqCircleRadius, 2*eqCircleRadius,2*eqCircleRadius);
				);
				Pen.fillStroke;
			},"Reverb",{
				ivFX.setBackgroundImage(logoVerb);
				ivFX.visible_(true);
				Pen.color = Color.new255(30, 12, 12,255);
				Pen.addRect(
					Rect(0,0,fxView.bounds.width,fxView.bounds.height);
				);
				Pen.fill;
				Pen.color = Color.new255(255, 255, 255);
				Pen.strokeColor = Color.white;
				Pen.color = Color.new255(255, 255, 255);

				Pen.moveTo(0 @ 100);
				Pen.lineTo(400 @ 100);
				Pen.fillStroke;
			}
		);//end switch

		//get the currFx
		//get its type
		//retrieve its parameters
		//draw accordingly
	});
};//end fxView drawFunc


//SEQUENCER PART
tempH = vw.bounds.height/5;
seqView = UserView(vw,Rect(100,tempH+50,
	vw.bounds.width - 200,vw.bounds.height - tempH - 100));
seqView.drawFunc = {
	var xOffset, loc,dur;
	switch(currentScreen,
		0,{},1,{},2,{
			Pen.strokeColor = Color.white;
			Pen.fillColor = Color.new255(53,57,63);
			Pen.addRect(Rect(0,0,seqView.bounds.width,
				seqView.bounds.height));
			Pen.fill;
			Pen.addRect(Rect(0,0,seqView.bounds.width,
				seqView.bounds.height));
			//since i couldn't do this all at once...
			Pen.stroke;

			//the idea for the sequencer is to make a 12 x 32
			//grid that will represent a 4/4 meter
			//with a 1/32 tatum
			//TODO: start from here
			//draw 12 horizontal lines
			tempVar = seqView.bounds.height/12;
			//32 parts for sequencer, 3 for keyboard
			tempX = seqView.bounds.width/35;
			minDurLen = tempX;
			noteHeight = tempVar;
			k = 0;
			for(0,11,{arg i;
				Pen.strokeColor = Color.grey;
				tempY = i*tempVar;
				Pen.moveTo(0 @ tempY);
				Pen.lineTo(seqView.bounds.width @ tempY);
				Pen.fillStroke;
				//draw a small keyboard:D
				if(k%2==0, {Pen.fillColor_(Color.white)},{Pen.fillColor_(Color.black)});
				Pen.addRect(Rect(0,tempY,3*tempX,tempVar));
				Pen.fillStroke;

				//key guidelines
				if(k%2==0, {Pen.fillColor_(Color.new255(255,255,255,15))},{Pen.fillColor_(Color.new255(12,12,12,25))});
				Pen.addRect(Rect(3*tempX,tempY,seqView.bounds.width - (3*tempX),tempVar));
				Pen.fillStroke;

				k = k+1;
				if (k==7,{k=0});
			});
			for(3,34,{
				arg i;
				if( (i-3) % 8 == 0,{
					Pen.strokeColor = Color.new255(250,250,250);
				},{
				Pen.strokeColor = Color.grey;
				});
				Pen.moveTo((i*tempX) @ 0);
				Pen.lineTo((i*tempX) @ seqView.bounds.height);
				Pen.fillStroke;
			});
			xOffset = 3*minDurLen;
			//draw the epic notes
			for(0,numNotes-1,{arg i;
				//get the notes dictionary
				//read and represent the notes
				tempVar = seqNotes.at(i).indices;
				if(tempVar.size>0,{
					for(0, tempVar.size - 1,{arg k;
						loc = tempVar[k];
						dur = seqNotes.at(i).at(loc);
						tempX = xOffset + (loc*minDurLen);
						tempY = noteHeight * (i+1);
						tempY = seqView.bounds.height-tempY;
						Pen.moveTo((tempX) @ tempY);
						Pen.fillColor_(Color.new255(115, 169, 199));

						Pen.addRect(Rect(tempX,tempY, dur*minDurLen,noteHeight));
						Pen.fillStroke;
					});
				});
			});

		}
	);//end switch currentScreen
}; //end seqView drawFunc

seqView.mouseDownAction = {
	|view, x, y, modifiers, buttonNumber, clickCount|
	//find out if there is already a note at that location
	//if there is this now become a matter for mouseMoveAction
	//if there isn't create one

	//find the selected note

	var note;
	var loc;
	var duration = 1;
	var invalidLoc = false;
	var tempLoc, tempNote,tempDur;
	note = floor(y / noteHeight);
	if(note < 0, {note = 0;});
	if(note > 11, {note = 11;});
	note = 11 - note;

	tempX = 3*minDurLen;
	loc = floor((x - tempX / minDurLen));
	if(loc<0, {
		//play the note
		invalidLoc = true;
	});
	if(loc>31,{loc = 32;});

	//If loc>=0 the position is valid for writing/editing/deleting notes
	//find out if there is already a note there
	if(invalidLoc==false, {
	if ( hasNote.value(note,loc),
		{//we'll leave this to mouseMoveAction
			//...unless our current tool is the delete tool (2)
				if( (currTool==2) || (buttonNumber==1), //this thing doesn't work anyway...
				{
					seqNotes.at(note).removeAt(loc);
				},{
					currSelNote = [note,loc];}
			);

		},
		{ //no note
			//drawing tool
			if( (currTool==0) && (buttonNumber==0),
				{
					//check if there are overlaps with existing notes
					//if there are:
					//get the existing note, stop it at the new note beginning
					tempLoc = -1;
					tempDur = -1;
					for(0,loc,
						{arg i;
							if(hasNote.value(note,i),{
								tempDur = seqNotes.at(note).at(i);
								tempLoc = i;
							});
					});
					//check if it overlaps
					if( (tempDur != -1)&&((tempLoc + tempDur)> loc),
						{
							//it overlaps
							//cut the note

							seqNotes.at(note).put(tempLoc, (loc-tempLoc));
						},
					);

					//then after solving eventual overlaps
					//add the note
					seqNotes.at(note).put(loc,duration);
			});
			//deleter tool
			if(currTool==2,
				{
					//look for the previous event for the current Note
					//and see if it overlaps. If so delete
					tempLoc = -1;
					tempDur = -1;
					for(0,loc,
						{arg i;
							if(hasNote.value(note,i),{
								tempDur = seqNotes.at(note).at(i);
								tempLoc = i;
							});
					});

					//check if it overlaps
					if( (tempDur != -1)&&((tempLoc + tempDur)> loc),
						{


							seqNotes.at(note).removeAt(tempLoc);
						}
					);
			});
		});//END if (note has value)
});//END if (loc is valid)
	seqView.refresh;
};
seqView.mouseMoveAction = {
	|view, x, y, modifiers|
	//if you press on an existing note you will move it
	//the problem is that we have no way to shrink or enlarge notes for now.
	var startX, startY, newX,newY, dur,changed,tempDur, diff;
	changed = false;
	if(currSelNote == -1, {//do nothing
	},{
		dur = seqNotes.at(currSelNote[0]).at(currSelNote[1]);
		startY = currSelNote[0] * noteHeight;
		startY = seqView.bounds.height - startY;
		startX = 3 * minDurLen + (currSelNote[1]*minDurLen) +(minDurLen/2);
		newY = currSelNote[0];
		newX = currSelNote[1];
		if( abs(y - startY) > noteHeight,
			{
				if(y < startY,
					{
					//move up a note
						newY = currSelNote[0]+1;
						newY = min(11,newY);
					},
					{
					//move down a note
						newY = currSelNote[0]-1;
						newY = max(0,newY);
					}
				);
				changed = true;
			});
		//here we need to distinguish between the
		//draw tool and the duration tool
		//0 = draw tool
		if(currTool==0,{
		if( abs(x - startX) > minDurLen,
			{
				if(x < startX,
					{
					//move left
						newX = currSelNote[1]-1;
						newX = max(0,newX);
				},{
					//move right
						newX = currSelNote[1]+1;
						newX = min(31,newX);
				});
				changed = true;
		});
		});
		//1 = duration tool
		if(currTool==1,{
			//if we go to the left we want to shorten it
			//if we go to the right we want to enlarge it
			if(x < startX ,{
				//TODO FIX THIS
				tempDur = seqNotes.at(currSelNote[0]).at(currSelNote[1]);

				diff = startX-x;
				//how many durations are we removing?
				diff = floor(diff/minDurLen);

				//see below
				tempDur = max(diff-tempDur,0);
				tempDur = max(tempDur - diff,1); //at least one duration is needed
				dur = tempDur;
			},{
				diff = x - startX;
				//how many durations are we removing?
				diff = floor(diff/minDurLen); //convert in "durations"
				tempDur = seqNotes.at(currSelNote[0]).at(currSelNote[1]);
				//account also for current duration
				//otherwise it will shoot out of the screen
				tempDur = max(diff-tempDur,0);
				tempDur = max(tempDur + diff,1); //at least one duration is needed
				dur = tempDur;
			})
		});
		//delete the old note
		//add the now note
		seqNotes.at(currSelNote[0]).removeAt(currSelNote[1]);
		seqNotes.at(newY).put(newX,dur);
		//update the note otherwise everything breaks
		//(i totally didn't waste 30 minutes for this)
		currSelNote = [newY,newX];
	});

	seqView.refresh;
};
seqView.mouseUpAction = {
	currSelNote = -1;
};

//We could use a priority queue for playback
initFxParamDictionaries = {
	for(0,numEffects-1,{
		arg i;
		fx_params[i] = Dictionary();
	});
};
initFxParamDictionaries.value;

seqNotes = Dictionary();
initNotesDictionary = {
	for(0,numNotes-1, {
		arg i;
		seqNotes.put(i, Order.new);
	});
};
initNotesDictionary.value;

addNewNote = {
	arg note,start,duration;
	start.postln;
	duration.postln;
	//find the correct position to add the new note in
	//seqNotes[note]
};

hasNote = {
	arg note,loc;
	var has;
	has = (seqNotes.at(note).at(loc) != nil);
};


//Take the notes dictionary and create a note sequence ready to be played
//Notes, when present, are in the format [NOTE, LOCATION, DURATION]
//e.g. a C at step 4 (starting from 0) with duration 1 step will be
//saved as [0,4,1]
notesToSeq = {
	arg notes;
	var notesSequence;
	var tempArray, noteArray;
	var isEmptyTempArray = true;
	var tempDur;
	//notesSequence = Array.new(maxSize:32);
	notesSequence = Array.fill(32, {arg i; i});
	//take the note dictionary, seqNotes
	//we have numNotes entries. Each
	//entry contains an Order, an ordered dictionary
	//containing, for that note, (location, duration) couples
	for(0,31,{
		//iterate over the number of points in the grid
		arg i;
		notesSequence.put(i, -1);
		//iterate over the number of notes
		tempArray = Array.new(maxSize: 12);

		for(0,numNotes-1,{
			arg j;
			noteArray = Array.new(maxSize:3);
			if(hasNote.value(j,i) == true,
				{
					//extract the note and add it to a temp
					//array
					tempDur = seqNotes.at(j).at(i);
					//add an array of the type [note,duration]
					noteArray.add(j);
					noteArray.add(i);
					noteArray.add(tempDur);
					tempArray.add(noteArray);
					isEmptyTempArray = false;
				}
			);//end IF
		});//END notes for
		if(isEmptyTempArray == false,
			{
				//we have at least one event for that note
				notesSequence.put(i, tempArray);
		});
		isEmptyTempArray = true;
	});//END FOR
	//now we should have an array containing, for
	//each position, the events associated to that position
	//in the sequencer
	//we get them in a [note, location, duration] format
	//if there are multiple, we will get an array of arrays
	notesSequence.postln;
};
"Good news, everything seems to be working".postln;

//i'm putting this here because otherwise it would be hidden
//under an image and be unclickable
playStopToolbar.setParent(vw);
playStopToolbar.bounds = Rect.new(vw.bounds.width/2 -35, 15, 75, 45);

// Functions that changes settings with respect to timbre chosen
~timbre_osc_settings = {
	if(~timbre_osc_type == 1, {
		knobA1.value = 0.2;
		knobS1.value = 1;
		knobR1.value = 0.2;
		~osc_type = 2;
		//account for different indexing
		osc1PUM.value_(1);
	});
	if(~timbre_osc_type == 2, {
		knobA1.value = 0.2;
		knobS1.value = 1;
		knobR1.value = 0.1;
		~osc_type = 1;
		osc1PUM.value_(0);
	});


};

~timbre_noise_settings = {
	if(~timbre_noise_type == 1, {
		knobA2.value = 0.1;
		knobS2.value = 1;
		knobR2.value = 0.24;
		~noise_type = 2;
		osc2PUM.value_(1);
	});
	if(~timbre_noise_type == 2, {
		knobA2.value = 0.2;
		knobS2.value = 1;
		knobR2.value = 0.1;
		~noise_type = 1;
		osc2PUM.value_(0);
	});


};
//From here there are functions that exploits the creation of all synths
~timbre_creation = {
	// Osc side
	if (~osc_type == 1, {
		if(~timbre_osc_type == 0,{(instrument: \dummyEnv,att: knobA1.value,sus: knobS1.value,rel: knobR1.value,out:~output_bus_timbre_osc,ampSaw:1,ampTri:0,\ampPul:0,\ampWhi:0,\ampBro:0,\ampPin:0,\group:u).play;});
		if(~timbre_osc_type == 1,{(instrument: \panOsc,att: knobA1.value,sus: knobS1.value,rel: knobR1.value,out:~output_bus_timbre_osc,ampSaw:1,ampTri:0,\ampPul:0,\group:u).play;});
		if(~timbre_osc_type == 2,{(instrument: \brassOsc,att: knobA1.value,sus: knobS1.value,rel: knobR1.value,out:~output_bus_timbre_osc,ampSaw:1,ampTri:0,\ampPul:0,\group:u).play;});
	});

	if (~osc_type == 2, {
		if(~timbre_osc_type == 0,{(instrument: \dummyEnv,att: knobA1.value,sus: knobS1.value,rel: knobR1.value,out:~output_bus_timbre_osc,ampSaw:0,ampTri:0,\ampPul:1,\ampWhi:0,\ampBro:0,\ampPin:0,\group:u).play;});
		if(~timbre_osc_type == 1,{(instrument: \panOsc,att: knobA1.value,sus: knobS1.value,rel: knobR1.value,out:~output_bus_timbre_osc,ampSaw:0,ampTri:0,\ampPul:1,\group:u).play;});
		if(~timbre_osc_type == 2,{(instrument: \brassOsc,att: knobA1.value,sus: knobS1.value,rel: knobR1.value,out:~output_bus_timbre_osc,ampSaw:0,ampTri:0,\ampPul:1,\group:u).play;});
	});

	if (~osc_type == 3, {
		if(~timbre_osc_type == 0,{(instrument: \dummyEnv,att: knobA1.value,sus: knobS1.value,rel: knobR1.value,out:~output_bus_timbre_osc,ampSaw:0,ampTri:1,\ampPul:0,\ampWhi:0,\ampBro:0,\ampPin:0,\group:u).play;});
		if(~timbre_osc_type == 1,{(instrument: \panOsc,att: knobA1.value,sus: knobS1.value,rel: knobR1.value,out:~output_bus_timbre_osc,ampSaw:0,ampTri:1,\ampPul:0,\group:u).play;});
	 if(~timbre_osc_type == 2,{(instrument: \brassOsc,att: knobA1.value,sus: knobS1.value,rel: knobR1.value,out:~output_bus_timbre_osc,ampSaw:0,ampTri:1,\ampPul:0,\group:u).play;});
	});

	// Noise side
	if (~noise_type == 1,{
		if(~timbre_noise_type == 0,{(instrument: \dummyEnv,att: knobA2.value,sus: knobS2.value,rel: knobR2.value,out:~output_bus_timbre_noise,ampSaw:0,ampTri:0,\ampPul:0,\ampWhi:0,\ampBro:1,\ampPin:0,\group:u).play;});
		if(~timbre_noise_type == 1,{(instrument: \panNoise,att: knobA2.value,sus: knobS1.value,rel: knobR1.value,out:~output_bus_timbre_noise,\ampWhi:0,\ampBro:1,\ampPin:0,\group:u).play;});
		if(~timbre_noise_type == 2,{(instrument: \brassNoise,att: knobA2.value,sus: knobS1.value,rel: knobR1.value,out:~output_bus_timbre_noise,\ampWhi:0,\ampBro:1,\ampPin:0,\group:u).play;});
	});

	if (~noise_type == 2,{
		if(~timbre_noise_type == 0,{(instrument: \dummyEnv,att: knobA2.value,sus: knobS2.value,rel: knobR2.value,out:~output_bus_timbre_noise,ampSaw:0,ampTri:0,\ampPul:0,\ampWhi:0,\ampBro:0,\ampPin:1,\group:u).play;});
		if(~timbre_noise_type == 1,{(instrument: \panNoise,att: knobA2.value,sus: knobS2.value,rel: knobR2.value,out:~output_bus_timbre_noise,\ampWhi:0,\ampBro:0,\ampPin:1,\group:u).play;});
		if(~timbre_noise_type == 2,{(instrument: \brassNoise,att: knobA2.value,sus: knobS2.value,rel: knobR2.value,out:~output_bus_timbre_noise,\ampWhi:0,\ampBro:0,\ampPin:1,\group:u).play;});
	});

	if (~noise_type == 3,{
		if(~timbre_noise_type == 0,{(instrument: \dummyEnv,att: knobA2.value,sus: knobS2.value,rel: knobR2.value,out:~output_bus_timbre_noise,ampSaw:0,ampTri:0,\ampPul:0,\ampWhi:1,\ampBro:0,\ampPin:0,\group:u).play;});
		if(~timbre_noise_type == 1,{(instrument: \panNoise,att: knobA2.value,sus: knobS2.value,rel: knobR2.value,out:~output_bus_timbre_noise,\ampWhi:1,\ampBro:0,\ampPin:0,\group:u).play;});
		if(~timbre_noise_type == 2,{(instrument: \brassNoise,att: knobA2.value,sus: knobS2.value,rel: knobR2.value,out:~output_bus_timbre_noise,\ampWhi:1,\ampBro:0,\ampPin:0,\group:u).play;});
	});
};

~filters_osc_creation = {// f h
	if(~first_filters_osc_play == true, {~first_filters_osc_play=false;},{f.free; h.free;});

	if(~filter1_osc_on==true,{
		if(~filter1_osc_type == 3,{f = Synth.new(\hpf_osc,[\cutoff,knobCut1.value,\res,knobRes1.value,\out,~output_bus_filter1_osc,\inBus,~input_bus_filter1_osc],g);});
	    if(~filter1_osc_type == 4,{f = Synth.new(\lpf_osc,[\cutoff,knobCut1.value,\res,knobRes1.value,\out,~output_bus_filter1_osc,\inBus,~input_bus_filter1_osc],g);});
	},{f = Synth.new(\dummy,[\out,~output_bus_filter1_osc,\inBus,~input_bus_filter1_osc],g);});

	if(~filter2_osc_on==true,{
		if(~filter2_osc_type == 3,{h = Synth.after(f,\hpf2_osc,[\cutoff2,knobCut2.value,\res,knobRes2.value,\out,~output_bus_filter2_osc,\inBus,~input_bus_filter2_osc],g);});
	    if(~filter2_osc_type == 4,{h = Synth.after(f,\lpf2_osc,[\cutoff2,knobCut2.value,\res,knobRes2.value,\out,~output_bus_filter2_osc,\inBus,~input_bus_filter2_osc],g);});
	},{h = Synth.after(f,\dummy,[\out,~output_bus_filter2_osc,\inBus,~input_bus_filter2_osc],g);});
};

~filters_noise_creation = {// w j
	if(~first_filters_noise_play == true, {~first_filters_noise_play=false;},{w.free; j.free;});

	if(~filter1_noise_on==true,{
		if(~filter1_noise_type == 3,{w = Synth.new(\hpf_noise,[\cutoff,knobCut3.value,\res,knobRes3.value,\out,~output_bus_filter1_noise,\inBus,~input_bus_filter1_noise],g);});
	    if(~filter1_noise_type == 4,{w = Synth.new(\lpf_noise,[\cutoff,knobCut3.value,\res,knobRes3.value,\out,~output_bus_filter1_noise,\inBus,~input_bus_filter1_noise],g);});
	},{w = Synth.new(\dummy,[\out,~output_bus_filter1_noise,\inBus,~input_bus_filter1_noise],g);});

	if(~filter2_noise_on==true,{
		if(~filter2_noise_type == 3,{j = Synth.after(w,\hpf2_noise,[\cutoff2,knobCut4.value,\res,knobRes4.value,\out,~output_bus_filter2_noise,\inBus,~input_bus_filter2_noise],g);});
	    if(~filter2_noise_type == 4,{j = Synth.after(w,\lpf2_noise,[\cutoff2,knobCut4.value,\res,knobRes4.value,\out,~output_bus_filter2_noise,\inBus,~input_bus_filter2_noise],g);});
	},{j = Synth.after(w,\dummy,[\out,~output_bus_filter2_noise,\inBus,~input_bus_filter2_noise],g);});
};

~effects_creation = { // q z v r l
	if(~first_effects_play == true, {~first_effects_play=false;},{q.free; z.free; v.free; r.free; l.free;});
	if(~fx1_on==true,{
		if(~fx1_type == 1,{q = Synth.new(\bitcrushimusMaximus,[\sr, fx_params[0].at(\sr), \bits, fx_params[0].at(\bits),\out,~output_bus_fx1,\inBus,~input_bus_fx1],o,\addToHead);});
        if(~fx1_type == 2,{q = Synth.new(\reverbior,[\size, fx_params[0].at(\size),\damp, fx_params[0].at(\damp),\drylevel, fx_params[0].at(\dry),\out,~output_bus_fx1,\inBus,~input_bus_fx1],o,\addToHead);});
		if(~fx1_type == 3,{q = Synth.new(\compressor,[\thresh, fx_params[0].at(\thresh), \ratio , fx_params[0].at(\ratio), \atk , fx_params[0].at(\atk), \rel , fx_params[0].at(\rel), \gain, fx_params[0].at(\gain), \out,~output_bus_fx1,\inBus,~input_bus_fx1],o,\addToHead);});
		if(~fx1_type == 4,{q = Synth.new(\winDistort,[\amp, fx_params[0].at(\pre), \dist, fx_params[0].at(\dist), \post, fx_params[0].at(\post), \out,~output_bus_fx1,\inBus,~input_bus_fx1],o,\addToHead);});
	},{q = Synth.new(\dummy,[\out,~output_bus_fx1,\inBus,~input_bus_fx1],o,\addToHead);});

	if(~fx2_on==true,{
		if(~fx2_type == 1,{z = Synth.after(q,\bitcrushimusMaximus,[\sr, fx_params[1].at(\sr), \bits, fx_params[1].at(\bits),\out,~output_bus_fx2,\inBus,~input_bus_fx2],o);});
		if(~fx2_type == 2,{z = Synth.after(q,\reverbior,[\size, fx_params[1].at(\size),\damp, fx_params[1].at(\damp),\drylevel, fx_params[1].at(\dry),\out,~output_bus_fx2,\inBus,~input_bus_fx2],o);});
		if(~fx2_type == 3,{z = Synth.after(q,\compressor,[\thresh, fx_params[1].at(\thresh), \ratio , fx_params[1].at(\ratio), \atk , fx_params[1].at(\atk), \rel , fx_params[1].at(\rel), \gain, fx_params[1].at(\gain), \out,~output_bus_fx2,\inBus,~input_bus_fx2],o);});
		if(~fx2_type == 4,{z = Synth.after(q,\winDistort,[\amp, fx_params[1].at(\pre), \dist, fx_params[1].at(\dist), \post, fx_params[1].at(\post), \out,~output_bus_fx2,\inBus,~input_bus_fx2],o);});
	},{z = Synth.after(q,\dummy,[\out,~output_bus_fx2,\inBus,~input_bus_fx2],o);});

	if(~fx3_on==true,{
		if(~fx3_type == 1,{v = Synth.after(z,\bitcrushimusMaximus,[\sr, fx_params[2].at(\sr), \bits, fx_params[2].at(\bits),\out,~output_bus_fx3,\inBus,~input_bus_fx3],o);});
		if(~fx3_type == 2,{v = Synth.after(z,\reverbior,[\size, fx_params[2].at(\size),\damp, fx_params[2].at(\damp),\drylevel, fx_params[2].at(\dry),\out,~output_bus_fx3,\inBus,~input_bus_fx3],o);});
		if(~fx3_type == 3,{v = Synth.after(z,\compressor,[\thresh, fx_params[2].at(\thresh), \ratio , fx_params[2].at(\ratio), \atk , fx_params[2].at(\atk), \rel , fx_params[2].at(\rel), \gain, fx_params[2].at(\gain), \out,~output_bus_fx3,\inBus,~input_bus_fx3],o);});
		if(~fx3_type == 4,{v = Synth.after(z,\winDistort,[\amp, fx_params[2].at(\pre), \dist, fx_params[2].at(\dist), \post, fx_params[2].at(\post),\out,~output_bus_fx3,\inBus,~input_bus_fx3],o);});
	},{v = Synth.after(z,\dummy,[\out,~output_bus_fx3,\inBus,~input_bus_fx3],o);});

	if(~fx4_on==true,{
		if(~fx4_type == 1,{r = Synth.after(v,\bitcrushimusMaximus,[\sr, fx_params[3].at(\sr), \bits, fx_params[3].at(\bits),\out,~output_bus_fx4,\inBus,~input_bus_fx4],o);});
		if(~fx4_type == 2,{r = Synth.after(v,\reverbior,[\size, fx_params[3].at(\size),\damp, fx_params[3].at(\damp),\drylevel, fx_params[3].at(\dry),\out,~output_bus_fx4,\inBus,~input_bus_fx4],o);});
		if(~fx4_type == 3,{r = Synth.after(v,\compressor,[\thresh, fx_params[3].at(\thresh), \ratio , fx_params[3].at(\ratio), \atk , fx_params[3].at(\atk), \rel , fx_params[3].at(\rel), \gain, fx_params[3].at(\gain), \out,~output_bus_fx4,\inBus,~input_bus_fx4],o);});
		if(~fx4_type == 4,{r = Synth.after(v,\winDistort,[\amp, fx_params[3].at(\pre), \dist, fx_params[3].at(\dist), \post, fx_params[3].at(\post), \out,~output_bus_fx4,\inBus,~input_bus_fx4],o);});
	},{r = Synth.after(v,\dummy,[\out,~output_bus_fx4,\inBus,~input_bus_fx4],o);});

	if(~fx5_on==true,{
		if(~fx5_type == 1,{l = Synth.after(r,\bitcrushimusMaximus,[\sr, fx_params[4].at(\sr), \bits, fx_params[4].at(\bits),\out,~output_bus_fx5,\inBus,~input_bus_fx5],o);});
		if(~fx5_type == 2,{l = Synth.after(r,\reverbior,[\size, fx_params[4].at(\size),\damp, fx_params[4].at(\damp),\drylevel, fx_params[4].at(\dry),\out,~output_bus_fx5,\inBus,~input_bus_fx5],o);});
		if(~fx5_type == 3,{l = Synth.after(r,\compressor,[\thresh, fx_params[4].at(\thresh), \ratio , fx_params[4].at(\ratio), \atk , fx_params[4].at(\atk), \rel , fx_params[4].at(\rel), \gain, fx_params[4].at(\gain), \out,~output_bus_fx5,\inBus,~input_bus_fx5],o);});
		if(~fx5_type == 4,{l = Synth.after(r,\winDistort,[\amp, fx_params[4].at(\pre), \dist, fx_params[4].at(\dist), \post, fx_params[4].at(\post), \out,~output_bus_fx5,\inBus,~input_bus_fx5],o);});
	},{l = Synth.after(r,\dummy,[\out,~output_bus_fx5,\inBus,~input_bus_fx5],o);});
};

~final_mixing_creation = {// p
	if(~first_final_mixing_play == true, {~first_final_mixing_play=false;},{p.free;});

	p = Synth.after(l,\finalMix,[\inBus,~input_bus_final_mixing],o);
};
~filters_osc_creation.value;
~filters_noise_creation.value;
~effects_creation.value;
~final_mixing_creation.value;
)
// Miscellaneous
/*
(
b = Buffer.read(s, thisProcess.nowExecutingPath.dirname+/+"images/motherboard.mp3");

SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
    Out.ar(out,
        PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), doneAction: Done.freeSelf)
    )
}).play(s, [\out, 0, \bufnum, b]);
)
(
b.free;
)

(
//Free stuff
iv.free;
iv2.free;
)// END NEW GUI

(
//https://doc.sccode.org/Classes/Dictionary.html
d = Order.new;
d.put(0,"a");
d.put(2.2,"BBB");
d.put(1,"hh");
d.at(0.5).postln;
d.size.postln;
d.removeAt(0);
d.postln;
)

(
d = {
	c = true;
};
d.value;
)


(~freqScope.kill;
b.free;
)
*/