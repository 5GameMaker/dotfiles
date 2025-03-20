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
vim.keymap.set('n', '<leader>wc', ':q<CR>')
vim.keymap.set('n', '<leader>wC', ':q!<CR>')

-- Project
vim.keymap.set('n', '<leader>o', ":cd /media/data/projects/")

-- Files
vim.keymap.set('n', '<leader>fs', ":w<CR>")
vim.keymap.set('n', '<leader>fS', ":wa<CR>")
vim.keymap.set('n', '<leader>fn', ":tabnew<CR>")
vim.keymap.set('n', '<leader>fo', ":e ")

-- Git
vim.keymap.set('n', '<leader>ga', ":Git add .<CR>")
vim.keymap.set('n', '<leader>gc', ":Git commit -a<CR>")
vim.keymap.set('n', '<leader>gp', ":Git push origin<CR>")
vim.keymap.set('n', '<leader>gP', ":Git push ")
vim.keymap.set('n', '<leader>gr', ":Git pull -r<CR>")

-- Font
vim.keymap.set({ 'n', 'v', 'i' }, '<C-->', ":DecreaseFont<CR>")
vim.keymap.set({ 'n', 'v', 'i' }, '<C-=>', ":IncreaseFont<CR>")
vim.keymap.set({ 'n', 'v', 'i' }, '<C-+>', ":ResetFontSize<CR>")

-- Search
vim.keymap.set('n', '<escape>', ":noh<CR>", { remap = true })

-- LSP
vim.keymap.set('n', '<leader>cr', function() vim.lsp.buf.rename() end)
vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end)
vim.keymap.set('n', '<leader>cd', function() vim.lsp.buf.definition() end)
vim.keymap.set('n', '<leader>cR', function() vim.lsp.buf.references() end)

-- Tools
vim.keymap.set('n', '<leader>Cc', "<cmd>PickColor<cr>", { noremap = true, silent = true })
vim.keymap.set('i', '<C-leader>c', "<cmd>PickColorInsert<cr>", { noremap = true, silent = true })

local lastRunFunction = ""

local function run(command)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":vsplit<CR><C-w>l", true, false, true), 'n', true)
    if ROOT_PATH ~= nil then vim.uv.chdir(ROOT_PATH) end
    vim.api.nvim_feedkeys(':terminal ', 'n', false)
    vim.api.nvim_feedkeys(command, 'n', false)
    vim.api.nvim_feedkeys('\r', 'n', false)
end

-- Execution
vim.keymap.set('n', '<leader>ct', function() run("") end)
vim.keymap.set('n', '<leader>ce', function()
    if #lastRunFunction == 0 then
        print("No command has been set")
        return
    end

    run(lastRunFunction)
end)
vim.keymap.set('n', '<leader>cE', function()
    vim.ui.input({ prompt = "Run command: ", default = lastRunFunction }, function(command)
        if command == nil then return end

        lastRunFunction = vim.fn.trim(command)

        if #lastRunFunction == 0 then
            print("No command has been set")
            return
        end

        run(lastRunFunction)
    end)
end)
vim.keymap.set('n', '<leader>cx', function()
    vim.ui.input({ prompt = "Run command: " }, function(command)
        if command == nil or #command == 0 then
            print("No command has been set")
            return
        end

        run(command)
    end)
end)

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Backspace

-- local function backspace()
--
-- end
-- vim.keymap.set('i', '<S-BS>', '<BS>')
--
