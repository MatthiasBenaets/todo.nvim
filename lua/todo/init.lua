local M = {}

-- Get the buffer's preferred indentation (tabs or spaces).
local function get_indent()
	local sw = vim.o.shiftwidth
	local expand = vim.o.expandtab
	if sw == 0 then
		sw = vim.o.tabstop
	end
	if expand then
		return string.rep(" ", sw)
	else
		return "\t"
	end
end

-- Toggle checkbox between TODO and DONE.
-- TODO -> DONE: adds `CLOSED: YYYY-MM-DD Dayabbr. HH:MM` below.
-- DONE -> TODO: removes the `CLOSED:` line below.
M.toggle = function()
	local line = vim.api.nvim_get_current_line()
	local marker = line:match("^%s*([%-%*+])")
	local checkbox = line:match("^%s*[%-%*+] %[(%w+)%]")

	local cursor = vim.api.nvim_win_get_cursor(0)
	local closed_pat = "^%s*CLOSED: .*$"

	if checkbox == "TODO" then
		-- TODO -> DONE
		local new_line = line:gsub("%[TODO%]", "[DONE]")
		vim.api.nvim_set_current_line(new_line)

		-- Add CLOSED timestamp below
		local now = os.date("%Y-%m-%d %a %H:%M")
		local indent = get_indent()
		local closed_line = indent .. "CLOSED: [" .. now .. "]"
		vim.api.nvim_put({ closed_line }, "l", true, true)

		vim.api.nvim_win_set_cursor(0, cursor)
		vim.notify("Marked as DONE", vim.log.levels.INFO)
	elseif checkbox == "DONE" then
		-- Remove CLOSED line below if present
		local next_row = cursor[1]
		local next_lines = vim.api.nvim_buf_get_lines(0, next_row, next_row + 2, false)
		if next_lines[1] and next_lines[1]:match(closed_pat) then
			vim.api.nvim_buf_set_lines(0, next_row, next_row + 1, false, {})
		end

		-- Toggle back to TODO
		local new_line = vim.api.nvim_get_current_line()
		new_line = new_line:gsub("%[DONE%]", "[TODO]")
		vim.api.nvim_set_current_line(new_line)

		vim.api.nvim_win_set_cursor(0, cursor)
		vim.notify("Marked as TODO", vim.log.levels.INFO)
	else
		-- Not a checkbox line, insert [TODO] after existing list marker (or add one)
		local indent = line:match("^(%s*)")
		local list_marker = marker or "-"
		local rest = line:match("^%s*[%-%*+]%s*(.*)") or line:match("^%s*(.*)")
		local new_line = indent .. list_marker .. " [TODO] " .. rest
		vim.api.nvim_set_current_line(new_line)

		vim.api.nvim_win_set_cursor(0, cursor)
		vim.notify("Added TODO", vim.log.levels.INFO)
	end
end

return M
