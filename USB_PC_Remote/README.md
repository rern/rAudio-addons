# Rune - USB PC Remote

With [**XBindkeys**](http://www.nongnu.org/xbindkeys/) (already included with Rune)

For [less than $4 on ebay](http://www.ebay.com/sch/i.html?_from=R40&_trksid=p2050601.m570.l1313.TR0.TRC0.H0.Xusb+pc+remote.TRS0&_nkw=usb+pc+remote&_sacat=0), this remote set was detected and can be used as a keyboard and a mouse.

- Use as a mouse in RuneUI: edit use_cursor no to yes in /root/.xinitrc
- Use as a keyboard to select an OS in NOOBS boot menu.

_Use in Kodi without any settings. (no more CEC hassels)_

![remote](https://github.com/rern/RuneAudio/blob/master/USB_PC_Remote/irremote.jpg)

The following code assigns 6 keys:  

key         | function
------------|----------------
`left`      | previous track
`enter`     | play / pause
`right`     | next track
`up`        | forward (@10s)
`down`      | reverse (@10s)
`backspace` | stop  

- Switch or add more as you like
- Not includes keys that not working: `red` `skipback` `skipnext` `play/pause` `mute` `vol-` `vol+` `switchwindow` `windows`
- Read carefully for `color`s and `numlock` buttons.

#

**How To**

Replace `/root/.xbindkeysrc`

#

**Power on / off audio equipments**

Install [**RuneUI GPIO**](https://github.com/rern/RuneUI_GPIO) and add these commands to desire buttons.

Such as:
```bash
#<www> power on
"php /srv/http/gpioon.php"
   m:0x0 + c:180

#<close> power off
"php /srv/http/gpiooff.php"
   m:0x8 + c:64 + m:0x0 + c:70

```

#

If you want a customizable remote, you need this:

- [**JP1 Remote**](http://www.hifi-remote.com/wiki/index.php?title=JP1_-_Just_How_Easy_Is_It%3F_-_RM-IR_Version) - The ultimate solution of a remote
- It's like Raspberry Pi of ir remote world.
