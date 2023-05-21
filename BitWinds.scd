//BitWinds
//A subtractive synthesis powered wind instrument emulator
//----------------------
//Authors: Francesco Colotti, Gioele Fortugno, Matteo Gionfriddo, Marco Granaiola, Emanuele Greco
//----------------------
// SynthDefs file

s.boot;
(
~project_dir = thisProcess.nowExecutingPath.dirname;
~synthDefs = ~project_dir +/+ "synthDefs.scd";
~gui = ~project_dir +/+ "gui.scd";
~synthDefs.load;
~gui.load;
)