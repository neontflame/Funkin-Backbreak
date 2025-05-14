@echo off
title Backbreak Engine Compile Helper
type ascii.txt
title Backbreak Engine Compile Helper - Installing haxelibs
echo Installing haxelibs
haxelib set flixel-addons 3.3.0
haxelib set flixel-tools 1.5.1
haxelib set flixel-ui 2.6.1
haxelib set flixel 5.7.2
haxelib set lime 8.1.3
haxelib set openfl 9.4.1
haxelib set hxvlc 2.1.4
haxelib set hxcpp 4.3.2
haxelib set hscript-iris 1.1.3
haxelib git flxanimate https://github.com/FixedData/flxanimate
echo Building game
title Backbreak Engine Compile Helper - Building game
lime test windows
echo.
echo Ready!
pause