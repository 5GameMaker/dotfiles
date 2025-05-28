vim.notify = require('notify')

require('bufferline').setup {}
require('nvim-tree').setup {
    sort = {
        sorter = 'case_sensitive',
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
}
vim.cmd.colorscheme 'catppuccin-mocha'
vim.diagnostic.config({
    signs = {
        active = {
            { name = "DiagnosticSignError", text = "" },
            { name = "DiagnosticSignWarn", text = "" },
            { name = "DiagnosticSignInfo", text = "" },
            { name = "DiagnosticSignHint", text = "" },
        },
    },
})
vim.fn.sign_define('DapBreakpoint', { text = '•', texthl = 'yellow', linehl = '', numhl = '' })
require('mini.move').setup {
    mappings = {
        left = '<M-left>',
        right = '<M-right>',
        down = '<M-down>',
        up = '<M-up>',

        line_left = '<M-left>',
        line_right = '<M-right>',
        line_down = '<M-down>',
        line_up = '<M-up>',
    },
}
require('mini.move').setup {
    mappings = {
        left = '<M-h>',
        right = '<M-l>',
        down = '<M-j>',
        up = '<M-k>',

        line_left = '<M-h>',
        line_right = '<M-l>',
        line_down = '<M-j>',
        line_up = '<M-k>',
    },
}
require("nvim-ts-autotag").setup()
local autopairs = require("nvim-autopairs")
autopairs.setup {
    map_bs = false,
    enable_check_bracket_line = true,
}
local function backspace()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))

    local current_line = vim.api.nvim_get_current_line()
    local whitespace_len = 1
    while whitespace_len <= col do
        local s = current_line:sub(col - whitespace_len + 1, col)
        if s:match("^%s*$") then
            whitespace_len = whitespace_len + 1
        else
            break
        end
    end
    whitespace_len = whitespace_len - 1

    if whitespace_len > 0 or col == 0 then
        local back = ""
        if line ~= 1 and ((current_line:sub(0, col):match("^%s*$") and not current_line:match("^%s*$")) or current_line:match("^%s*$")) then
            local previous_line = vim.api.nvim_buf_get_lines(0, line - 2, line - 1, true)[1]
            local prev_line_col = #previous_line
            local prev_ws_len = 1
            while prev_ws_len <= #previous_line do
                local s = previous_line:sub(#previous_line - prev_ws_len + 1)
                if s:match("^%s*$") then
                    prev_ws_len = prev_ws_len + 1
                else
                    break
                end
            end
            prev_ws_len = prev_ws_len - 1
            local spc = (" "):rep(whitespace_len)
            local rem = ""
            if previous_line:match("^%s*$") then
                if prev_line_col ~= 0 then
                    rem = "<Left><C-o>v0\"_d"
                end
            elseif prev_ws_len == 0 then
                spc = " "
            elseif prev_ws_len == 1 then
                spc = ""
            elseif prev_ws_len > 1 then
                spc = " "
                rem = "<Left><C-o>v" .. (prev_ws_len - 1) .. "h\"_d"
            end
            back = "<S-BS>" .. rem .. spc
        end
        local rem = ""
        if whitespace_len > 1 then
            if #back == 0 then
                back = " "
            end
            rem = "<Left><C-o>v" .. (whitespace_len - 1) .. "h\"_d"
        elseif whitespace_len == 1 then
            rem = "<S-BS>"
        end
        return vim.api.nvim_replace_termcodes(rem .. back, true, false, true)
    else
        return autopairs.autopairs_bs()
    end
end
vim.keymap.set('i', '<BS>', backspace, {
    expr = true,
    noremap = true,
    replace_keycodes = false,
})
vim.keymap.set('i', '<s-BS>', '<BS>')

local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup {
    indent = {
        highlight = highlight,
        char = '┆',
        tab_char = '·',
    },
    whitespace = {
        highlight = highlight,
        remove_blankline_trail = false,
    },
    scope = { enabled = false },
}

require('rainbow-delimiters.setup').setup {
    highlight = highlight,
}

require('image').setup {
    backend = 'kitty',
    processor = 'magick_cli',
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    integrations = {
        markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            only_render_image_at_cursor_mode = "popup",
            floating_windows = false,
            filetypes = { "markdown", "vimwiki" },
            resolve_image_path = function(document_path, image_path, fallback)
                local path = vim.fs.dirname(document_path) .. "/" .. image_path
                if vim.uv.fs_stat(path) then
                    return path
                end
                path = vim.fs.dirname(vim.fn.getcwd()) .. "/" .. image_path
                if vim.uv.fs_stat(path) then
                    return path
                end
                return fallback(document_path, image_path)
            end
        },
        neorg = {
            enabled = true,
            filetypes = { "norg" },
        },
        typst = {
            enabled = true,
            filetypes = { "typst" },
        },
        html = {
            enabled = true,
        },
        css = {
            enabled = true,
        },
    },
}

-- require("image").setup({
--     backend = "kitty",
--     processor = "magick_cli", -- or "magick_rock"
--     integrations = {
--         markdown = {
--             enabled = true,
--             clear_in_insert_mode = false,
--             download_remote_images = true,
--             only_render_image_at_cursor = false,
--             only_render_image_at_cursor_mode = "popup",
--             floating_windows = false,
--             filetypes = { "markdown", "vimwiki" },
--         },
--         neorg = {
--             enabled = true,
--             filetypes = { "norg" },
--         },
--         typst = {
--             enabled = true,
--             filetypes = { "typst" },
--         },
--         html = {
--             enabled = true,
--         },
--         css = {
--             enabled = true,
--         },
--     },
--     max_width = nil,
--     max_height = nil,
--     max_width_window_percentage = nil,
--     max_height_window_percentage = 50,
--     window_overlap_clear_enabled = false,
--     window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
--     editor_only_render_when_focused = false,
--     tmux_show_only_in_active_window = false,
--     hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
-- })
