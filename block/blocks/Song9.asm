;~@sa1 <-- DO NOT REMOVE THIS LINE!
db $42

!song = #$BA ;change this for the song that you want.

JMP Mario : JMP Mario : JMP Mario
JMP Nothing : JMP Nothing
JMP Nothing : JMP Nothing
JMP Mario : JMP Mario : JMP Mario

Mario:
	LDA !song				; \ Change This to the song that you want to change(If you put $00 the music will not change)
	STA $7DFB				; /
Nothing:
RTL

	print "Homestuck - Showtime"