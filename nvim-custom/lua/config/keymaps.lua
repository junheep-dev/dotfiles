vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete buffer" })
