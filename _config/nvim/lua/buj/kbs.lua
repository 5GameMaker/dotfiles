local lslib = require("buj.lib.lsp")

-- Movement
vim.keymap.set('n', 'j', 'gj', { remap = false })
vim.keymap.set('n', 'k', 'gk', { remap = false })
vim.keymap.set('n', '<Up>', 'gk', { remap = false })
vim.keymap.set('n', '<Down>', 'gj', { remap = false })

-- Buffers
vim.keymap.set('n', '<leader>wv', ":vsplit<CR>")
vim.keymap.set('n', '<leader>[', ":bprevious<CR>")
vim.keymap.set('n', '<leader>]', ":bnext<CR>")
vim.keymap.set('n', '<c-[>', ":bprevious<CR>")
vim.keymap.set('n', '<c-]>', ":bnext<CR>")
vim.keymap.set('n', '<leader>b[', ":bprevious<CR>")
vim.keymap.set('n', '<leader>b]', ":bnext<CR>")
vim.keymap.set('n', '<leader>bd', function()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win)
    vim.cmd [[:bnext]]
    vim.api.nvim_buf_delete(buf, {})
end)

-- Windows
vim.keymap.set('n', '<c-h>', "<c-w>h", { remap = true })
vim.keymap.set('n', '<c-j>', "<c-w>j", { remap = true })
vim.keymap.set('n', '<c-k>', "<c-w>k", { remap = true })
vim.keymap.set('n', '<c-l>', "<c-w>l", { remap = true })
vim.keymap.set('n', '<leader>t', ":NvimTreeToggle<CR>")
vim.keymap.set('n', '<leader>wq', function()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win)
    vim.api.nvim_buf_delete(buf, {})
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
end)
vim.keymap.set('n', '<leader>wc', '<cmd>q<CR>', { desc = "Quit" })
vim.keymap.set('n', '<leader>wC', '<cmd>q!<CR>', { desc = "Quit without saving" })

-- Project
vim.keymap.set('n', '<leader>o', "<cmd>cd /media/data/projects/", { desc = "Open project.." })

-- Files
vim.keymap.set('n', '<leader>fs', "<cmd>w<CR>", { desc = "Save" })
vim.keymap.set('n', '<leader>fS', "<cmd>wa<CR>", { desc = "Save all" })
vim.keymap.set('n', '<leader>fn', "<cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set('n', '<leader>fo', "<cmd>e ", { desc = "Reload file" })

-- Git
vim.keymap.set('n', '<leader>ga', "<cmd>Git add .<CR>", { desc = "Add all to git" })
vim.keymap.set('n', '<leader>gc', "<cmd>Git commit -a<CR>", { desc = "Commit changes" })
vim.keymap.set('n', '<leader>gp', "<cmd>Git push origin<CR>", { desc = "Push to origin" })
vim.keymap.set('n', '<leader>gP', "<cmd>Git push ", { desc = "Push to.." })
vim.keymap.set('n', '<leader>gr', "<cmd>Git pull -r<CR>", { desc = "Pull changes" })

-- Font
vim.keymap.set({ 'n', 'v', 'i' }, '<C-->', "<cmd>DecreaseFont<CR>")
vim.keymap.set({ 'n', 'v', 'i' }, '<C-=>', "<cmd>IncreaseFont<CR>")
vim.keymap.set({ 'n', 'v', 'i' }, '<C-+>', "<cmd>ResetFontSize<CR>")

-- Search
vim.keymap.set('n', '<escape>', "<cmd>noh<CR>", { remap = true })

-- LSP
vim.keymap.set('n', '<leader>cr', function() vim.lsp.buf.rename() end, { desc = "Rename symbol" })
vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, { desc = "Code action.." })
vim.keymap.set('n', '<leader>cd', function() vim.lsp.buf.definition() end, { desc = "Jump to definition" })
vim.keymap.set('n', '<leader>cR', function() vim.lsp.buf.references() end, { desc = "Jump to reference.." })

-- Tools
vim.keymap.set('n', '<leader>Cc', "<cmd>PickColor<cr>", { noremap = true, silent = true, desc = "Pick color" })
vim.keymap.set('i', '<C-leader>c', "<cmd>PickColorInsert<cr>", { noremap = true, silent = true, desc = "Pick color" })

-- Dap
vim.keymap.set('n', '<leader>cb', function() require('dap').toggle_breakpoint() end,
    { noremap = true, silent = true, desc = "Toggle breakpoint" })

local lastRunFunction = nil

local function run(command)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CMD>vsplit<CR><C-w>l", true, false, true), 'n', true)
    if ROOT_PATH ~= nil then vim.uv.chdir(ROOT_PATH) end
    vim.api.nvim_feedkeys('<CMD>terminal ', 'n', false)
    vim.api.nvim_feedkeys(command, 'n', false)
    vim.api.nvim_feedkeys('\r', 'n', false)
end

-- Execution
vim.keymap.set('n', '<leader>ct', function() run("") end, { desc = "Open terminal" })
vim.keymap.set('n', '<leader>ce', function()
    local f = lastRunFunction or lslib.get_command()
    if #f == 0 then
        print("No command has been set")
        return
    end

    run(f)
end, { desc = "Run" })
vim.keymap.set('n', '<leader>cE', function()
    vim.ui.input({ prompt = "Run command: ", default = lastRunFunction or lslib.get_command() }, function(command)
        if command == nil then return end

        lastRunFunction = vim.fn.trim(command)

        if #lastRunFunction == 0 then
            lastRunFunction = nil
            print("No command has been set")
            return
        end

        run(lastRunFunction)
    end)
end, { desc = "Run.." })
vim.keymap.set('n', '<leader>cx', function()
    vim.ui.input({ prompt = "Run command: " }, function(command)
        if command == nil or #command == 0 then
            print("No command has been set")
            return
        end

        run(command)
    end)
end, { desc = "Run command (no save)" })

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
