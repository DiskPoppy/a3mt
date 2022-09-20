!waterTimer = $1864|!addr  ;free RAM, must be shared with the water activator sprite

init:
;STZ !waterTimer  ;only in case you change free RAM to one not reset on level load

STZ $2121
LDA $0701|!addr  ;bg color
STA $2122
LDA $0702|!addr  ;bg color
STA $2122

LDA #%10110101
STA $40  ;CGADSUB mirror

LDA #%00010101
STA $212C  ;TM
STA $212E  ;TMW
LDA #%00000010
STA $212D  ;TS
STA $212F  ;TSW

RTL


main:
LDA #%00010101
STA $212C  ;TM
STA $212E  ;TMW
LDA #%00000010
STA $212D  ;TS
STA $212F  ;TSW

LDA $9D  ;lock sprites
ORA $13D4|!addr  ;pause
BNE .dontdec

LDA !waterTimer
BEQ .dry
.wet
LDA #$64
STA $0701|!addr  ;bg color
STZ $0702|!addr  ;bg color

LDA #$01
STA $85  ;water level flag
LDA $14
AND #$03  ;only decrement the timer once per 4 frames
BNE .dontdec
DEC !waterTimer
.dontdec
RTL

.dry
STZ $0701|!addr  ;bg color
STZ $0702|!addr  ;bg color

STZ $85  ;water level flag
RTL
