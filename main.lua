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
    for key, value in pairs(table_c_black) do
        if value == item then 
            x_b_Ca = 1
            black_det = 1
        else
            if x_b_Ca ~= 1 then
                x_b_Ca = 0
            end
        end
    end
    return x_b_Ca
end
BeneBlack:RegisterEvent("GROUP_ROSTER_UPDATE")


local black_discord_link = "View The Blacklist At https://discord.gg/FCCdCnEF4d"

BeneBlack:SetScript("OnEvent", function(self, event, ...)
    if (event == "GROUP_ROSTER_UPDATE") then
        if (IsInRaid() or IsInGroup()) then
            for i = 1, GetNumGroupMembers() do
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
                if (unit_realm == nil)
                then
                    unit_realm = GetRealmName()
                end
                if (unit_realm == "Benediction")
                then
                    lookup_list = addonTable.benediction_blacklist
                    lookup_g_list = addonTable.benediction_blacklist_guild
                end
                if (unit_realm == "Faerlina")
                then
                    lookup_list = addonTable.faerlina_blacklist
                    lookup_g_list = addonTable.faerlina_blacklist_guild
                end
                x_b_Ca = 0
                is_in_tabl = inTable(BeneCGroup, unit_name)
                if is_in_tabl == 0 then
                    table.insert(BeneCGroup, unit_name)
                    x_b_Ca = 0
                    is_in_tabl = inTabletwo(lookup_list, unit_name)
                    if is_in_tabl == 1 then
                        black_message = unit_name.." is on the Classic Blacklist!  " .. black_discord_link
                        black_message_mini = unit_name.." is on the Classic Blacklist!"
                        display_text(black_message_mini)
                        SendChatMessage(black_message, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
                    end
                end
                x_b_Ca = 0
                is_in_tabl = inTable(BeneDGroup, guildName)
                if is_in_tabl == 0 then
                    x_b_Ca = 0
                    is_in_tabl = inTabletwo(lookup_g_list, guildName)
                    if is_in_tabl == 1 then
                        black_message = "<"..guildName.."> is on the Classic Blacklist!  " .. black_discord_link
                        black_message_mini = "<".. guildName.."> is on the Classic Blacklist!"
                        display_text(black_message_mini)
                        SendChatMessage(black_message, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
                    end
                end
            end
        else
            BeneCGroup = {"S"}
        end
    end
end)


function onopen()
    BeneCGroup = {"S"}
    BeneDGroup = {"S"}
end
onopen()

SLASH_BENEBLACK1 = "/beneblack"
SlashCmdList["BENEBLACK"] = function(msg)
    if (msg == "check") then
        BeneCGroup = {"S"}
        black_det = 0
        if (IsInRaid() or IsInGroup()) then
            for i = 1, GetNumGroupMembers() do
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
                if (unit_realm == nil)
                then
                    unit_realm = GetRealmName()
                end
                if (unit_realm == "Benediction")
                then
                    lookup_list = addonTable.benediction_blacklist
                    lookup_g_list = addonTable.benediction_blacklist_guild
                end
                if (unit_realm == "Faerlina")
                then
                    lookup_list = addonTable.faerlina_blacklist
                    lookup_g_list = addonTable.faerlina_blacklist_guild
                end
                x_b_Ca = 0
                is_in_tabl = inTable(BeneCGroup, unit_name)
                if is_in_tabl == 0 then
                    table.insert(BeneCGroup, unit_name)
                    x_b_Ca = 0
                    is_in_tabl = inTabletwo(lookup_list, unit_name)
                    if is_in_tabl == 1 then
                        black_message = unit_name.." is on the Classic Blacklist!  "  .. black_discord_link
                        black_message_mini = unit_name.." is on the Classic Blacklist!"
                        display_text(black_message_mini)
                        SendChatMessage(black_message, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
                    end
                end
                x_b_Ca = 0
                is_in_tabl = inTable(BeneDGroup, guildName)
                if is_in_tabl == 0 then
                    x_b_Ca = 0
                    is_in_tabl = inTabletwo(lookup_g_list, guildName)
                    if is_in_tabl == 1 then
                        black_message = "<"..guildName.."> is on the Classic Blacklist!  " .. black_discord_link
                        black_message_mini = "<".. guildName.."> is on the Classic Blacklist!"
                        display_text(black_message_mini)
                        SendChatMessage(black_message, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
                    end
                end
            end
        end
        if (black_det == 0) then
            if IsInRaid() then
                check_party = "Raid Clear Of Any Blacklisted Players.  "  .. black_discord_link
            elseif IsInGroup() then
                check_party = "Party Clear Of Any Blacklisted Players.  "  .. black_discord_link
            end
            SendChatMessage(check_party, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
            SendChatMessage(addonTable.benediction_black_date, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
        end
    elseif (msg == "invite") then
        black_down = "You Can Download BeneBlacklist At https://www.curseforge.com/wow/addons/benediction-blacklist"
        SendChatMessage(black_down, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
    elseif (msg == "report") then
        report_msg = "Report Players To The Blacklist At https://discord.gg/FCCdCnEF4d"
        SendChatMessage(report_msg, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
        print(report_msg)
    else
        print(addonTable.benediction_black_date)
    end
end 
