#!/bin/bash
#
# auto-login as SWAdmin on ensnb

keys=' 	space
!	exclam
"	quotedbl
#	numbersign
$	dollar
%	percent
&	ampersand
'"'"'	apostrophe
'"'"'	quoteright
(	parenleft
)	parenright
*	asterisk
+	plus
,	comma
-	minus
.	period
/	slash
0	0
1	1
2	2
3	3
4	4
5	5
6	6
7	7
8	8
9	9
:	colon
;	semicolon
<	less
=	equal
>	greater
?	question
@	at
A	A
B	B
C	C
D	D
E	E
F	F
G	G
H	H
I	I
J	J
K	K
L	L
M	M
N	N
O	O
P	P
Q	Q
R	R
S	S
T	T
U	U
V	V
W	W
X	X
Y	Y
Z	Z
[	bracketleft
\	backslash
]	bracketright
^	asciicircum
_	underscore
`	grave
`	quoteleft
a	a
b	b
c	c
d	d
e	e
f	f
g	g
h	h
i	i
j	j
k	k
l	l
m	m
n	n
o	o
p	p
q	q
r	r
s	s
t	t
u	u
v	v
w	w
x	x
y	y
z	z
{	braceleft
|	bar
}	braceright
~	asciitilde
 	nobreakspace
¡	exclamdown
¢	cent
£	sterling
¤	currency
¥	yen
¦	brokenbar
§	section
¨	diaeresis
©	copyright
ª	ordfeminine
«	guillemotleft
¬	notsign
­	hyphen
®	registered
¯	macron
°	degree
±	plusminus
²	twosuperior
³	threesuperior
´	acute
µ	mu
¶	paragraph
·	periodcentered
¸	cedilla
¹	onesuperior
º	masculine
»	guillemotright
¼	onequarter
½	onehalf
¾	threequarters
¿	questiondown
à	Agrave
á	Aacute
â	Acircumflex
ã	Atilde
Ä	Adiaeresis
å	Aring
æ	AE
ç	Ccedilla
è	Egrave
é	Eacute
ê	Ecircumflex
ë	Ediaeresis
ì	Igrave
í	Iacute
î	Icircumflex
ï	Idiaeresis
ð	ETH
ð	Eth
ñ	Ntilde
ò	Ograve
ó	Oacute
ô	Ocircumflex
õ	Otilde
Ö	Odiaeresis
×	multiply
ø	Oslash
ø	Ooblique
ù	Ugrave
ú	Uacute
û	Ucircumflex
Ü	Udiaeresis
ý	Yacute
þ	THORN
þ	Thorn
ß	ssharp
à	agrave
á	aacute
â	acircumflex
ã	atilde
ä	adiaeresis
å	aring
æ	ae
ç	ccedilla
è	egrave
é	eacute
ê	ecircumflex
ë	ediaeresis
ì	igrave
í	iacute
î	icircumflex
ï	idiaeresis
ð	eth
ñ	ntilde
ò	ograve
ó	oacute
ô	ocircumflex
õ	otilde
ö	odiaeresis
÷	division
ø	oslash
ø	ooblique
ù	ugrave
ú	uacute
û	ucircumflex
ü	udiaeresis
ý	yacute
þ	thorn
ÿ	ydiaeresis
'

getpasswd(){
    ssh -o PasswordAuthentication=no sim swadminpassword.sh
}

splitpasswd(){
    getpasswd | sed 's/./& /g'
}

escape(){
    local char="$1"
    sed -r -n "s/^[$char]\s+(\S+)$/\1/p" <<< "$keys" | head -1
}

xdotoolescapedpasswd(){
    splitpasswd | while read -n 1 char; do
        (( ${#char} > 0 )) && escape "$char"
    done | xargs
}

xdotool mousemove --sync 0 500 \
    key S W A d m i n \
    key Tab \
    key `xdotoolescapedpasswd` \
    key Return
