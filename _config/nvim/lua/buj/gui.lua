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
-- local autoclose = require("inlined.autoclose")
-- autoclose.setup {
--     keys = {
--         ["("] = { escape = false, close = true, pair = "()" },
--         ["["] = { escape = false, close = true, pair = "[]" },
--         ["{"] = { escape = false, close = true, pair = "{}" },
--
--         [")"] = { escape = true, close = false, pair = "()" },
--         ["]"] = { escape = true, close = false, pair = "[]" },
--         ["}"] = { escape = true, close = false, pair = "{}" },
--
--         ['"'] = { escape = true, close = true, pair = '""' },
--         ["'"] = { escape = true, close = true, pair = "''", disabled_filetypes = { "rust" } },
--         ["`"] = { escape = true, close = true, pair = "``" },
--
--         [" "] = { escape = false, close = true, pair = "  " },
--
--         ["<BS>"] = {},
--         ["<C-H>"] = {},
--         ["<C-W>"] = {},
--         ["<CR>"] = { disable_command_mode = true },
--         ["<S-CR>"] = { disable_command_mode = true },
--     },
--     options = {
--         disabled_filetypes = { "text" },
--         disable_when_touch = false,
--         touch_regex = "[%w(%[{]",
--         pair_spaces = false,
--         auto_indent = true,
--         disable_command_mode = true,
--     },
--     remap = false,
--     disabled = false,
-- }
-- for _, key in ipairs({ "(", ")", "[", "]", "{", "}", '"', "'", "`", " ", "<CR>", "<S-CR>" }) do
--     autoclose.bind(key)
-- end
require('mini.move').setup {
    mappings = {
        -- Move visual selection in Visual mode.
        left = '<M-up>',
        right = '<M-right>',
        down = '<M-down>',
        up = '<M-up>',

        -- Move current line in Normal mode.
        line_left = '<M-left>',
        line_right = '<M-right>',
        line_down = '<M-down>',
        line_up = '<M-up>',
    },
}
require('mini.move').setup {
    mappings = {
        -- Move visual selection in Visual mode.
        left = '<M-h>',
        right = '<M-l>',
        down = '<M-j>',
        up = '<M-k>',

        -- Move current line in Normal mode
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
vim.cmd [[set backspace=indent,eol,start]]
local escape_code = vim.api.nvim_replace_termcodes(
    "<Esc>",
    false, false, true
)
local backspace_code = vim.api.nvim_replace_termcodes(
    "<BS>",
    false, false, true
)
local function viml_backspace()
    -- expression from a deleted reddit user
    vim.cmd([[
        let g:exprvalue =
        \ (&indentexpr isnot '' ? &indentkeys : &cinkeys) =~? '!\^F' &&
        \ &backspace =~? '.*eol\&.*start\&.*indent\&' &&
        \ !search('\S','nbW',line('.')) ? (col('.') != 1 ? "\<C-U>" : "") .
        \ "\<bs>" . (getline(line('.')-1) =~ '\S' ? "" : "\<C-F>") : "\<bs>"
        ]])
    return vim.g.exprvalue
end
local function backspace()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local before_cursor_is_whitespace = vim.api.nvim_get_current_line()
        :sub(0, col)
        :match("^%s*$")

    if not before_cursor_is_whitespace then
        -- return vim.api.nvim_replace_termcodes(autoclose.pressed("<BS>", 'insert'), true, false, true)
        return autopairs.autopairs_bs()
    end
    if line == 1 then
        return viml_backspace()
    end
    local correct_indent = require("nvim-treesitter.indent").get_indent(line)
    local current_indent = vim.fn.indent(line)
    local previous_line_is_whitespace = vim.api.nvim_buf_get_lines(
        0, line - 2, line - 1, false
    )[1]:match("^%s*$")
    if current_indent == correct_indent then
        if previous_line_is_whitespace then
            return viml_backspace()
        end
        return backspace_code
    elseif current_indent > correct_indent then
        return escape_code .. "==0wi"
    end
    return backspace_code
end
vim.keymap.set('i', '<BS>', backspace, {
    expr = true,
    noremap = true,
    replace_keycodes = false,
})
vim.keymap.set('i', '<s-BS>', '<BS>', {
    expr = true,
    noremap = true,
    replace_keycodes = false,
})

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
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
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
