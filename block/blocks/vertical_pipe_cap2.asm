;> PSI Ninja edit: Made compatible with SA-1.

;acts like $130
db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape
JMP MarioFireBall : JMP TopCorner : JMP BodyInside : JMP HeadInside

print "This is the no yoshi/sprite vertical pipe cap 2/2"

TopCorner:
MarioAbove:
MarioSide:
HeadInside:
BodyInside:
MarioBelow:
	LDA $1470|!addr	;\if carrying/on yoshi, then cement
	ORA $148F|!addr	;|
	ORA $187A|!addr	;|
	BNE cement	;/

	LDY #$01	;\otherwise act like the 2/2 of vertical pipe
	LDA #$38	;|
	STA $1693|!addr	;/
	BRA return
cement:
SpriteV:
SpriteH:
MarioFireBall:
	LDY #$01
	LDA #$30
	STA $1693|!addr
MarioCape:
return:
RTL
