local vim = vim
local icons = require "nvim-web-devicons"

--+ if !julian
local function gitsigns()
	local dict = vim.b.gitsigns_status_dict
	if not dict then return "" end

	local result = {}

	-- current branch
	if dict.head and dict.head ~= "" then
		table.insert(result, " " .. dict.head .. " ")
	end

	-- additions
	if dict.added and dict.added > 0 then
		table.insert(result, "%#GitSignsAdd#+" .. dict.added .. "%* ")
	end

	-- changes
	if dict.changed and dict.changed > 0 then
		table.insert(result, "%#GitSignsChange#~" .. dict.changed .. "%* ")
	end

	-- deletions
	if dict.removed and dict.removed > 0 then
		table.insert(result, "%#GitSignsDelete#-" .. dict.removed .. "%* ")
	end

	table.insert(result, " ")
	return table.concat(result)
end
--+ end

-- TODO CONSIDER REMOVE
local function progress()
	local is_actual_win = vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin or -1)
	if package.loaded["vim.ui"] and is_actual_win then
		local status = vim.ui.progress_status()
		return status and status .. " " or ""
	end
	return ""
end

local function flags()
	local result = {}
	-- keymap name
	if vim.b.keymap_name then table.insert(result, "<" .. vim.b.keymap_name .. "> ") end
	-- busy indicator
	if vim.v.busy and vim.v.busy > 0 then table.insert(result, "◐ ") end

	return table.concat(result)
end

local function diagnostics()
	if package.loaded["vim.diagnostic"] then
		local count = vim.diagnostic.count()
		if next(count) then return vim.diagnostic.status() .. " " end
	end
	return ""
end

local function filetype()
	local icon, color = icons.get_icon_by_filetype(vim.bo.filetype)
	if not icon then return "" end
	return "%#" .. color .. "#" .. icon .. "%* "
end

function _G.my_statusline()
	return table.concat({
		" ", -- left padding
		--+ if !julian
		gitsigns(),
		--+ end
		diagnostics(),
		"%=", -- alignment separator
		filetype(),
		"%<%f %h%w%m%r", -- file info
		"%=", -- alignment separator
		flags(),
		"%l:%-5.(%c%V%) ", -- ruler, filetype, percentage
		"%P", -- percentage
		progress(),
		"%-10.S", -- macro/showcmd indicator
		" ", -- right padding
	})
end

vim.o.statusline = "%{%v:lua.my_statusline()%}"
