script_name('AdminTools') 
script_author ('Keith_Laird') 

-- [ВНИМАНИЕ!] код этого скрипта писал профессиОнальный програмист из оксфорда под руководством шишек и грибов [КОНЕЦ ВНИМАНИЯ!]

require "lib.moonloader"
local imgui = require('imgui')
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local encoding = require "encoding"

encoding.default = "CP1251"
u8 = encoding.UTF8

local tag = '{ff004d}['..thisScript().name..']:{ffffff} '
local version = '{ff004d}'..thisScript().version..'{ffffff} '

local settings = imgui.ImBool(false)
local font_flag = require('moonloader').font_flag
local my_font = renderCreateFont('Arial', 11, font_flag.BOLD + font_flag.SHADOW)

update_state = false

local script_vers = 2
local script_vers_text = "2.05"

local update_url = "https://raw.githubusercontent.com/Ketchup33/scripts/main/TestTools.ini" -- тут тоже свою ссылку
local update_path = getWorkingDirectory() .. "/TestTools.ini" -- и тут свою ссылку

local script_url = "https://raw.githubusercontent.com/Ketchup33/scripts/blob/main/TestTools.luac?raw=true" -- тут свою ссылку
local script_path = thisScript().path

function main()
	 if not isSampLoaded() or not isSampfuncsLoaded() then return end
	 while not isSampAvailable() do wait(100) end	

     downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage("Есть обновление! Версия: " .. updateIni.info.vers_text, -1)
                update_state = true
            end
            os.remove(update_path)
        end
     end)

	 --> CHECK SERVER
     local ip = select(1, sampGetCurrentServerAddress())
     local result, server = isFlin(ip)
     if not result then
    	 sampAddChatMessage(tag .. ' Скрипт работает только на {FF8C00}Flin Role Play.', 0xFF6060)
		 return 
	 end
	 sampAddChatMessage(tag .. ' --------------------------------------------------------------------------------------------------------------------', 0xFF6060)
	 sampAddChatMessage(tag .. ' {FFFFFF}Скрипт успешно запущен на {FF6060}' .. server .. ' {FFFFFF}сервере {FF8C00}Flin Role Play.', 0xFF6060)
	 sampAddChatMessage(tag .. ' Активация: {FFFFFF}F9, /vovalox.', 0xFF6060)
	 sampAddChatMessage(tag .. ' {FFFFFF}Автором скрипта является: {FF6060}Keith_Laird.', 0xFF6060)
	 sampAddChatMessage(tag .. ' --------------------------------------------------------------------------------------------------------------------', 0xFF6060)
	 if not sampIsLocalPlayerSpawned() then
		 sampAddChatMessage(tag .. ' Настройки станут доступны после спавна на сервере', 0xFF6060)
	 end

	 sampRegisterChatCommand('test', function()
        settings.v = not settings.v
     end)

	 imgui.Process = false
	 while true do
        renderFontDrawText(my_font, 'Администрация онлайн:', 10, 400, 0xFFFFFFFF)
		wait(0)
        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Скрипт успешно обновлен!", -1)
                    thisScript():reload()
                end
            end)
            break
        end

		imgui.Process = settings.v
	 end
end

function imgui.OnDrawFrame()
	if settings.v then
		imgui.SetNextWindowSize(imgui.ImVec2(800, 403), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2(ex / 2, ey / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8' Настройки скрипта', settings, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)

        imgui.BeginChild(u8'Select menu', imgui.ImVec2(150, 370), true)
        if imgui.Selectable(u8" Чекеры", beginchild == 5) then beginchild = 5 end
        ingui.EndChild()
        if beginchild == 5 then
			imgui.BeginChild(u8'Чекеры', imgui.ImVec2(635, 370), true)
				imgui.CenterTextColoredRGB('{FFFFFF}В разработке!', 2)
			imgui.EndChild()
		end
		imgui.End()
	end
end

--> Проверка на сервер от Flin Games
function isFlin(ip)
	for k, v in pairs({
		['Первом'] 	= '194.226.139.27:7771',
		['Втором'] 	= '194.226.139.27:7772'
	}) do
		local ip, port = sampGetCurrentServerAddress()
		server = ip..":"..port
		if v == server then 
			return true, k
		end
	end
	return false
end

function applyTheme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2
  
  
    style.WindowPadding = ImVec2(6, 4)
    style.WindowRounding = 5.0
    style.FramePadding = ImVec2(5, 2)
    style.FrameRounding = 3.0
    style.ItemSpacing = ImVec2(7, 5)
    style.ItemInnerSpacing = ImVec2(1, 1)
    style.TouchExtraPadding = ImVec2(0, 0)
    style.IndentSpacing = 6.0
    style.ScrollbarSize = 12.0
    style.ScrollbarRounding = 16.0
    style.GrabMinSize = 20.0
    style.GrabRounding = 2.0
  
    style.WindowTitleAlign = ImVec2(0.5, 0.5)

    
    colors[clr.Border] = ImVec4(1, 0, 0.3, 1.00)
    colors[clr.WindowBg] = ImVec4(0.13, 0.14, 0.17, 1.00)
    colors[clr.FrameBg] = ImVec4(0.200, 0.220, 0.270, 0.85)
    colors[clr.TitleBg] = ImVec4(1, 0, 0.3, 1.00)
    colors[clr.TitleBgActive] = ImVec4(1, 0, 0.3, 1.00)
    colors[clr.Button] = ImVec4(1, 0, 0.3, 1.00)
    colors[clr.ButtonHovered] = ImVec4(1, 0, 0.3, 1.00)
    colors[clr.Separator] = ImVec4(1, 0, 0.3, 1.00)
    --CollapsingHeader
    colors[clr.Header] = ImVec4(1, 0, 0.3, 1.00)
    colors[clr.HeaderHovered] = ImVec4(0.68, 0, 0.2, 0.86)
    colors[clr.HeaderActive] = ImVec4(1, 0.24, 0.47, 1.00)
    colors[clr.CheckMark] = ImVec4(1, 0, 0.3, 1.00)
    colors[clr.ModalWindowDarkening] = ImVec4(0.200, 0.220, 0.270, 0.73)

    colors[clr.ScrollbarBg] = ImVec4(0.200, 0.220, 0.270, 0.85)
    colors[clr.ScrollbarGrab] = ImVec4(1, 0, 0.3, 1.00)
    colors[clr.ScrollbarGrabHovered] = ImVec4(1, 0, 0.3, 1.00)
    colors[clr.ScrollbarGrabActive] = ImVec4(1, 0, 0.3, 1.00)

    colors[clr.ButtonActive] = ImVec4(1, 0, 0.3, 1.00)
    
end
applyTheme()