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
function remove_dash(text)
    local pos = string.find(text, "-") -- find the position of the first "-"
    if pos then -- if "-" is found
        text = string.sub(text, 1, pos-1) -- remove all characters from pos to end of string
    end
return text
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
    if (unit_realm == nil) then
        unit_realm = GetRealmName()
    end
    if (guildName == nil) then
        guildName = ""
    end
    unit_name = unit_name .. "-" .. unit_realm
    guildName = guildName .. "-" .. unit_realm
    lookup_list = addonTable.blacklist_name
    lookup_p_tag = addonTable.blacklist_tag
    lookup_g_list = addonTable.blacklist_guild
    lookup_g_tag = addonTable.blacklist_guild_tag
return unit_name, guildName, lookup_list, lookup_g_list, lookup_p_tag, lookup_g_tag
end
local black_discord_link = "View The Blacklist At https://discord.gg/FCCdCnEF4d"
local last_guilds_checked = {}
local current_guilds_checked = {}
function mainchecker(i, BeneCGroup, black_det, BeneSilence, BeneDGroup, trade)
    if (ClassicBlacklist_Month_Old_Data == false) then
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
                unit_name = remove_dash(unit_name)
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
                guildName = remove_dash(guildName)
                x_b_Ca = 0
                is_in_tabl, null_tag = inTabletwo(last_guilds_checked, guildName)
                if is_in_tabl == 0 then

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
    end
    table.insert(current_guilds_checked, guildName)
end
function checkedallplayers()
    BeneDGroup = {"S"}
end


local function for_i()
    last_guilds_checked = current_guilds_checked
    current_guilds_checked = {}
    for i = 1, GetNumGroupMembers() do
        mainchecker(i, BeneCGroup, black_det, BeneSilence, BeneDGroup, false)
    end
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
            for_i()
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
end
onopen()

--Force Check Party Function
function recheck_party()
    BeneCGroup = {"S"}
    black_det = 0
    current_guilds_checked = {}
    if (ClassicBlacklist_Month_Old_Data == false) then
        if (IsInRaid() or IsInGroup()) then
            for_i()
        -- end
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
        else
            print("You Are Not In A Party.")
        end
    else
        update_addon_text = "Your blacklist data is over a month old & has been disabled."
        display_text(update_addon_text)
        print(update_addon_text)
    end
end


-- Options Page

-- Define the options frame
local optionsFrame = CreateFrame("Frame", "MyAddonOptionsFrame", InterfaceOptionsFramePanelContainer)
optionsFrame.name = "Classic Blacklist"

-- Create a title text
optionsFrame.title = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
optionsFrame.title:SetPoint("TOPLEFT", 16, -16)
optionsFrame.title:SetText("Classic Blacklist Options")

-- Create a checkbox
optionsFrame.checkbox = CreateFrame("CheckButton", "MyAddonOptionCheckbox", optionsFrame, "InterfaceOptionsCheckButtonTemplate")
optionsFrame.checkbox:SetPoint("TOPLEFT", optionsFrame.title, "BOTTOMLEFT", 0, -16)
optionsFrame.checkbox:SetScript("OnClick", function(self)
    -- Set the addon option to the checkbox value
    local isChecked = self:GetChecked()
    BeneSilence = isChecked  
end)
optionsFrame.checkbox.label = optionsFrame.checkbox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
optionsFrame.checkbox.label:SetPoint("LEFT", optionsFrame.checkbox, "RIGHT", 0, 1)
optionsFrame.checkbox.label:SetText("Silent Mode")

-- Create a button
optionsFrame.button = CreateFrame("Button", "MyAddonOptionButton", optionsFrame, "UIPanelButtonTemplate")
optionsFrame.button:SetPoint("TOPLEFT", optionsFrame.checkbox, "BOTTOMLEFT", 0, -16)
optionsFrame.button:SetSize(100, 25)
optionsFrame.button:SetText("Force Check Party")
optionsFrame.button:SetScript("OnClick", function(self)
    recheck_party()
end)

-- Create a text label
optionsFrame.label = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
optionsFrame.label:SetPoint("TOP", optionsFrame.button, "BOTTOM", 25, -10)
optionsFrame.label:SetJustifyH("CENTER")

-- Add the options frame to the Interface Options panel
InterfaceOptions_AddCategory(optionsFrame)

-- Slash Commands
local function slash_commands(msg)
    if (msg == "check") then
        recheck_party()
    elseif (msg == "silent") then
        if (BeneSilence == false) then
            BeneSilence = true
            display_text("Benediction Blacklist - Silent Mode Activated")
            print("Benediction Blacklist - Silent Mode Activated")
            optionsFrame.checkbox:SetChecked(BeneSilence)
        else
            BeneSilence = false
            display_text("Benediction Blacklist - Silent Mode Deactivated")
            print("Benediction Blacklist - Silent Mode Deactivated")
            optionsFrame.checkbox:SetChecked(BeneSilence)
        end
    elseif (msg == "settings") or (msg == "setting") then
        InterfaceOptionsFrame_OpenToCategory("Classic Blacklist")
        InterfaceOptionsFrame_OpenToCategory("Classic Blacklist") -- Call this twice to ensure the panel is fully opened    
    else
        print(addonTable.benediction_black_date)
    end
end

SLASH_BENEBLACK1 = "/beneblack"
SLASH_CLASSICBLACK1 = "/classicblack"
SlashCmdList["BENEBLACK"] = function(msg)
    slash_commands(msg)
end
SlashCmdList["CLASSICBLACK"] = function(msg)
    slash_commands(msg)
end


-- Saving Data
local function ClassicBlack_SaveData()
    ClassicBlacklist_SavedVariables.silent_mode = BeneSilence
end
  

local function ClassicBlack_OnLog(self, event, ...)
    if event == "PLAYER_LOGOUT" or event == "PLAYER_LEAVING_WORLD" then
        ClassicBlack_SaveData()
    end
end

local Logout = CreateFrame("Frame")
Logout:RegisterEvent("PLAYER_LOGOUT")
Logout:RegisterEvent("PLAYER_LEAVING_WORLD")
Logout:SetScript("OnEvent", ClassicBlack_OnLog)


-- Getting how old the data is
local function date_since_update()
    local dateStr = string.match(addonTable.benediction_black_date, "%d%d%d%d%-%d%d%-%d%d")
    local year, month, day = dateStr:match("(%d+)-(%d+)-(%d+)")

    local currentDate = date("*t")
    local targetDate = {year = tonumber(year), month = tonumber(month), day = tonumber(day)}
    local currentTimestamp = time(currentDate)
    local targetTimestamp = time(targetDate)

    local secondsPerDay = 24 * 60 * 60
    local dayDifference = math.abs(math.floor((targetTimestamp - currentTimestamp) / secondsPerDay)) - 1

    optionsFrame.label:SetText("Blacklist Data : " .. dayDifference .. " days old.")

    if (dayDifference >= 7) and (dayDifference < 30) then
        update_addon_text = "Your blacklist data is over a week old.  Recommend updating Classic Blacklist."
        display_text(update_addon_text)
        print(update_addon_text)
    end
    if (dayDifference >= 30) then
        ClassicBlacklist_Month_Old_Data = true
        update_addon_text = "Your blacklist data is over a month old & has been disabled."
        display_text(update_addon_text)
        print(update_addon_text)
    end
end

-- Loading Data
local function ClassicBlack_LoadData()
    if (ClassicBlacklist_SavedVariables) then
        BeneSilence = ClassicBlacklist_SavedVariables.silent_mode
        optionsFrame.checkbox:SetChecked(BeneSilence)
    else
        BeneSilence = false
        ClassicBlacklist_SavedVariables = {}
    end
    ClassicBlacklist_Month_Old_Data = false
    date_since_update()
end
local Login = CreateFrame("FRAME")
Login:RegisterEvent("ADDON_LOADED")
Login:SetScript("OnEvent", function(self, event, addonName)
    if (event == "ADDON_LOADED") and (addonName == "BeneBlacklist") then
        ClassicBlack_LoadData()
    end
end)




