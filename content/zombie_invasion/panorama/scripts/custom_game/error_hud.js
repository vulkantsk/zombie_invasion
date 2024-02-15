GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_BAR_DIRE_TEAM, false );

 
 GameEvents.Subscribe("CreateIngameErrorMessage", function(data) {
 			$.Msg("32")
			GameEvents.SendEventClientSide("dota_hud_error_message", 
			{
				"splitscreenplayer": 0,
				"reason": data.reason || 80,
				"message": data.message
			})
	})