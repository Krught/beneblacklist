local BeneBlack = CreateFrame("frame", "EventFrame")
local addonName, addonTable = ...


function display_text(display_text)
    StaticPopupDialogs["Blacklist_Test"] = {
        text = display_text,
        button1 = "Okay",
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
      }
    StaticPopup_Show("Blacklist_Test")
end
function inTable(table_c_black, item)
    x_b_Ca = 0
    for key, value in pairs(table_c_black) do
        if value == item then 
            x_b_Ca = 1
        else
            if x_b_Ca ~= 1 then
                x_b_Ca = 0
            end
        end
    end
    return x_b_Ca
end
function inTabletwo(table_c_black, item)
    x_b_Ca = 0
    tag = 0
    for key, value in pairs(table_c_black) do
        if value == item then 
            x_b_Ca = 1
            black_det = 1
            tag = key
        else
            if x_b_Ca ~= 1 then
                x_b_Ca = 0
            end
        end
    end
    return x_b_Ca, tag
end
function inbattleground()
    bgspot = UnitInBattleground("player")
return bgspot
end
function getplayernameguildrealm(i, trade)
    if (trade == false) then
        if IsInRaid() then
            unit_name, unit_realm = (UnitName("raid"..i))
            guildName, guildRankName, guildRankIndex = GetGuildInfo(UnitName("raid"..i))
        elseif IsInGroup() then
            if (i == 1) then
                unit_name, unit_realm = (UnitName("player"))
                guildName, guildRankName, guildRankIndex = GetGuildInfo(UnitName("player"))
            else
                i = i - 1
                unit_name, unit_realm = (UnitName("party"..i))
                guildName, guildRankName, guildRankIndex = GetGuildInfo(UnitName("party"..i))
            end
        end
    else
        unit_name = TradeFrameRecipientNameText:GetText()
        guildName = ""
    end
    if (unit_realm == nil)
    then
        unit_realm = GetRealmName()
    end
    if (unit_realm == "Benediction") then
        lookup_list = addonTable.benediction_blacklist
        lookup_p_tag = addonTable.benediction_blacklist_tag
        lookup_g_list = addonTable.benediction_blacklist_guild
        lookup_g_tag = addonTable.benediction_blacklist_guild_tag
    elseif (unit_realm == "Faerlina") then
        lookup_list = addonTable.faerlina_blacklist
        lookup_p_tag = addonTable.faerlina_blacklist_tag
        lookup_g_list = addonTable.faerlina_blacklist_guild
        lookup_g_tag = addonTable.faerlina_blacklist_guild_tag
    else
        lookup_list = {}
        lookup_g_list = {}
        lookup_p_tag = {}
        lookup_g_tag = {}
        print("Classic Blacklist - " .. unit_name .. " on realm ".. unit_realm .. " is on an unsupported realm.")
    end
return unit_name, guildName, lookup_list, lookup_g_list, lookup_p_tag, lookup_g_tag
end
local black_discord_link = "View The Blacklist At https://discord.gg/FCCdCnEF4d"
function mainchecker(i, BeneCGroup, black_det, BeneSilence, BeneDGroup, trade)
    blacklist_popup = {}
    if (trade == false) then
        unit_name, guildName, lookup_list, lookup_g_list, lookup_p_tag, lookup_g_tag = getplayernameguildrealm(i, false)
    else
        unit_name, guildName, lookup_list, lookup_g_list, lookup_p_tag, lookup_g_tag = getplayernameguildrealm(1, true)
    end
    x_b_Ca = 0
    is_in_tabl = inTable(BeneCGroup, unit_name)
    if is_in_tabl == 0 then
        if (trade == false) then
            table.insert(BeneCGroup, unit_name)
        end
        x_b_Ca = 0
        is_in_tabl, tag = inTabletwo(lookup_list, unit_name)
        if is_in_tabl == 1 then
            tag_status = lookup_p_tag[tag]
            black_message = unit_name.." is on the Classic Blacklist for ".. tag_status .."!"  --.. black_discord_link
            black_message_mini = unit_name.." is on the Classic Blacklist!" .. "\n" .. "Reason: ".. tag_status
            display_text(black_message_mini)
            if (BeneSilence == false) then
                SendChatMessage(black_message, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
                SendChatMessage(black_discord_link, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
            else
                print(black_message)
            end
        end
    end
    x_b_Ca = 0
    is_in_tabl = inTable(BeneDGroup, guildName)
    if is_in_tabl == 0 then
        if (trade == false) then
            table.insert(BeneDGroup, guildName)
        end
        x_b_Ca = 0
        is_in_tabl, tag = inTabletwo(lookup_g_list, guildName)
        if is_in_tabl == 1 then
            tag_status = lookup_g_tag[tag]
            black_message = "<"..guildName.."> is on the Classic Blacklist for ".. tag_status .."!"  --.. black_discord_link
            black_message_mini = "<".. guildName.."> is on the Classic Blacklist!" .. "\n" .. "Reason: ".. tag_status
            display_text(black_message_mini)
            if (BeneSilence == false) then
                SendChatMessage(black_message, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
                SendChatMessage(black_discord_link, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
            else
                print(black_message)
            end
        end
    end
end
function checkedallplayers()
    BeneDGroup = {"S"}
end


BeneBlack:RegisterEvent("GROUP_ROSTER_UPDATE")
BeneBlack:RegisterEvent("TRADE_SHOW")
BeneBlack:SetScript("OnEvent", function(self, event, ...)
    if (event == "GROUP_ROSTER_UPDATE") then
        bgspot = inbattleground()
        if (bgspot ~= nil) then
            BeneSilence = true
        end
        if (IsInRaid() or IsInGroup()) then
            black_det = 0
            for i = 1, GetNumGroupMembers() do
                mainchecker(i, BeneCGroup, black_det, BeneSilence, BeneDGroup, false)
            end
        else
            BeneCGroup = {"S"}
        end
        checkedallplayers()
    elseif (event == "TRADE_SHOW") then
        mainchecker(0, {"S"}, black_det, true, {"S"}, true)
        checkedallplayers()
    end
end)

function onopen()
    BeneCGroup = {"S"}
    BeneDGroup = {"S"}
    BeneSilence = false
end
onopen()

SLASH_BENEBLACK1 = "/beneblack"
SlashCmdList["BENEBLACK"] = function(msg)
    if (msg == "check") then
        BeneCGroup = {"S"}
        black_det = 0
        if (IsInRaid() or IsInGroup()) then
            for i = 1, GetNumGroupMembers() do
                mainchecker(i, BeneCGroup, black_det, BeneSilence, BeneDGroup, false)
            end
        end
        if (black_det == 0) then
            if IsInRaid() then
                check_party = "Raid Clear Of Any Blacklisted Players.  "  .. black_discord_link
            elseif IsInGroup() then
                check_party = "Party Clear Of Any Blacklisted Players.  "  .. black_discord_link
            end
            if (BeneSilence == false) then
                SendChatMessage(check_party, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
                SendChatMessage(addonTable.benediction_black_date, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
            else
                print(check_party)
                print(addonTable.benediction_black_date)
            end
        end
        checkedallplayers()
    elseif (msg == "silent") then
        if (BeneSilence == false) then
            BeneSilence = true
            display_text("Benediction Blacklist - Silent Mode Activated")
            print("Benediction Blacklist - Silent Mode Activated")
        else
            BeneSilence = false
            display_text("Benediction Blacklist - Silent Mode Deactivated")
            print("Benediction Blacklist - Silent Mode Deactivated")
        end
    else
        print(addonTable.benediction_black_date)
    end
end 
