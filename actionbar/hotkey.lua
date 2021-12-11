local _, nf = ...
local cfg = nf.Config

-- globals
local _G = _G
local unpack, select = _G.unpack, _G.select
local gsub = gsub

local replaces = {
	{'(Mouse Button)', 'M'},
	{'(Кнопка мыши)', 'M'},
	-- zhCN, zhTW, koKR control
	{'(鼠标按键)', 'M'},
	{'(滑鼠按鍵)', 'M'},
	{'(数字键盘)', 'N'},
	{'(方向键上)', 'U'},
	{'(方向键下)', 'D'},
	{'(方向键左)', 'L'},
	{'(方向键右)', 'R'},
	-- general
	{'(M4)', 'RMK'},
	{'(M5)', 'LMK'},
	{'(a%-)', 'A-'},
	{'(c%-)', 'C-'},
	{'(s%-)', 'S-'},
	{'(st%-)', 'C-'}, -- german control 'Steuerung'
	{KEY_BUTTON3, 'M3'},
	{KEY_MOUSEWHEELUP, 'UP'},
	{KEY_MOUSEWHEELDOWN, 'DWN'},
	{KEY_SPACE, 'Sp'},
	{CAPSLOCK_KEY_TEXT, 'CL'},
	{KEY_NUMPADPLUS, 'Nu+'},
	{KEY_NUMLOCK, 'Num'},
	{KEY_DELETE, 'Del'},
}

local function UpdateHotKey(self)
	local hotkey = _G[self:GetName()..'HotKey']

	if hotkey and hotkey:IsShown() and not cfg.global.hotkey then hotkey:Hide() return end

	local text = hotkey:GetText()
	if (not text) then return end

	for _, value in pairs(replaces) do
		text = gsub(text, value[1], value[2])
	end

	if text == RANGE_INDICATOR then
		hotkey:SetText''
	else
		hotkey:SetText(text)
	end
end

hooksecurefunc('ActionButton_UpdateHotkeys', UpdateHotKey)