vim.o.number = true
vim.o.relativenumber = true
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
vim.o.winborder = "rounded"
vim.o.signcolumn = "yes"
vim.o.wrap = false

-- vim.opt.cursorline = true
-- vim.opt.cursorcolumn = true

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.smartindent = true

-- Allow OS clipboard to sync with NeoVim
vim.o.clipboard = "unnamedplus"

vim.o.syntax = "enable"

vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.smartcase = true
vim.o.hlsearch = true

vim.o.scrolloff = 4

-- Undo persistence
local path = vim.fn.stdpath("cache") .. "/undo"
vim.fn.mkdir(path, "p")
vim.o.undodir = path
vim.o.undofile = true

----- Language Server Protocols -----

-- Go LSP (gopls)
vim.lsp.config("gopls", {
    cmd = { "gopls" },
    settings = {
        gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = {
                unusedparams = true,
                nilness = true,
                unusedwrite = true,
            },
        },
    },
})
vim.lsp.enable("gopls")

-- Python LSP (pyright)
vim.lsp.config("pyright", {
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
            },
        },
    },
})
vim.lsp.enable("pyright")

-- Terraform LSP (terraform-ls)
vim.lsp.config("terraformls", {
    cmd = { "terraform-ls", "serve" },
    filetypes = { "terraform", "terraform-vars" },
})
vim.lsp.enable("terraformls")

-- Terraform lint diagnostics (tflint)
vim.lsp.config("tflint", {
    cmd = { "tflint", "--langserver" },
    filetypes = { "terraform", "terraform-vars" },
})
vim.lsp.enable("tflint")

-- Lua LSP (lua_ls)
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})
vim.lsp.enable("lua_ls")

-- YAML LSP (yaml-language-server)
vim.lsp.config("yamlls", {
    cmd = { "yaml-language-server", "--stdio" },
    settings = {
        yaml = {
            validate = true,
            hover = true,
            completion = true,
            schemas = {
                kubernetes = { "k8s/*.yaml", "k8s/*.yml", "*.k8s.yaml", "*.k8s.yml" },
            },
            schemaStore = { enable = true },
        },
    },
})
vim.lsp.enable("yamlls")

-- Docker LSP (docker-language-server)
vim.lsp.config("docker_language_server", {
    cmd = { "docker-language-server", "start", "--stdio" },
    filetypes = {
        "dockerfile", "Dockerfile"
    },
})
vim.lsp.enable("docker_language_server")

----- Keymapping ------

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set("n", "<Leader>w", ":w<CR>", { desc = "Write buffer" })
vim.keymap.set("n", "<Leader>q", ":q<CR>", { desc = "Quit buffer" })

vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<Leader>k", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "<Leader>gd", vim.lsp.buf.definition, { desc = "Goto definition" })
vim.keymap.set("n", "<Leader>gr", vim.lsp.buf.references, { desc = "Goto references" })
vim.keymap.set("n", "<Leader>gD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
vim.keymap.set("n", "<Leader>lf", vim.lsp.buf.format, { desc = "Language format" })

vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "<Esc>", "<cmd>noh<CR><Esc>", { desc = "Clear search highlights" })

-- Comment / Uncommenting
vim.keymap.set("n", "<leader>/", function()
  local cs = vim.bo.commentstring:gsub("%%s", "")
  vim.cmd("normal! I" .. cs .. " ")
end, { desc = "Comment line" })

vim.keymap.set("n", "<leader>?", function()
  local cs = vim.bo.commentstring:gsub("%%s", ""):gsub("%s+$", "")
  vim.cmd("normal! ^")
  vim.cmd("normal! df" .. cs)
end, { desc = "Uncomment line" })
