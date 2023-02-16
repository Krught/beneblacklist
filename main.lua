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

BeneBlack:RegisterEvent("GROUP_ROSTER_UPDATE")


BeneBlack:SetScript("OnEvent", function(self, event, ...)
    if (event == "GROUP_ROSTER_UPDATE") then
        if (IsInRaid() or IsInGroup()) then
            for i = 1, GetNumGroupMembers() do
                if IsInRaid() then
                    unit_name, unit_realm = (UnitName("raid"..i))
                elseif IsInGroup() then
                    unit_name, unit_realm = (UnitName("party"..i))
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
                x_b_Ca = 0
                is_in_tabl = inTable(BeneCGroup, unit_name)
                if is_in_tabl == 0 then
                    table.insert(BeneCGroup, unit_name)
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
                    x_b_Ca = 0
                    is_in_tabl = inTable(addonTable.benediction_blacklist, unit_name)
                    if is_in_tabl == 1 then
                        black_message = unit_name.." is on the Benediction Blacklist!  View The Blacklist At https://discord.gg/nD8utdgDHe"
                        black_message_mini = unit_name.." is on the Benediction Blacklist!"
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
                elseif IsInGroup() then
                    unit_name, unit_realm = (UnitName("party"..i))
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
                x_b_Ca = 0
                is_in_tabl = inTable(BeneCGroup, unit_name)
                if is_in_tabl == 0 then
                    table.insert(BeneCGroup, unit_name)
                    function inTable(table_c_black, item)
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
                    x_b_Ca = 0
                    is_in_tabl = inTable(addonTable.benediction_blacklist, unit_name)
                    if is_in_tabl == 1 then
                        black_message = unit_name.." is on the Benediction Blacklist!  View The Blacklist At https://discord.gg/nD8utdgDHe"
                        black_message_mini = unit_name.." is on the Benediction Blacklist!"
                        display_text(black_message_mini)
                        SendChatMessage(black_message, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
                    end
                end
            end
        end
        if (black_det == 0) then
            if IsInRaid() then
                check_party = "Raid Clear Of Any Blacklisted Players.  View The Blacklist At https://discord.gg/nD8utdgDHe"
            elseif IsInGroup() then
                check_party = "Party Clear Of Any Blacklisted Players.  View The Blacklist At https://discord.gg/nD8utdgDHe"
            end
            SendChatMessage(check_party, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
            SendChatMessage(addonTable.benediction_black_date, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
        end
    else
        print(addonTable.benediction_black_date)
    end
end 