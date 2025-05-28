local lsp = require('lspconfig')
local cmp = require('cmp')
local lslib = require('buj.lib.lsp')

local s = lslib.s

local lsp_configs = require('lspconfig.configs')
if not lsp_configs.avalonia then
    local root_pattern = require("lspconfig.util").root_pattern
    lsp_configs.avalonia = {
        default_config = {
            cmd = { "dotnet", "/usr/lib/avalonia-ls/avalonia-preview/AvaloniaLanguageServer.dll" },
            root_dir = root_pattern("*.csproj"),
            filetypes = { "axaml", "xml" },
        },
    }
end

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
            checkOnSave = true,
        }
    },
    on_init = function(client, _)
        lslib.set_command(client.id, "cargo run")
    end
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
lsp.omnisharp.setup(s {
    cmd = { "/usr/bin/omnisharp", "--languageserver" }
})
lsp.avalonia.setup(s {
    on_new_config = function(_, root)
        print("New path! " .. root)
        vim.system({ "avalonia-solution-parser", root })
    end
})
require('sonarlint').setup(s {})

local doAutoformat = true

vim.api.nvim_create_user_command(
    'AutoFormat',
    function(_)
        doAutoformat = true
        print("Enabled auto-formatting")
    end,
    { nargs = 0 }
)

vim.api.nvim_create_user_command(
    'NoAutoFormat',
    function(_)
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

vim.api.nvim_create_user_command(
    'DebugBufferShowLsps',
    function(_)
        local bufid = vim.api.nvim_get_current_buf()
        for _, value in pairs(vim.lsp.get_clients({ bufid = bufid })) do
            if value.attached_buffers[bufid] ~= true then
                goto continue
            end
            print(value.name .. "(id=" .. value.id .. ")")

            ::continue::
        end
    end,
    { nargs = 0 }
)
