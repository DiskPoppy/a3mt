; Gamemode 0C

init:

; Reset various counters.
.counterbreak:
if !counterbreak_yoshi
    stz $13C7|!addr
    stz $187A|!addr
endif

if !counterbreak_powerup
    ; Reset powerup.
    stz $19
endif

if !counterbreak_item_box
    ; Reset item box.
    stz $0DC2|!addr
endif

if !counterbreak_coins
    ; Reset coin counter.
    stz $0DBF|!addr
endif

if !counterbreak_bonus_stars
    ; Reset bonus stars counter.
    stz $0F48|!addr
    stz $0F49|!addr
endif

if !counterbreak_score
    ; Reset score counter.
    rep #$20
    stz $0F34|!addr
    stz $0F36|!addr
    stz $0F38|!addr
    sep #$20
endif

; Reset the current level's checkpoint if the level was beaten.
.reset_checkpoint:
    ; Skip if the level wasn't just beaten.
    lda $0DD5|!addr : beq ..skip
                      bmi ..skip

    ; Remove the checkpoint for the current level.
    jsr shared_reset_checkpoint

..skip:
    lda $13BF|!addr							;\ Load the translevel number.
    cmp #$36 : beq +						;| If not Level 112,
    cmp #$45 : beq +						;| or Level 121, 
    cmp #$54 : bne ++						;/ or Level 130, then return.
+
    lda $0F3F|!addr							;\ Restore the saved Yoshi status (and its color).
	sta $0DC1|!addr : sta $13C7|!addr		;/
    stz $0F3F|!addr : stz $0F3E|!addr		;> Reset the free RAM addresses.
++
    rtl
