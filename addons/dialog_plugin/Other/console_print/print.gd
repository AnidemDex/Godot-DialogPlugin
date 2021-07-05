"""
MIT License

Copyright (c) 2020 CassianoBelniak

This version was modified by AnidemDex, 2021.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

tool

const ESCAPE = ''
const COLOR_RESET = "[0m"

const BLACK = "[0;30m";
const RED = "[0;31m";
const GREEN = "[0;32m";
const YELLOW = "[0;33m";
const BLUE = "[0;34m";
const PURPLE = "[0;35m";
const CYAN = "[0;36m";
const WHITE = "[0;37m";
const BLACK_BOLD = "[1;30m";
const RED_BOLD = "[1;31m";
const GREEN_BOLD = "[1;32m";
const YELLOW_BOLD = "[1;33m";
const BLUE_BOLD = "[1;34m";
const PURPLE_BOLD = "[1;35m";
const CYAN_BOLD = "[1;36m";
const WHITE_BOLD = "[1;37m";
const BLACK_UNDERLINED = "[4;30m";
const RED_UNDERLINED = "[4;31m";
const GREEN_UNDERLINED = "[4;32m";
const YELLOW_UNDERLINED = "[4;33m";
const BLUE_UNDERLINED = "[4;34m";
const PURPLE_UNDERLINED = "[4;35m";
const CYAN_UNDERLINED = "[4;36m";
const WHITE_UNDERLINED = "[4;37m";
const BLACK_BACKGROUND = "[40m";
const RED_BACKGROUND = "[41m";
const GREEN_BACKGROUND = "[42m";
const YELLOW_BACKGROUND = "[43m";
const BLUE_BACKGROUND = "[44m";
const PURPLE_BACKGROUND = "[45m";
const CYAN_BACKGROUND = "[46m";
const WHITE_BACKGROUND = "[47m";
const BLACK_BRIGHT = "[0;90m";
const RED_BRIGHT = "[0;91m";
const GREEN_BRIGHT = "[0;92m";
const YELLOW_BRIGHT = "[0;93m";
const BLUE_BRIGHT = "[0;94m";
const PURPLE_BRIGHT = "[0;95m";
const CYAN_BRIGHT = "[0;96m";
const WHITE_BRIGHT = "[0;97m";
const BLACK_BOLD_BRIGHT = "[1;90m";
const RED_BOLD_BRIGHT = "[1;91m";
const GREEN_BOLD_BRIGHT = "[1;92m";
const YELLOW_BOLD_BRIGHT = "[1;93m";
const BLUE_BOLD_BRIGHT = "[1;94m";
const PURPLE_BOLD_BRIGHT = "[1;95m";
const CYAN_BOLD_BRIGHT = "[1;96m";
const WHITE_BOLD_BRIGHT = "[1;97m";
const BLACK_BACKGROUND_BRIGHT = "[0;100m";
const RED_BACKGROUND_BRIGHT = "[0;101m";
const GREEN_BACKGROUND_BRIGHT = "[0;102m";
const YELLOW_BACKGROUND_BRIGHT = "[0;103m";
const BLUE_BACKGROUND_BRIGHT = "[0;104m";
const PURPLE_BACKGROUND_BRIGHT = "[0;105m";
const CYAN_BACKGROUND_BRIGHT = "[0;106m";
const WHITE_BACKGROUND_BRIGHT = "[0;107m";

static func clear_console():
	match OS.get_name():
		'Windows': printraw(ESCAPE + 'c')
		_: printraw(ESCAPE + 'c')

static func _get_string(what, divider = ""):
	var string := ""
	if what is Array:
		for thing in what:
			string += String(thing) + divider
	elif what is String:
		string = what
	else:
		string = String(what)
	return string


static func line(color, what) -> void:
	set_color(color)
	print(_get_string(what))
	reset()


static func raw(color, what) -> void:
	set_color(color)
	printraw(_get_string(what))
	reset()

static func s(color, what) -> void:
	set_color(color)
	print(_get_string(what, " "))
	reset()

static func t(color, what) -> void:
	set_color(color)
	print(_get_string(what, "   "))
	reset()

static func debug(color, what) -> void:
	set_color(color)
	print(_get_string(what))
	print_stack()
	reset()

static func set_color(color):
	printraw(color)

static func reset():
	printraw(ESCAPE + COLOR_RESET)
