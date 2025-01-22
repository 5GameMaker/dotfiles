local lsp = require('lspconfig')
local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'dotenv' }
    }, {
        { name = 'buffer' },
    }),
})

cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    })
})
require("cmp_git").setup()

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function update_config(_new_config, new_root_path)
    if new_root_path ~= nil then ROOT_PATH = new_root_path end
end

local function s(table)
    table.single_file_support = true
    table.capabilities = capabilities
    table.on_new_config = update_config
    return table
end

lsp.rust_analyzer.setup(s {
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
            },
            inlineHints = {
                enable = true,
            },
            checkOnSave = {
                command = "clippy",
            },
        }
    }
})
lsp.ts_ls.setup(s {})
lsp.zls.setup(s {})
lsp.lua_ls.setup(s {})
lsp.clangd.setup(s {})
lsp.kotlin_language_server.setup(s {})
lsp.glsl_analyzer.setup(s {})
lsp.groovyls.setup(s {
    cmd = { "java", "-jar", "/usr/share/java/groovy-language-server/groovy-language-server-all.jar" },
})
require('sonarlint').setup(s {})

local doAutoformat = true

vim.api.nvim_create_user_command(
    'AutoFormat',
    function(opts)
        doAutoformat = true
        print("Enabled auto-formatting")
    end,
    { nargs = 0 }
)

vim.api.nvim_create_user_command(
    'NoAutoFormat',
    function(opts)
        doAutoformat = false
        print("Disabled auto-formatting")
    end,
    { nargs = 0 }
)

vim.api.nvim_create_user_command(
    'DiagnosticsToggle',
    function()
        local current_value = vim.diagnostic.is_disabled()
        if current_value then
            vim.diagnostic.enable()
        else
            vim.diagnostic.disable()
        end
    end,
    {}
)

vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = buffer,
    callback = function()
        if doAutoformat then vim.lsp.buf.format { async = false } end
    end
})
