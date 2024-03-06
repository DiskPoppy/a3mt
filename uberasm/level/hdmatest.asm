load:
	JSL NoStatus_load
	LDA #$01			;\ Always keep Demo big.
	STA $19				;/
	LDA #$01
	STA $1477|!addr
	RTL

init:
	JSL DisableDeathCounter_init
	JSL Layer2Horz_init
	JSL Layer1Vert_init
	RTL

main:
	
	JSL Layer2Horz_main
	JSL Layer1Vert_main
	STZ $0DC2|!addr		;> Remove item reserve.
	LDA $71				;\ If dying...
	CMP #$09			;/
	BNE .return
	LDA #$06			;\ 
	STA $71				;| ...then teleport Demo.
	STZ $89				;| Change if you want (Because it uses the current screen exit dunno if you want that)
	STZ $88				;/
	STZ $1496|!addr
.return
	RTL

status_bar:
	;JSL GrayscalePalette_main
	RTL
