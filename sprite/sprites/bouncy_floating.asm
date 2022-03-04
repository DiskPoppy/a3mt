;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; SMW Floating Platforms (sprites 5B & 5C), by imamelia
;; Modified by Disk Poppy to make them bouncy.
;;
;; This is a disassembly of sprites 5B and 5C in SMW, floating platforms.
;;
;; Uses first extra bit: YES
;;
;; If the extra bit is clear, this will act like sprite 5B, a wooden platform.  If the
;; extra bit is set, this will act like sprite 5C, a checkerboard platform.  You must
;; set sprite buoyancy on for these to work.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; defines and tables
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Tile = $00
!BigBounceSpeed = $B0
!SmallBounceSpeed = $D0
!BounceSFX = $08

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; init routine
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print "INIT ",pc
RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; main routine wrapper
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print "MAIN ",pc
PHB
PHK
PLB
JSR FloatingPlatformMain
PLB
RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; main routine
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FloatingPlatformMain:

LDA $9D			;
BEQ NoSkip1		; if sprites are locked...
JMP SkipToGFX		; skip directly to the GFX routine

NoSkip1:			;

LDA !1588,x		; check the sprite's blocked status
AND #$0C		; if the sprite is touching the ceiling or floor...
BNE NoUpdateY		; don't update its Y position

JSL $01801A|!bank		; update sprite Y position without gravity

NoUpdateY:		;

STZ $1491|!Base2		; reset the "prevent sliding on a platform" flag

; removed sprite number check for the spike ball (CMP #$A4)

LDA !AA,x		; check the sprite Y speed
CMP #$40			; if it is greater than 40...
BPL NoIncYSpeed		; don't increment it
INC !AA,x		; if it is 40 or less, increment it
NoIncYSpeed:		;
LDA !164A,x		; if the sprite isn't in water or lava...
BEQ NoDecYSpeed		; don't do some subsequent Y speed checks

; another removed sprite number check

LDA !AA,x		; check the sprite's Y speed
BPL DecYSpeed		; if positive, decrement it
CMP #$F8			; also decrement it if it is negative
BCC NoDecYSpeed		; and no less than F8
DecYSpeed:		;
SEC			;
SBC #$02			; decrement the sprite's Y speed by 2
STA !AA,x		;

NoDecYSpeed:

STZ $185E|!Base2
LDA $7D
STA $00
BMI NoContact		; branch if the player isn't on the sprite

; removed sprite number check

JSL $01A7DC|!bank	; check contact with player
BCC NoContact

LDY #!BigBounceSpeed
LDA $15
BMI +			; if A or B held, skip
LDY #!SmallBounceSpeed
+
STY $7D			; bounce player

LDA #!BounceSFX
STA $1DFC|!Base2

INC $185E|!Base2		;
LDA $00			; check the value from before
LSR			;
LSR			;
STA !AA,x		; set the Y speed *again* (surely Nintendo could have done this better)

NoContact:		;

LDA $185E|!Base2		;
CMP !151C,x		; not sure what the purpose of this is
STA !151C,x		;
BEQ SkipYSpd2		;
LDA $185E|!Base2		;
BNE SkipYSpd2		; or this
LDA $7D			;
BPL SkipYSpd2		; branch if the player is moving downward

LDY #$08			; start Y at 08
LDA $19			; if the player is small...
BNE NotSmall2		;
LDY #$06			; use Y = 06 instead
NotSmall2:		;
STY $00			;

LDA !AA,x		; ANOTHER Y speed check?!
CMP #$20			;
BPL SkipYSpd2		; branch if the sprite Y speed is greater than 20...
CLC			;
ADC $00			; Good gravy, how many times are they going to change the Y speed in this thing?
STA !AA,x		;

SkipYSpd2:		;

LDA $13			;
AND #$01		;
BNE SkipToGFX		; skip the next part every other frame

LDA !AA,x		; check the Y speed AGAIN
BEQ NoChangeYSpd1	;
BPL NoIncYSpd2		;
CLC			;
ADC #$02		;
NoIncYSpd2:		; there HAS to be a better way of doing this...
SEC			;
SBC #$01			; because we totally haven't already messed with the sprite's Y speed enough,
STA !AA,x		; we'll set it again

NoChangeYSpd1:		;

LDY $185E|!Base2		; I'd put an enlightening comment here,
BEQ SkipYSpd3		; but your guess is as good as mine.
LDY #$05			;
LDA $19			; Hey, kids! Let's play the "set Y to a number depending on whether or not
BNE SkipYSpd3		; the player is small" game again!
LDY #$02			; This time, our lovely numbers are 05 and 02!
SkipYSpd3:		;
STY $00			;

LDA !D8,x		;
PHA			; save the sprite Y position...this can't be good...
SEC			;
SBC $00			;
STA !D8,x		; Okay, so...apparently we're messing with the sprite's Y position
LDA !14D4,x		; as well as its speed.  Wonderful.
PHA			;
SBC #$00			;
STA !14D4,x		; looks like we want to offset the sprite's Y position...

JSL $019138|!bank		; so that it will use a different base position when interacting with objects.

PLA			; pull back stuff
STA !14D4,x		;
PLA			; All this just to make the sprite float?
STA !D8,x		; Nintendo, you fail.

SkipToGFX:		;

LDA #$00
%SubOffScreen()		; Whoa! Something that we actually semi-know what it does!

; removed sprite check

FloatingPlatformGFX:

%GetDrawInfo()
LDA $00
STA $0300|!Base2,y		; set the tile X displacement
LDA $01
STA $0301|!Base2,y		; set the tile Y displacement
LDA #!Tile
STA $0302|!Base2,y
LDA $64			; priority
ORA !15F6,x		; no hardcoded palette
STA $0303|!Base2,y	; properties
LDA #$00			; 1 tile to draw
LDY #$02			; the tile is 16x16
%FinishOAMWrite()
RTS
