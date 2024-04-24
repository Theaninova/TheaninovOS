require("darkman").setup()
require("cmp-npm").setup({})
require("rest-nvim").setup({})
require("actions-preview").setup({})

if vim.g.neovide then
	-- no idea why this is needed
	vim.opt.linespace = -1
end

local signs = {
	{ name = "DiagnosticSignError", text = "" },
	{ name = "DiagnosticSignWarn", text = "" },
	{ name = "DiagnosticSignHint", text = "󰌵" },
	{ name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = false,
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	dir = "git_dir",
	direction = "float",

	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	on_close = function(term)
		vim.cmd("startinsert!")
	end,
})

function _lazygit_toggle()
	lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

vim.api.nvim_create_user_command("ConformToggle", function(args)
	if args.bang then
		vim.b.disable_autoformat = not vim.b.disable_autoformat
	else
		vim.g.disable_autoformat = not vim.g.disable_autoformat
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
