-- Setup
local pack = vim.pack
local plugins = {
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/hrsh7th/nvim-cmp',
    'https://github.com/hrsh7th/cmp-nvim-lsp',
    'https://github.com/L3MON4D3/LuaSnip',
    'https://github.com/rebelot/kanagawa.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
    'https://github.com/tpope/vim-surround',
    'https://github.com/tpope/vim-commentary',
    'https://github.com/williamboman/mason.nvim',
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/kdheepak/lazygit.nvim',
    'https://github.com/hrsh7th/cmp-buffer'
}
pack.add(plugins)

vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
vim.g.mapleader = ' '
vim.filetype.add({
    extension = { env = "sh" },
    pattern = {
        ["%.env.*"] = "sh",
        ["docker%-compose%.y[a]?ml"] = "yaml", -- Map to yaml so it's 'known'
        ["compose%.y[a]?ml"] = "yaml", 
    },
})
local api = vim.api

-- Options
local opt = vim.opt
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.splitbelow = true
opt.splitright = true
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.scrolloff = 8
opt.mouse = 'a'
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.wrap = false
opt.swapfile = false
opt.undofile = true
opt.signcolumn = 'yes'

-- 1. General Keymaps
local keymap = vim.keymap.set
keymap('n', '<leader>s', ':source<CR>', { desc = "Source NeoVim Configuration" })
keymap('n', 'ö', ':bprevious<cr>', { desc = "Prev Buffer" })
keymap('n', 'ä', ':bnext<cr>',     { desc = "Next Buffer" })
keymap('n', '<leader>-', ':bdelete<cr>', { desc = "Close Buffer" })
keymap('n', '<leader>w', ':w<cr>', { desc = "Save" })
keymap('n', '<leader>q', ':q<cr>', { desc = "Quit" })
keymap('v', 'J', ':m ">+1<CR>gv=gv', { desc = "Move line down" })
keymap('v', 'K', ':m "<-2<CR>gv=gv', { desc = "Move line up" })
keymap('n', '<leader>c', ':noh<cr>', { desc = "Clear search highlights" })

-- 2. Telescope (Search & Find)
local builtin = require('telescope.builtin')
keymap('n', '<leader>f', builtin.find_files, { desc = "Find Files" })
keymap('n', '<leader>g', builtin.live_grep,  { desc = "Grep Search" })
keymap('n', '<leader>b', builtin.buffers,    { desc = "Find Buffers" })
keymap('n', '<leader>vh', builtin.help_tags, { desc = "Search Help" })
keymap('n', '<leader>p',  builtin.git_files, { desc = "Git Files" })

-- 3. Telescope UI Setup
require('telescope').setup{
    defaults = {
        layout_strategy = 'bottom_pane',
        layout_config = { 
            height = 0.4,
            prompt_position = "top",
        },
        sorting_strategy = 'ascending',
        border = true,
        mappings = {
            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
            }
        }
    }
}
require('telescope').load_extension('fzf')

-- 4. Oil Setup
require('oil').setup({
    default_file_explorer = true,
    columns = { "icon", "permissions" },
    keymaps = {
        ["<CR>"] = "actions.select", -- Ensures hitting Enter opens the file or folder
        ["-"]    = "actions.parent", -- Go up a directory level
    },
    view_options = {
        show_hidden = true, -- Changed this to true so you can see .env files!
    },
    win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
    },
    -- Use 'float' for a popup or keep it default for a full buffer
    win_options = {
        winblend = 0,
    },
})

keymap('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- 5. Theme
require('kanagawa').setup({
    theme = 'wave',
    transparent = true,
    background = { dark = "wave", light = "lotus" },
    colors = { palette = {}, theme = { wave = {}, lotus = {}, dragon = {}, all = {} }, },
})

vim.cmd('colorscheme kanagawa-dragon')

-- 6. Mason
require('mason').setup()

-- 7. LSP
local lsp = vim.lsp
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lsp.config('*', { capabilities = capabilities })

-- docker-language-server
lsp.config('docker_language_server', {
    filetypes = { 'dockerfile', 'yaml' },
    root_markers = { "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml" },
    capabilities = capabilities,
    -- This is the "Beast" logic: It checks if the file is a compose file before starting
    on_new_config = function(new_config, new_root_dir)
        local is_compose = string.match(vim.api.nvim_buf_get_name(0), "compose")
        if not is_compose then
            new_config.enabled = false
        end
    end,
})
lsp.enable('docker_language_server')

-- Ruff (Fast Linting/Formatting)
lsp.enable('ruff')

-- BasedPyright (Type Checking)
lsp.config('basedpyright', {
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = 'standard',
                autoSearchPaths = true,
                diagnosticSeverityOverrides = {
                    reportArgumentType = "none",
                    reportAttributeAccessIssue = "none",
                },
            }
        }
    }
})
lsp.enable('basedpyright')

-- bash-language-server
lsp.config('bashls', {
    filetypes = { 'sh', 'bash' },
    capabilities = capabilities,
})

vim.lsp.enable('bashls')

api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local opts = { buffer = args.buf }
        keymap('n', 'gd', lsp.buf.definition, opts)
        keymap('n', 'gr', lsp.buf.references, opts)
        keymap('n', 'K', lsp.buf.hover, opts)
        keymap('n', '<leader>r', lsp.buf.rename, opts)
        keymap('n', '<leader>a', lsp.buf.code_action, opts)
        keymap('i', '<C-k>', lsp.buf.signature_help, opts)
    end,
})

api.nvim_create_autocmd('BufWritePre', {
    callback = function()
        pcall(function()
            lsp.buf.format({ async = false, timeout_ms = 1000 })
        end)
    end,
})
keymap('n', '<leader>F', lsp.buf.format, { desc = 'Format buffer' })

-- 8. LazyGit
keymap('n', '<leader>lg', ':LazyGit<CR>', { silent = true })

-- 9. CMP
local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<C-e>'] = cmp.mapping.abort(),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
    },
})

-- 10. Folding
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99      -- Start with everything open
opt.foldlevelstart = 99 -- Ensure new buffers follow this rule
opt.foldenable = true
