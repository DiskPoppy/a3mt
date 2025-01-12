db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioInside : JMP MarioHead

!Sprite = $74	; sprite number
!IsCustom = 0	; 0 for normal, 1 for a custom sprite
!GIEPY = 1		; Set this to 1 if you use GIEPY
!ExtraBit = 0	; extra bit activated, should be 1
!Group = 0		; group number/extra byte, should range from 0-3
!State = $08	; $08 for normal, $09 for carryable sprites
!1540_val = $3E	; If you use powerups, this should be $3E
				; Carryable sprites uses it as the stun timer

!ExtraByte1 = $00	; First extra byte (only applyable if extra bytes are enabled)
!ExtraByte2 = $00	; Second extra byte
!ExtraByte3 = $00	; Third extra byte
!ExtraByte4 = $00	; Fourth extra byte

!XPlacement = $00	; Remember: $01-$7F moves the sprite to the right and $80-$FF to the left.
!YPlacement = $00	; Remember: $01-$7F moves the sprite to the bottom and $80-$FF to the top.

!SoundEffect = $02
!APUPort = $1DFC|!addr

!bounce_num			= $03	; See RAM $1699 for more details. If set to 0, the block changes into the Map16 tile directly
!bounce_direction	= $00	; Should be generally $00
!bounce_block		= $0D	; See RAM $9C for more details. Can be set to $FF to change the tile manually
!bounce_properties	= $00	; YXPPCCCT properties

; If !bounce_block is $FF.
!bounce_Map16 = $0132		; Changes into the Map16 tile directly (also used if !bounce_num is 0x00)
!bounce_tile = $2A			; The tile number (low byte) if BBU is enabled

!item_memory_dependent = 0	; Makes the block stay collected
!InvisibleBlock = 0			; Not solid, doesn't detect sprites, can only be hit from below
!ActivatePerSpinJump = 0	; Activatable with a spin jump (doesn't work if invisible)
; 0 for false, 1 for true

if !ActivatePerSpinJump
MarioCorner:
MarioAbove:
	LDA $140D|!addr
	BEQ Return
	LDA $7D
	BMI Return
	LDA #$D0
	STA $7D
	BRA Cape
else
MarioCorner:
MarioAbove:
endif

Return:
MarioSide:
Fireball:
MarioInside:
MarioHead:

if !InvisibleBlock
SpriteH:
SpriteV:
Cape:
RTL


MarioBelow:
	LDA $7D
	BPL Return
else
RTL

SpriteH:
	%check_sprite_kicked_horizontal()
	BCS SpriteShared
RTL

SpriteV:
	LDA !14C8,x
	CMP #$09
	BCC Return
	LDA !AA,x
	BPL Return
	LDA #$10
	STA !AA,x

SpriteShared:
	%sprite_block_position()

MarioBelow:
Cape:
endif

SpawnItem:
	PHX
	PHY
if !bounce_num
	if !bounce_block == $FF
		LDA #!bounce_tile
		STA $02
		LDA.b #!bounce_Map16
		STA $03
		LDA.b #!bounce_Map16>>8
		STA $04
	endif
	LDA #!bounce_num
	LDX #!bounce_block
	LDY #!bounce_direction
	%spawn_bounce_sprite()
	LDA #!bounce_properties
	STA $1901|!addr,y
else
	REP #$10
	LDX #!bounce_Map16
	%change_map16()
	SEP #$10
endif

if !item_memory_dependent == 1
	PHK
	PEA .jsl_2_rts_return-1
	PEA $84CE
	JML $00C00D|!bank
.jsl_2_rts_return
	SEP #$10
endif

	LDA #!SoundEffect
	STA !APUPort

	JSR Spawn_Sprite
	BCS Return2
	TAX
	if !XPlacement
		LDA #!XPlacement
		STA $00
	else
		STZ $00
	endif
	if !YPlacement
		LDA #!YPlacement
		STA $01
	else
		STZ $01
	endif
	TXA
	%move_spawn_relative()

	LDA #!1540_val
	STA !1540,x
	LDA #$D0
	STA !AA,x
	LDA #$2C
	STA !154C,x

	LDA #!ExtraByte1
	STA !sprite_extra_byte1,x
	LDA #!ExtraByte2
	STA !sprite_extra_byte2,x
	LDA #!ExtraByte3
	STA !sprite_extra_byte3,x
	LDA #!ExtraByte4
	STA !sprite_extra_byte4,x

	LDA !190F,x
	BPL Return2
	LDA #$10
	STA !15AC,x

Return2:
	PLY
	PLX
RTL

Spawn_Sprite:
	JSL $02A9E4|!bank
	BMI .no_sprite_found
	TYX
	STX $185E|!addr
	LDA #!Sprite
	STA !9E,x
	JSL $07F7D2|!bank
if !IsCustom
	if !GIEPY
		LDA !9E,x
		STA !7FAB9E,x
		LDA.b #$80|(!Group<<2)
		STA !7FAB10,x
		JSL $0187A7|!bank
	else
		!ExtraBit #= !ExtraBit&1
		LDA !9E,x
		STA !7FAB9E,x
		JSL $0187A7|!bank
		LDA.b #2|(!ExtraBit<<2)
		STA !7FAB10,x
	endif
endif
	LDA #!State
	STA !14C8,x
	TXA
	CLC
RTS
.no_sprite_found
	SEC
RTS

print "Spawns enemy sprite $",hex(!Sprite),"."