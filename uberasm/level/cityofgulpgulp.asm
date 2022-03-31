!waterTimer = $13E6|!addr  ;free RAM, must be shared with the water activator sprite

;init:
;STZ !waterTimer  ;only in case you change free RAM to one not reset on level load
;RTL

main:
LDA !waterTimer
BEQ +
LDA #$01
STA $85  ;water level flag
DEC !waterTimer
RTL
+
STZ $85  ;water level flag
RTL
