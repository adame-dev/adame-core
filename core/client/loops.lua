CreateThread(function()
  while true do
    if NetworkIsPlayerActive(PlayerId()) then
      TriggerServerEvent('adame:server:playerJoined')
      --TriggerServerEvent('adame:server:createPlayer')

      break
    end
    Wait(0)
  end
end)

CreateThread(function()
  while true do
    SetEveryoneIgnorePlayer(PlayerPedId(), true)

		SetMaxWantedLevel(0)
		NetworkSetFriendlyFireOption(true)
		SetPlayerInvincible(PlayerId(), false)
    
    HideHudComponentThisFrame(1) -- 1 : WANTED_STARS
    HideHudComponentThisFrame(3) -- 3 : CASH
    HideHudComponentThisFrame(4) -- 4 : MP_CASH
    -- HideHudComponentThisFrame(5)			-- 5 : MP_MESSAGE
    -- HideHudComponentThisFrame(6)			-- 6 : VEHICLE_NAME
    HideHudComponentThisFrame(7) -- 7 : AREA_NAME
    -- HideHudComponentThisFrame(8)			-- 8 : VEHICLE_CLASS
    HideHudComponentThisFrame(9) -- 9 : STREET_NAME
    -- HideHudComponentThisFrame(10)		-- 10 : HELP_TEXT
    -- HideHudComponentThisFrame(11)		-- 11 : FLOATING_HELP_TEXT_1
    -- HideHudComponentThisFrame(12)		-- 12 : FLOATING_HELP_TEXT_2
    HideHudComponentThisFrame(13) -- 13 : CASH_CHANGE
    -- HideHudComponentThisFrame(15)		-- 15 : SUBTITLE_TEXT
    -- HideHudComponentThisFrame(16)		-- 16 : RADIO_STATIONS
    HideHudComponentThisFrame(17) -- 17 : SAVING_GAME
    -- HideHudComponentThisFrame(18)		-- 18 : GAME_STREAM
    HideHudComponentThisFrame(21) -- 21 : HUD_COMPONENTS
    HideHudComponentThisFrame(22) -- 22 : HUD_WEAPONS
    DisplayAmmoThisFrame(true)

    Wait(5)
  end
end)
