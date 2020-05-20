;;
; CUTSCENE_S_FLAME_OF_DESTRUCTION
flameOfDestructionCutsceneBody:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw bank3Cutscene_state0
	.dw flameOfDestructionCutscene_state1

;;
; CUTSCENE_S_ZELDA_VILLAGERS
zeldaAndVillagersCutsceneBody:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw bank3Cutscene_state0
	.dw zeldaAndVillagersCutscene_state1

;;
; CUTSCENE_S_ZELDA_KIDNAPPED
zeldaKidnappedCutsceneBody:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw bank3Cutscene_state0
	.dw zeldaKidnappedCutscene_state1

bank3Cutscene_state0:
	ld b,$10
	ld hl,wGenericCutscene.cbb3
	call clearMemory
	call clearWramBank1
	xor a
	ld (wDisabledObjects),a
	ld a,$80
	ld (wMenuDisabled),a
	ld a,$01
	ld (wCutsceneState),a
	ret

flameOfDestructionCutscene_state1:
	ld a,(wGenericCutscene.cbb3)
	rst_jumpTable
	.dw @fadeToBlack
	.dw @roomOfRitesStart
	.dw @flashScreen
	.dw @changePalettes
	.dw @startCutsceneText08
	.dw @startFadeInAndLightTorch
	.dw @createSomeObjects
	.dw @startCutsceneText09
	.dw @startCutsceneText0a
	.dw @startCutsceneText0b
	.dw @startCutsceneText0c
	.dw @finish

@fadeToBlack:
	ld a,$28
	ld (wGenericCutscene.cbb5),a
	call fastFadeoutToBlack
	jp _incTmpcbb3

@roomOfRitesStart:
	call _waitUntilFadeIsDone
	ret nz
	call bank3CutsceneLoadRoomOfRites
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_TWINROVA_FLAME
	inc l
	ld (hl),$03
+
	ld a,$13
	call loadGfxRegisterStateIndex
	ld a,SND_LIGHTNING
	call playSound
	xor a
	ld (wGenericCutscene.cbb5),a
	ld (wGenericCutscene.cbb6),a
	dec a
	ld (wGenericCutscene.cbba),a
	call _incTmpcbb3

@flashScreen:
	ld hl,wGenericCutscene.cbb5
	ld b,$04
	call flashScreen
	ret z
	call clearPaletteFadeVariablesAndRefreshPalettes
	jp _incTmpcbb3

@changePalettes:
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_TWINROVA_FLAME
	inc l
	ld (hl),$04
+
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld a,$04
	ld (wGenericCutscene.cbb5),a
	call _clearFadingPalettes
	ld a,$ef
	ldh (<hSprPaletteSources),a
	ldh (<hDirtySprPalettes),a
	jp _incTmpcbb3

@startCutsceneText08:
	ld hl,wGenericCutscene.cbb5
	dec (hl)
	ret nz
	ld a,$04
	ld (wTextboxFlags),a
	ld c,<TX_5008
	jp showCutscene50xxText

@fadeInAndLightTorch:
	call fastFadeinFromBlack
	ld a,b
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a
	xor a
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	ld a,SND_LIGHTTORCH
	jp playSound

@startFadeInAndLightTorch:
	call _waitUntilTextInactive
	ret nz
	ld b,$40
	call @fadeInAndLightTorch
	ld a,$1e
	ld (wGenericCutscene.cbb5),a
	jp _incTmpcbb3

@createSomeObjects:
	call _waitUntilFadeIsDone
	ret nz
	call fadeinFromBlack
	ld a,$af
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a
	xor a
	ld ($cfc6),a
	call cutscene_func_03_72af
	call loadInteracIdb4_subid6And7
	ld a,MUS_DISASTER
	ld (wActiveMusic),a
	call playSound
	ld a,$1e
	ld (wGenericCutscene.cbb5),a
	jp _incTmpcbb3

@startCutsceneText09:
	call _waitUntilFadeIsDone
	ret nz
	ld c,<TX_5009
	jp showCutscene50xxText

@startCutsceneText0a:
	call _waitUntilTextInactive
	ret nz
	ld c,<TX_500a
	jp showCutscene50xxText

@startCutsceneText0b:
	call _waitUntilTextInactive
	ret nz
	ld c,<TX_500b
	jp showCutscene50xxText

@startCutsceneText0c:
	call _waitUntilTextInactive
	ret nz
	ld c,<TX_500c
	call showCutscene50xxText
	ld a,$3c
	ld (wGenericCutscene.cbb5),a
	ret

@finish:
	call _waitUntilTextInactive
	ret nz
	xor a
	ld (wMenuDisabled),a
	ld a,GLOBALFLAG_FLAMES_OF_DESTRUCTION_SEEN
	call setGlobalFlag
	ld a,$03
	ld (wRoomStateModifier),a
	ld hl,@warpDest
	call setWarpDestVariables
	ld a,PALH_0f
	jp loadPaletteHeader

@warpDest:
	; d5 overworld entrance
	m_HardcodedWarpA ROOM_SEASONS_08a, $00, $25, $83


zeldaAndVillagersCutscene_state1:
	ld a,(wGenericCutscene.cbb3)
	rst_jumpTable
	.dw @start
	.dw @loadImpaRoomAndMusic
	.dw @waitUntilFadeInDone
	.dw @waitToFadeOut
	.dw @loadSokraRoomAndMusic
	.dw @waitUntilFadeInDone2
	.dw @finish

@start:
	call fadeoutToWhite
	jp _incTmpcbb3

@loadImpaRoomAndMusic:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$03
	; outside impa's house
	ld bc,ROOM_SEASONS_0b6
	call disableLcdAndLoadRoom_body
	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,MUS_TRIUMPHANT
	ld (wActiveMusic),a
	call playSound
	ld a,$02
	call loadGfxRegisterStateIndex
	xor a
	call loadGroupOfInteractions
	call fadeinFromWhite
	jp _incTmpcbb3

@waitUntilFadeInDone:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	jp _incTmpcbb3

@waitToFadeOut:
	ld a,($cfc0)
	bit 1,a
	ret z
	call fadeoutToWhite
	jp _incTmpcbb3

@loadSokraRoomAndMusic:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	; horon village Sokra screen
	ld bc,ROOM_SEASONS_0e9
	call disableLcdAndLoadRoom_body
	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,$02
	call loadGfxRegisterStateIndex
	call clearWramBank1
	ld a,$01
	call loadGroupOfInteractions
	call fadeinFromWhite
	jp _incTmpcbb3

@waitUntilFadeInDone2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld c,<TX_5010
	jp showCutscene50xxText

@finish:
	call _waitUntilTextInactive
	ret nz
	xor a
	ld (wMenuDisabled),a
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN
	call setGlobalFlag
	ld hl,@warpDest
	jp setWarpDestVariables

@warpDest:
	; first room of d8
	m_HardcodedWarpA ROOM_SEASONS_587, $93 $ff $01


zeldaKidnappedCutscene_state1:
	call zeldaKidnappedCutscene_state1Handler
	ld hl,wGenericCutscene.cbb3
	ld a,(hl)
	cp $10
	jp c,updateStatusBar
	ret

zeldaKidnappedCutscene_state1Handler:
	ld a,(wGenericCutscene.cbb3)
	rst_jumpTable
	.dw @startByFadingOut
	.dw @loadSokraRoomAndInteractions
	.dw @waitUntilRoomLoaded
	.dw @startCutsceneText11
	.dw @func4
	.dw @func5
	.dw @startCutsceneText12
	.dw @startCutsceneText13
	.dw @startCutsceneText14
	.dw @func9
	.dw @funca
	.dw @funcb
	.dw @startCutsceneText16
	.dw @startCutsceneText17
	.dw @funce
	.dw @funcf

	; stop calling updateStatusBar above
	.dw @loadRoomOfRitesAndInteractions
	.dw @startCutsceneText18
	.dw @startCutsceneText19
	.dw @startCutsceneText1a
	.dw @finish

@startByFadingOut:
	call fadeoutToWhite
	jp _incTmpcbb3

@loadSokraRoomAndInteractions:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	; horon village Sokra screen
	ld bc,ROOM_SEASONS_0e9
	call disableLcdAndLoadRoom_body
	ld a,$02
	call loadGfxRegisterStateIndex
	call restartSound
	ld a,$02
	call loadGroupOfInteractions
	call fadeinFromWhite
	ld a,$3c
	ld (wGenericCutscene.cbb5),a
	jp _incTmpcbb3

@waitUntilRoomLoaded:
	call _waitUntilFadeIsDone
	ret nz
	ld hl,$cfc0
	set 7,(hl)
	ld a,$ff
	ld (wGenericCutscene.cbb5),a
	jp _incTmpcbb3

@startCutsceneText11:
	ld hl,wGenericCutscene.cbb5
	dec (hl)
	ret nz
	ld c,<TX_5011
	call showCutscene50xxText
	ld a,$5a
	ld (wGenericCutscene.cbb5),a
	ret

@func4:
	call _waitUntilTextInactive
	jr z,+
	ld a,$3c
	cp (hl)
	ret nz
	ld hl,$cfc0
	set 6,(hl)
	ret
+
	ld hl,$cfc0
	set 5,(hl)
	ld a,$3c
	ld (wGenericCutscene.cbb5),a
	jp _incTmpcbb3

@func5:
	ld hl,wGenericCutscene.cbb5
	dec (hl)
	ret nz
	ld a,$1e
	ld (wGenericCutscene.cbb5),a
	xor a
	ld ($cfc6),a
	call cutscene_func_03_72af
	call loadInteracIdb4_subid2And3
	ld a,$21
	ld (wActiveMusic),a
	call playSound
	jp _incTmpcbb3

@startCutsceneText12:
	ld a,($cfc0)
	bit 0,a
	ret z
	ld hl,wGenericCutscene.cbb5
	dec (hl)
	ret nz
	ld c,<TX_5012
	jp showCutscene50xxText

@startCutsceneText13:
	call _waitUntilTextInactive
	ret nz
	ld c,<TX_5013
	jp showCutscene50xxText

@startCutsceneText14:
	call _waitUntilTextInactive
	ret nz
	ld c,<TX_5014
	jp showCutscene50xxText

@func9:
	call _waitUntilTextInactive
	ret nz
	ld hl,$cfc0
	res 0,(hl)
	jp _incTmpcbb3

@funca:
	ld a,($cfc0)
	bit 0,a
	ret z
	xor a
	ld (wGenericCutscene.cbb4),a
	ld a,SND_LIGHTNING
	call playSound
	call _incTmpcbb3

@funcb:
	call zeldaKidnappedFlashFadeoutToWhite
	ret nz
	call clearWramBank1
	ld hl,$cfc0
	res 0,(hl)
	xor a
	ld ($cfc6),a
	call loadInteracIdb4_subid4And5
	ld a,$04
	call fadeinFromWhiteWithDelay
	ld a,$1e
	ld (wGenericCutscene.cbb5),a
	jp _incTmpcbb3

@startCutsceneText16:
	call _waitUntilFadeIsDone
	ret nz
	ld c,<TX_5016
	jp showCutscene50xxText

@startCutsceneText17:
	call _waitUntilTextInactive
	ret nz
	ld c,<TX_5017
	jp showCutscene50xxText

@funce:
	call _waitUntilTextInactive
	ret nz
	ld hl,$cfc0
	set 0,(hl)
	ld a,$3c
	ld (wGenericCutscene.cbb5),a
	ld a,$bb
	call playSound
	jp _incTmpcbb3

@funcf:
	ld hl,wGenericCutscene.cbb5
	dec (hl)
	ret nz
	call fadeoutToWhite
	jp _incTmpcbb3

@loadRoomOfRitesAndInteractions:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call bank3CutsceneLoadRoomOfRites
	call loadInteracIdb0
	ld a,$f1
	call playSound
	xor a
	ld ($cfc6),a
	call loadInteracIdb4_subid6And7
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_TWINROVA_FLAME
+
	ld a,$13
	call loadGfxRegisterStateIndex
	call fadeinFromBlack
	ld a,$1e
	ld (wGenericCutscene.cbb5),a
	jp _incTmpcbb3

@startCutsceneText18:
	call _waitUntilFadeIsDone
	ret nz
	ld c,<TX_5018
	jp showCutscene50xxText

@startCutsceneText19:
	call _waitUntilTextInactive
	ret nz
	ld c,<TX_5019
	jp showCutscene50xxText

@startCutsceneText1a:
	call _waitUntilTextInactive
	ret nz
	ld c,<TX_501a
	jp showCutscene50xxText

@finish:
	call _waitUntilTextInactive
	ret nz
	xor a
	ld (wMenuDisabled),a
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call setGlobalFlag
	ld a,$03
	ld (wRoomStateModifier),a
	ld hl,@warpDest
	jp setWarpDestVariables

@warpDest:
    ; 1st screen on path to Onox?
	.db $c0 $23 $00 $45 $83


zeldaKidnappedFlashFadeoutToWhite:
	ld a,(wGenericCutscene.cbb4)
	rst_jumpTable
	.dw @func0
	.dw @func1
	.dw @func1
	.dw @func3
	.dw @func4
	.dw @func5
@func0:
	ld a,$0a
--
	ld (wGenericCutscene.cbb5),a
	call clearFadingPalettes
	jp _incTmpcbb4
@func1:
	ld hl,wGenericCutscene.cbb5
	dec (hl)
	ret nz
	ld a,$0a
-
	ld (wGenericCutscene.cbb5),a
	call fastFadeoutToWhite
	jp _incTmpcbb4
@func3:
	ld a,$14
	jr --
@func4:
	ld hl,wGenericCutscene.cbb5
	dec (hl)
	ret nz
	ld a,$1e
	jr -
@func5:
	jp _waitUntilFadeIsDone

showCutscene50xxText:
	ld b,$50
	call showText
	ld a,$1e
	ld (wGenericCutscene.cbb5),a

_incTmpcbb3:
	ld hl,wGenericCutscene.cbb3
	inc (hl)
	ret

_incTmpcbb4:
	ld hl,wGenericCutscene.cbb4
	inc (hl)
	ret

_waitUntilTextInactive:
	ld a,(wTextIsActive)
	or a
	ret nz
	ld hl,wGenericCutscene.cbb5
	dec (hl)
	ret

_waitUntilFadeIsDone:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,wGenericCutscene.cbb5
	dec (hl)
	ret

bank3CutsceneLoadRoomOfRites:
	xor a
	; Room of Rites
	ld bc,ROOM_SEASONS_59a
	call disableLcdAndLoadRoom_body
	ld a,SEASONS_PALH_ac
	call loadPaletteHeader
	ld a,$28
	ld (wGfxRegs1.SCX),a
	ld (wGfxRegs2.SCX),a
	ldh (<hCameraX),a
	ld a,$00
	ld (wScrollMode),a
	ld a,$10
	ldh (<hOamTail),a
	jp clearWramBank1

loadInteracIdb0:
	ld b,$02
-
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TWINROVA_FLAME
	inc l
	ld a,$02
	add b
	dec b
	ld (hl),a
	jr nz,-
	ret

loadGroupOfInteractions:
	ld hl,@interacGroupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld c,a
-
	ld a,(bc)
	or a
	ret z
	call getFreeInteractionSlot
	ret nz

	; load Interaction's id
	ld a,(bc)
	ldi (hl),a

	; load Interaction's subid
	inc bc
	ld a,(bc)
	ldi (hl),a

	; load Interaction's var03 in
	inc bc
	ld a,(bc)
	ldi (hl),a

	inc bc
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a

	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a

	inc bc
	jr -

@interacGroupTable:
	.dw @interacGroup1
	.dw @interacGroup2
	.dw @interacGroup3

	; id - subid - var03 - yh - xh
@interacGroup1:
	.db INTERACID_S_ZELDA $02 $00 $18 $18
	.db $00
@interacGroup2:
	.db INTERACID_bd $00 $01 $28 $38
	.db INTERACID_be $00 $01 $40 $38
	.db INTERACID_S_ZELDA $03 $00 $20 $50
	.db INTERACID_bc $00 $00 $48 $50
	.db INTERACID_ba $00 $03 $28 $68
	.db INTERACID_bb $00 $00 $40 $68
	.db $00
@interacGroup3:
	.db INTERACID_bd $00 $01 $2c $38
	.db INTERACID_be $00 $00 $44 $40
	.db INTERACID_S_ZELDA $03 $00 $20 $50
	.db INTERACID_bc $00 $00 $50 $58
	.db INTERACID_ba $00 $02 $20 $64
	.db INTERACID_bb $00 $03 $38 $68
	.db $00

cutscene_func_03_72af:
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	ld a,$b4
	ld (wInteractionIDToLoadExtraGfx),a
	ret

loadInteracIdb4_subid2And3:
	ld bc,loadInteracIdb4@subid2
	call loadInteracIdb4
	ld bc,loadInteracIdb4@subid3
	jr loadInteracIdb4

loadInteracIdb4_subid4And5:
	ld bc,loadInteracIdb4@subid4
	call loadInteracIdb4
	ld bc,loadInteracIdb4@subid5
	jr loadInteracIdb4

loadInteracIdb4_subid6And7:
	ld bc,loadInteracIdb4@subid6
	call loadInteracIdb4
	ld bc,loadInteracIdb4@subid7

loadInteracIdb4:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_b4
	inc l
	ld a,(bc)
	inc bc
	ld (hl),a
	ld l,Interaction.yh
	ld a,(bc)
	inc bc
	ld (hl),a
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	ret

	; subid - yh - xh
	@subid2:
	.db $02 $00 $40
	@subid3:
	.db $03 $00 $60
	@subid4:
	.db $04 $50 $68
	@subid5:
	.db $05 $50 $38
	@subid6:
	.db $06 $4c $8e
	@subid7:
	.db $07 $4c $62
