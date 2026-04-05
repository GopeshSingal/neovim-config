-----------------
-- Vim Options --
-----------------
vim.o.termguicolors = true
vim.o.winborder = "rounded"
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NonText", { bg = "none" })

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"

vim.o.cursorline = true

vim.o.wrap = false
vim.o.scrolloff = 12

-- Tabbing
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.smartindent = true

-- Searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true

-- Clipboard / Undo
vim.o.clipboard = "unnamedplus"
local undodir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
vim.o.undodir = undodir
vim.o.undofile = true

vim.opt.path:append("**")

----------------
-- Keymapping --
----------------
vim.g.mapleader = " "
vim.g.localleader = ","

vim.keymap.set("n", "<Leader>w", ":w<CR>", { desc = "Write buffer" })
vim.keymap.set("n", "<Leader>q", ":q<CR>", { desc = "Quit buffer" })

vim.keymap.set("n", "<Leader>c", ":nohlsearch<CR>", { desc = "Clear highlighted results" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-------------------
-- Auto Commands --
-------------------
local cfggroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = cfggroup,
    desc = "Highlight text when yanking it",
    callback = function()
        vim.highlight.on_yank()
    end,
})

-------------------------
-- Plugin Installation --
-------------------------
vim.pack.add({
    "https://www.github.com/lewis6991/gitsigns.nvim",
})

-- GitSigns
require("gitsigns").setup({
	signs = {
		add = { text = "\u{2590}" }, -- ▏
		change = { text = "\u{2590}" }, -- ▐
		delete = { text = "\u{2590}" }, -- ◦
		topdelete = { text = "\u{25e6}" }, -- ◦
		changedelete = { text = "\u{25cf}" }, -- ●
		untracked = { text = "\u{25cb}" }, -- ○
	},
	signcolumn = true,
	current_line_blame = false,
})

-----------------------
-- LSP Configuration --
-----------------------
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = "v.1.6.0"
	},
    "https://github.com/L3MON4D3/LuaSnip",
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
    ensure_installed = {
        -- LSPs
        "lua_ls",
        "rust_analyzer",
        -- Formatters / Linters
        "stylua",

    }
})


vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = {
					"vim",
					"require",
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})

vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            checkOnSave = true,
            check = {
                command = "clippy",
            },
        },
    },
})

require("blink.cmp").setup({
    keymap = {
        preset = "none",
        ["<C-Space>"] = { "show", "hide" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
    appearance = { nerd_font_variant = "mono" },
    completion = { menu = { auto_show = true } },
    sources = { default = { "lsp", "path", "buffer", "snippets" } },
    snippets = {
        expand = function(snippet)
            require("luasnip").lsp_expand(snippet)
        end,
    },
    fuzzy = {
        implementation = "prefer_rust",
    },
})
