Config = {}

-- Yazı Ayarları
Config.TextFont = 8
Config.TextScale = 0.9
Config.Marker = true -- Marker On(true)/Off(false)
Config.MarkerColor = {252, 3, 3} -- r,g,b
Config.MarkerType = 2 -- https://docs.fivem.net/docs/game-references/markers/
Config.Type = "steamss" -- ID Türü belirleme, "steam,discord,license,ip"

-- Genel Ayarlar
Config.AdminsOnly = false -- Admin özel Önce README okuyun !
Config.AlwaysOpen = false -- HER ZAMAN AKTİF KALMASI İÇİN true/false
Config.Key = 243 -- é keybind
Config.CommandName = "showid" -- ID COMMAND
Config.ForceDrawSecond = 10000 -- KOMUT GÖSTERME SÜRESİ
Config.DrawDistance = 4

-- lang
Config.Strings = {
    steamtext = "STEAM HEX", -- -- Config.Type = Steam
    discordtext = "Discord ID", -- Config.Type = Discord
    licensetext = "License", -- Config.Type = License
    iptext = "IP", -- Config.Type = IP
    unknowntext = "UNKNOWN TYPE", -- Config.Type = BLABLABLA
    playertext = "Oyuncu ID", -- INGAME ID TEXT
}
