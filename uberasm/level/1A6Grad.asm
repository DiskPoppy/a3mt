;=======================================
; Mode 2 + Mode 0 COLDATA Gradient
; Channels: Red, Green, Blue
; Table Size: 79
; No. of Writes: 224
; 
; Generated by GradientTool
;=======================================

; Set up the HDMA gradient.
; Uses HDMA channels 3 and 4.
init:
	REP   #$20 ; 16-bit A

	; Set transfer modes.
	LDA   #$3202
	STA   $4330 ; Channel 3
	LDA   #$3200
	STA   $4340 ; Channel 4

	; Point to HDMA tables.
	LDA   #Gradient1_RedGreenTable
	STA   $4332
	LDA   #Gradient1_BlueTable
	STA   $4342

	SEP   #$20 ; 8-bit A

	; Store program bank to $43x4.
	PHK
	PLA
	STA   $4334 ; Channel 3
	STA   $4344 ; Channel 4

	; Enable channels 3 and 4.
	LDA.b #%00011000
	TSB   $6D9F

	RTL ; <-- Can also be RTL.

; --- HDMA Tables below this line ---
Gradient1_RedGreenTable:
db $80,$20,$40
db $3D,$20,$40
db $03,$21,$40
db $01,$21,$41
db $02,$22,$41
db $01,$23,$41
db $02,$24,$41
db $01,$25,$42
db $02,$26,$42
db $02,$27,$42
db $02,$28,$43
db $8C,$29,$43,$2A,$44,$2B,$44,$2C,$45,$2C,$46,$2D,$46,$2E,$47,$2F,$48,$30,$48,$32,$49,$33,$4A,$34,$4B
db $07,$36,$4C
db $00

Gradient1_BlueTable:
db $80,$80
db $4F,$80
db $02,$81
db $03,$82
db $02,$83
db $83,$84,$85,$86
db $07,$87
db $00