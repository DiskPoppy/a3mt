!Tile = $00

!waterTimer = $13E6|!addr  ;free RAM, must be shared with the uberasm for the levels that use it


print "INIT ", pc
RTL

print "MAIN ", pc
PHB
PHK
PLB

JSR Graphics

LDA $9D
BNE .return

LDA $14
AND #$01
BNE .endUpdateAccel
LDA !sprite_misc_151c,x
AND #$01
TAY
LDA !sprite_speed_y,x
CLC : ADC Accel,y
STA !sprite_speed_y,x
CMP MaxSpeed,y
BNE +
INC !sprite_misc_151c,x
+
.endUpdateAccel
JSL $01801A|!bank  ;update y speed
LDA #$00
%SubOffScreen()

.return
PLB
RTL

Accel:
db $FF,$01
MaxSpeed:
db $F0,$10

Graphics:
%GetDrawInfo()
LDA $00
STA $0300|!addr,y
LDA $01
STA $0301|!addr,y
LDA #!Tile
STA $0302|!addr,y
LDA !sprite_oam_properties,x
ORA $64
STA $0303|!addr,y
LDY #$02
LDA #$00
%FinishOAMWrite()
RTS
