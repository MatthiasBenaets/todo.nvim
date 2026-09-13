local M = {}

--- Toggle checkbox between TODO and DONE
M.toggle = function()
	local line = vim.api.nvim_get_current_line()
	local checkbox = line:match("^%s*%- %[(%w+)%]")

	if checkbox == "TODO" then
		local new_line = line:gsub("%[TODO%]", "[DONE]")
		vim.api.nvim_set_current_line(new_line)
		vim.notify("Marked as DONE", vim.log.levels.INFO)
	elseif checkbox == "DONE" then
		local new_line = line:gsub("%[DONE%]", "[TODO]")
		vim.api.nvim_set_current_line(new_line)
		vim.notify("Marked as TODO", vim.log.levels.INFO)
	else
		local new_line = line:gsub("^%s*", "")
		new_line = "- [TODO] " .. new_line
		vim.api.nvim_set_current_line(new_line)
		vim.notify("Added TODO", vim.log.levels.INFO)
	end
end

return M
