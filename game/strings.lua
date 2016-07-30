local strings = {}

local ram = require "game.ram"

-- Copied from charmap.asm
local CHAR_MAP = {
	[0x00] =  "<START>",
	[0x14] =  "<PLAY_G>",
	[0x15] =  "<DAY>",
	[0x1f] =  "¯",
	[0x22] =  "<LNBRK>",
	[0x24] =  "<POKE>",
	[0x25] =  "%",
	[0x38] =  "<RED>",
	[0x39] =  "<GREEN>",
	[0x3f] =  "<ENEMY>",
	[0x3f] =  "<SHINY>",
	[0x49] =  "<MOM>",
	[0x4a] =  "<PKMN>",
	[0x4e] =  "<NEXT>",
	[0x4f] =  "<LINE>",

	[0x50] =  "@",
	[0x51] =  "<PARA>",
	[0x52] =  "<PLAYER>",
	[0x53] =  "<RIVAL>",
	[0x54] =  "#",
	[0x55] =  "<CONT>",
	[0x56] =  "<......>",
	[0x57] =  "<DONE>",
	[0x58] =  "<PROMPT>",
	[0x59] =  "<TARGET>",
	[0x5a] =  "<USER>",
	[0x5b] =  "<PC>",
	[0x5c] =  "<TM>",
	[0x5d] =  "<TRNER>",
	[0x5e] =  "<ROCKET>",
	[0x5f] =  "<DEXEND>",

	[0x61] =  "?",
	[0x62] =  "_",
	[0x6d] =  "<COLON>",
	[0x6e] =  "'",
	[0x6e] =  "<LV>",
	[0x6f] =  "?",

	[0x70] =  "<PO>",
	[0x71] =  "<KE>",
	[0x71] =  "?",
	[0x72] =  "<``>",
	[0x73] =  "<''>",
	[0x73] =  "<ID>",
	[0x74] =  "?",
	[0x75] =  "…",

	[0x79] =  "+",
	[0x7a] =  "-",
	[0x7b] =  "+",
	[0x7c] =  "¦",
	[0x7d] =  "+",
	[0x7e] =  "+",
	[0x7f] =  " ",

	[0x80] =  "A",
	[0x81] =  "B",
	[0x82] =  "C",
	[0x83] =  "D",
	[0x84] =  "E",
	[0x85] =  "F",
	[0x86] =  "G",
	[0x87] =  "H",
	[0x88] =  "I",
	[0x89] =  "J",
	[0x8a] =  "K",
	[0x8b] =  "L",
	[0x8c] =  "M",
	[0x8d] =  "N",
	[0x8e] =  "O",
	[0x8f] =  "P",
	[0x90] =  "Q",
	[0x91] =  "R",
	[0x92] =  "S",
	[0x93] =  "T",
	[0x94] =  "U",
	[0x95] =  "V",
	[0x96] =  "W",
	[0x97] =  "X",
	[0x98] =  "Y",
	[0x99] =  "Z",

	[0x9a] =  "(",
	[0x9b] =  ")",
	[0x9c] =  ":",
	[0x9d] =  ";",
	[0x9e] =  "[",
	[0x9f] =  "]",

	[0xa0] =  "a",
	[0xa1] =  "b",
	[0xa2] =  "c",
	[0xa3] =  "d",
	[0xa4] =  "e",
	[0xa5] =  "f",
	[0xa6] =  "g",
	[0xa7] =  "h",
	[0xa8] =  "i",
	[0xa9] =  "j",
	[0xaa] =  "k",
	[0xab] =  "l",
	[0xac] =  "m",
	[0xad] =  "n",
	[0xae] =  "o",
	[0xaf] =  "p",
	[0xb0] =  "q",
	[0xb1] =  "r",
	[0xb2] =  "s",
	[0xb3] =  "t",
	[0xb4] =  "u",
	[0xb5] =  "v",
	[0xb6] =  "w",
	[0xb7] =  "x",
	[0xb8] =  "y",
	[0xb9] =  "z",

	[0xc0] =  "Ä",
	[0xc1] =  "Ö",
	[0xc2] =  "Ü",
	[0xc3] =  "ä",
	[0xc4] =  "ö",
	[0xc5] =  "ü",

	[0xd0] =  "'d",
	[0xd1] =  "'l",
	[0xd2] =  "'m",
	[0xd3] =  "'r",
	[0xd4] =  "'s",
	[0xd5] =  "'t",
	[0xd6] =  "'v",

	[0xdf] =  "?",
	[0xe0] =  "'",
	[0xe1] =  "<PK>",
	[0xe2] =  "<MN>",
	[0xe3] =  "-",

	[0xe6] =  "?",
	[0xe7] =  "!",
	[0xe8] =  ".",
	[0xe9] =  "&",

	[0xea] =  "é",
	[0xeb] =  "?",
	[0xec] =  "?",
	[0xed] =  "?",
	[0xee] =  "?",
	[0xef] =  "?",
	[0xf0] =  "¥",
	[0xf1] =  "×",
	[0xf2] =  "·",
	[0xf3] =  "/",
	[0xf4] =  ",",
	[0xf5] =  "?",

	[0xf6] =  "0",
	[0xf7] =  "1",
	[0xf8] =  "2",
	[0xf9] =  "3",
	[0xfa] =  "4",
	[0xfb] =  "5",
	[0xfc] =  "6",
	[0xfd] =  "7",
	[0xfe] =  "8",
	[0xff] =  "9",
}

function strings.parse(pointer, bank)
	local string = ""

	local i = 0
	while true do
		local byte = ram.byteBank(pointer + i, bank)

		local char = CHAR_MAP[byte]
		if char == nil then
			error("invalid character: "..bizstring.hex(byte))
		end

		if char == "@" then
			return string, i
		end

		string = string..char
		i = i + 1
	end
end

return strings
