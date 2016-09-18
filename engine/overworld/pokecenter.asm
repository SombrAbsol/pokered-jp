DisplayPokemonCenterDialogue_:
	call SaveScreenTilesToBuffer1 ; save screen
	ld hl, PokemonCenterWelcomeText
	call PrintText
	ld hl, wd72e
	bit 2, [hl]
	set 1, [hl]
	set 2, [hl]
	jr nz, .skipShallWeHealYourPokemon
	ld hl, ShallWeHealYourPokemonText
	call PrintText
.skipShallWeHealYourPokemon
	call YesNoChoicePokeCenter ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .declinedHealing ; if the player chose No
	call SetLastBlackoutMap
	call LoadScreenTilesFromBuffer1 ; restore screen
	ld hl, NeedYourPokemonText
	call PrintText
	ld a, $18
	ld [wSpriteStateData1 + $12], a ; make the nurse turn to face the machine
	call Delay3
	predef HealParty
	callba AnimateHealingMachine ; do the healing machine animation
	xor a
	ld [wAudioFadeOutControl], a
	ld a, [wAudioSavedROMBank]
	ld [wAudioROMBank], a
	ld a, [wMapMusicSoundID]
	ld [wLastMusicSoundID], a
	ld [wNewSoundID], a
	call PlaySound
	ld hl, PokemonFightingFitText
	call PrintText
	ld a, $14
	ld [wSpriteStateData1 + $12], a ; make the nurse bow
	ld c, a
	call DelayFrames
	jr .done
.declinedHealing
	call LoadScreenTilesFromBuffer1 ; restore screen
.done
	ld hl, PokemonCenterFarewellText
	call PrintText
	jp UpdateSprites

PokemonCenterWelcomeText:
	text "ようこそ！"
	line "<PKMN>センターへ"
	para "ここでは　<PKMN>の"
	line "たいリょく　かいふくを　いたします"
	prompt

ShallWeHealYourPokemonText:
	TX_DELAY
	text "モンスターボールを　"
	line "おあずけに　なリますか？"
	done

NeedYourPokemonText:
	text "それでは"
	line "あずからせて　いただきます！"
	done

PokemonFightingFitText:
	text "おまちどうさまでした！"
	line "おあずかリした　<PKMN>は"
	cont "みんな　げんきに　なリましたよ！"
	prompt

PokemonCenterFarewellText:
	TX_DELAY
	text "またの"
	line "ごリようを　おまちしてます！"
	done
