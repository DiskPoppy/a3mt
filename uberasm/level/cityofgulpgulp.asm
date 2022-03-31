!waterTimer = $13E6|!addr  ;free RAM, must be shared with the water activator sprite

;init:
;STZ !waterTimer  ;only in case you change free RAM to one not reset on level load
;RTL

main:
LDA !waterTimer
BEQ +
LDA #$01
STA $85  ;water level flag
LDA $14
AND #$03  ;only decrement the timer once per 4 frames
BNE .dontdec
DEC !waterTimer
.dontdec
RTL
+
STZ $85  ;water level flag
RTL
