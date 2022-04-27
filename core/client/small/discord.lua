CreateThread(function()
  while true do
    -- This is the Application ID (Replace this with you own)
    SetDiscordAppId(785960592010903625)

    -- Here you will have to put the image name for the "large" icon.
    SetDiscordRichPresenceAsset('logo_name')

    -- (11-11-2018) New Natives:

    -- Here you can add hover text for the "large" icon.
    SetDiscordRichPresenceAssetText('This is a lage icon with text')

    -- Here you will have to put the image name for the "small" icon.
    SetDiscordRichPresenceAssetSmall('logo_name')

    -- Here you can add hover text for the "small" icon.
    SetDiscordRichPresenceAssetSmallText('This is a lsmall icon with text')

    --
    SetDiscordRichPresenceAction(0, 'First Button!', 'fivem://connect/localhost:30120')
    SetDiscordRichPresenceAction(1, 'Second Button!', 'fivem://connect/localhost:30120')

    -- It updates every minute just in case.
    Wait(60000)
  end
end)
