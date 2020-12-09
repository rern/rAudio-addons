How To
---  
**Detect:**    
```sh  
export DISPLAY=:0  
xbindkeys -mk  
```  
  
**Edit:**  
/root/.xbindkeysrc 
```sh  
"command"  
keycode  
```  

**Restart xbindkeys:**    
```sh  
killall xbindkeys  
export DISPLAY=:0  
xbindkeys  
```  
  
**Cautions:**  
`color` buttons except `B amber`  
&nbsp; &nbsp; - responses once then locks all buttons  
&nbsp; &nbsp; - to unlock, press `B amber`  
&nbsp; &nbsp; - suitable for reboot or shutdown only  
			
`numlock` button  
&nbsp; &nbsp; - toggles between navigate / alpha-numeric buttons (gray background)  
&nbsp; &nbsp; &nbsp; &nbsp; `navigate` > `alpha-numeric` > `uppercase` > `alpha-numeric` > `navigate`  
&nbsp; &nbsp; - avoid pressing `numlock`    
    
**Complications:** +, ++, +++  
		\+ double detected output - combine to single 
		`close`  
		`mypc`  
		`desktop`  
		++ multiple detected output - select one 
		`green`  
		`amber`  
		`blue`  
		`yellow`  
		`rewind`  
		`forward`  
		+++ multiple detected output - select one / combine to single  
		`fullscreen`  
		++++ undetected but can be used  
		`skipback`  
		`skipnext`  
		`vol-`  
		`vol+`  
		  
**Not work:** x, xx  
  
x undetected ir:  
  `red`  
  `play/pause`  
  `mute`  
  `switchwindow`  
xx detected but not work  
  `windows`   
		  
		  
**Sequence:** left to right  
  
x `red` - undetected  
  
`email`  
```sh
m:0x0 + c:163  
XF86Mail  
```
  
`www`  
```sh
m:0x0 + c:180  
XF86HomePage  
```
  
\+ `close` - double detected output - combine to single  
```sh
m:0x8 + c:64 + m:0x0 + c:70  
Alt + Alt_L + F4  
```
  
++ `green` - multiple detected output - select one  
_works once > locks all buttons | press_ `B amber` _to unlock)_  
```sh
m:0xc + c:38  
Control+Alt + a  

	m:0xc + c:10  
	Control+Alt + 1  

	m:0xc + c:37  
	Control+Alt + Control_L  

	m:0x8 + c:64  
	Alt + Alt_L  

	m:0x0 + c:67  
	F1  
```
  
++ `amber` - multiple detected output - select one  
_also for unlock all buttons_  
```sh
m:0xc + c:56  
Control+Alt + b  

	m:0xc + c:11  
	Control+Alt + 2  

	m:0xc + c:37  
	Control+Alt + Control_L  

	m:0x8 + c:64  
	Alt + Alt_L  

	m:0x0 + c:68  
	F2  
```

++ `blue` - multiple detected output - select one  
_works once > locks all buttons | press_ `B amber` _to unlock_  
```sh
m:0xc + c:54  
Control+Alt + c  

	m:0xc + c:12  
	Control+Alt + 3  

	m:0xc + c:37  
	Control+Alt + Control_L  

	m:0x8 + c:64  
	Alt + Alt_L  

	m:0x0 + c:69  
	F3  
```  

++ `yellow` - multiple detected output - select one  
_works once > locks all buttons | press_ `B amber` _to unlock_  
```sh
m:0xc + c:40  
Control+Alt + d  

	m:0xc + c:13  
	Control+Alt + 4  

	m:0xc + c:37  
	Control+Alt + Control_L  

	m:0x8 + c:64  
	Alt + Alt_L  

	m:0x0 + c:70  
	F4  
	
```  
++++ `skipback` - undetected but can be used  
```sh
(undetected)  
XF86AudioPrev  
```

++++ `skipnext` - undetected but can be used  
```sh
(undetected)  
XF86AudioNext  
```
  
++ `rewind` - multiple detected output - select one  
```sh
	m:0x5 + c:113  
	Control+Shift + Left  

	m:0x5 + c:37  
	Control+Shift + Control_L  

	m:0x1 + c:50  
	Shift + Shift_L  

	m:0x0 + c:56  
	b  

m:0x0 + c:248  
NoSymbol  
```
  
++ `forward` - multiple detected output - select one  
```sh
	m:0x5 + c:114  
	Control+Shift + Right  

	m:0x5 + c:37  
	Control+Shift + Control_L  

	m:0x1 + c:50  
	Shift + Shift_L  

	m:0x0 + c:41  
	f  

m:0x0 + c:248  
NoSymbol  
```
  
x `play/pause` - undetected  
  
`stop`  
```sh
m:0x0 + c:174  
XF86AudioStop  
```
  
+++ `fullscreen` - multiple detected output - select one / combine to single  
```sh
	m:0xc + c:64  
	Control+Alt + Alt_L  

	m:0x4 + c:36  
	Control + Return  

	m:0x4 + c:248  
	Control + NoSymbol  

m:0x4 + c:37 + m:0x0 + c:12  
Control + Control_L + 3  
```
  
x `mute` - undetected  
  
++++ `vol-` - undetected but can be used  
```sh
(undetected)  
XF86AudioLowerVolume  
```

++++ `vol+` - undetected but can be used  
```sh
(undetected)  
XF86AudioRaiseVolume  
```
  
`tab`  
```sh
m:0x0 + c:23  
Tab  
```  

`up`  
```sh
m:0x0 + c:111  
Up  
```
  
xx `windows` - detected but not work  
```sh
m:0x40 + c:134  
Mod4 + Super_R  
```
  
`backspace`  
```sh
m:0x0 + c:22  
BackSpace  
```

`left`  
```sh
m:0x0 + c:113  
Left  
```

`enter`  
```sh
m:0x0 + c:36  
Return  
```

`right`  
```sh
m:0x0 + c:114  
Right  
```

`pageup`  
```sh
m:0x0 + c:112  
Prior  
```

\+`open` - double detected output - combine to single  
```sh
m:0x4 + c:37 + m:0x0 + c:32  
Control + Control_L + o  
```

`down`  
```sh
m:0x0 + c:116  
Down  
```

`esc`  
```sh
m:0x0 + c:9  
Escape  
```

`pagedown`  
```sh
m:0x0 + c:117  
Next  
```
  
`numlock`  
&nbsp; &nbsp; behaviors:  
&nbsp; &nbsp; _keep pointing ir to receiver on each press_  
&nbsp; &nbsp; `1st press` - alpha-numeric  
```sh
"NoCommand"  
	m:0x0 + c:38  
	a  
```
&nbsp; &nbsp; `2nd press` - shift-lock (uppercase)  
```sh
"NoCommand"  
	m:0x1 + c:50  
	Shift + Shift_L  
"NoCommand"  
	m:0x0 + c:38  
	a  
```
&nbsp; &nbsp; `3rd press` - shift-unlock (lowercase)  
```sh
"NoCommand"  
	m:0x5 + c:37  
	Control+Shift + Control_L  
"NoCommand"  
	m:0x1 + c:50  
	Shift + Shift_L  
"NoCommand"  
	m:0x0 + c:38  
	a  
```
&nbsp; &nbsp; `4th press` - normal  
```sh
"NoCommand"  
	m:0x0 + c:38111  
	Up  
```
  
x `switchwindow` - undetected  
  
\+ `mypc` - double detected output - combine to single  
```sh
m:0x40 + c:133 + m:0x0 + c:26  
Mod4 + Super_L + e  
```

\+ `desktop` - double detected output - combine to single  
```sh
m:0x40 + c:133 + m:0x0 + c:40  
Mod4 + Super_L + d  
```  
