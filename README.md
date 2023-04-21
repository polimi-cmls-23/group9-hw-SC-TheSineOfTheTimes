# **BitWinds**
### **A subtractive synthesis powered wind instrument emulator**
(Group 9 repository for the SC homework of CMLS, A.Y. 2022/2023)
# Video presentation

<a href="http://www.youtube.com/watch?feature=player_embedded&v=_Oub3e4ZPjg
" target="_blank"><img src="http://img.youtube.com/vi/_Oub3e4ZPjg/0.jpg" 
alt="Polyrhythm Galaxy video presentation" width="240" height="180" border="10" /></a>
Click on the picture to watch a video presentation of this project!
# General info
The goal of this project was to create a subtractive synthesiser to create some wind instrument like sounds.
Bitwinds is a two-oscillator synthesiser, containing a waveform and a noise oscillator. Each sound source is controlled by its own ASR envelope (no decay), passed through two filters (two per source, not two in common), passed through effects and finally written to the output.

More detailed informations can be found in the report we included in the **_Report_** folder. We went over the 8 pages limit but considering that half the pages are filled with images and that the LaTeX default page layout tends to waste a lot of space compared to, for example, Word, we think it is justified.

# Requirements
* [SC3plugins](https://supercollider.github.io/sc3-plugins/) for the Decimator and the CrossoverDistortion UGens. **This project won't run without a correct installation of SC3plugins!**

# Notes
The GUI is organised in tabs and contains some elements that have not been implemented. We made this choice because, even though we had to cut these elements due to time constraints, we're still pretty proud of our work and give a glimpse of what future improvements on this code could focus on. 

The main elements that have been cut are a sequencer (still in the GUI, even the note event to array function is ready but not connected to the sound through a function) and a graphical equalizer with its own waveform display (still in the code).

# Known issues
* (VERY RARE) The GUI (and the synth) randomly crash during execution, bringing the entire interpreter down with them. We have not been able to find a solution to this crash, also due to the objective difficulty in reproducing it
* Some limit cases have not been accounted for when calling _free_ on certain variables
* The stop button doesn't stop the reverb (this could also be seen as its intended behaviour)

