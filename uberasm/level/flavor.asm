load:
	JSL MultipersonReset_load
	RTL

init:
	JSL InitSpriteFacing_init
	JSL start_select_init
	RTL

main:
	JSL BG_AutoScroll7B_main
	JSL start_select_main

	; Reload the room upon death.
	LDA $010B|!addr
	STA $0C
	LDA $010C|!addr
	ORA #$04
	STA $0D
	JSL MultipersonReset_main
.return
	RTL
