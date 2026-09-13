local todo = require("todo")

vim.api.nvim_create_user_command("TodoToggle", function()
	todo.toggle()
end, {})
