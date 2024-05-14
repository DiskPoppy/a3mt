!screen_num = $0D

load:
	STZ $14AF|!addr				; Reset switch status to "On".
	RTL

init:
	JSL freescrollbabey_init
	JSL RequestRetry_init
	RTL

main:
	LDA ($19B8+!screen_num)|!addr
	STA $0C
	LDA ($19D8+!screen_num)|!addr
	STA $0D
	JSL MultipersonReset_main

	LDA #%00110000 : STA $00	;\ Retry if pressing L+R.
	JSL RequestRetry_main		;/
	RTL