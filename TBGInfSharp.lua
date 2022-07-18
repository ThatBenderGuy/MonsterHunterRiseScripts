-- Version 1.2.2
require("TBGHelperScripts/helpers")

local config = {
    enable = false
}

local configPath = "TBG_Infinite_Sharpness.json"

-- Handle Json config
if json ~= nil then
    file = json.load_file(configPath)
    if file ~= nil then
        config = file
    else
        json.dump_file(configPath, config)
    end
end

function handleSharpnessDec()
    local _, weaponName = getCurrentWeaponInstanceAndName()
    if weaponName == "Bow" or weaponName == "LightBowgun" or weaponName == "HeavyBowgun" then return end

    local playerBase = getPlayer()

    -- Raw values
    local maxSharpness = playerBase:call("get_SharpnessGaugeMax")
   
    playerBase:call("set_SharpnessGauge", maxSharpness)
end

sdk.hook(PlayerBase_typedef:get_method("update"), 
function(args)
        if config.enable then
            handleSharpnessDec() 
        end
end, 
function(retval) 
    return retval 
end) 

-- UI
re.on_draw_ui(function()
    
    if imgui.tree_node("TBG's Infinite Sharpness") then
        changed, value = imgui.checkbox("Enabled", config.enable)
        if changed then
            config.enable = value
            json.dump_file(configPath, config)
        end

        imgui.tree_pop()
    end

end)
