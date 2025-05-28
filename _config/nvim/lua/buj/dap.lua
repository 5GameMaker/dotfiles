local dap = require('dap');
local json = require('json5');

dap.adapters.gdb_rust = {
    type = "executable",
    command = "rust-gdb",
    name = "lldb",
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}

dap.adapters.coreclr = {
    type = 'executable',
    command = 'netcoredbg',
    args = { '--interpreter=vscode' },
    name = 'netcoredbg',
}

local function exists(path)
    local file = io.open(path, "r")
    if file ~= nil then io.close(file) end
    return file ~= nil
end

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

vim.api.nvim_create_user_command(
    "DapReloadTargets",
    function(opts)
        dap.configurations.rust = {}
        if exists("Cargo.toml") then
            local metadata_text = vim.system({ "cargo", "metadata", "--format-version", "1", "--no-deps" },
                { text = true }):wait().stdout
            local metadata = json.parse(metadata_text)
            for _, o in ipairs(metadata.packages) do
                for _, t in ipairs(o.targets) do
                    if has_value(t.kind, 'bin') then
                        dap.configurations.rust[#dap.configurations.rust + 1] = setmetatable({
                            {
                                name = "Launch " .. t.name,
                                type = "gdb_rust",
                                request = "launch",
                                program = function()
                                    return metadata.target_directory .. "/debug/" .. t.name
                                end,
                                cwd = t.workspace_root,
                                stopAtBeginningOfMainSubprogram = false,
                            },
                        }, {
                            __call = function(config)
                                return config
                            end
                        })
                    end
                end
            end
        end
    end,
    { nargs = 0 }
)
vim.cmd [[:DapReloadTargets]]
