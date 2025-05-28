local capabilities = require('cmp_nvim_lsp').default_capabilities()

local commands = {}
local specials = {}

local module = {}

local function on_new_config(new_config, new_root_path) end
local function on_init(client, result)
    -- print("Client " .. client.id .. "has been initialized")
end
local function on_exit(code, signal, client_id)
    specials[client_id] = nil
    commands[client_id] = nil
end
local function on_attach(client, bufid)
    -- print("Client " .. client.id .. " has connected to buffer " .. bufid .. "!")
end

local function addfn(config, f, fn)
    if config[f] == nil then
        config[f] = fn
    elseif type(config[f]) == "function" then
        local orig = config[f]
        config[f] = function(...)
            fn(...)
            orig(...)
        end
    else
        error("invalid type!")
    end
end

function module.s(config)
    if config == nil then
        config = {}
    end
    if config.single_file_support == nil then
        config.single_file_support = true
    end
    if config.capabilities == nil then
        config.capabilities = capabilities
    end
    addfn(config, "on_new_config", on_new_config)
    addfn(config, "on_init", on_init)
    addfn(config, "on_exit", on_exit)
    addfn(config, "on_attach", on_attach)
    return config
end

function module.set_command(lspid, command)
    commands[lspid] = command
end

---Get command suggested by an lsp
---@return string?
function module.get_command()
    for _, client in pairs(module.buf_lsps()) do
        if commands[client.id] ~= nil then
            return commands[client.id]
        end
    end
end

function module.set_special(lspid, name, fun)
    if specials[lspid] == nil then
        specials[lspid] = {}
    end
    specials[lspid][name] = fun
end

function module.invoke_special(name)
    for _, client in pairs(module.buf_lsps()) do
        if specials[client.id] ~= nil and specials[client.id][name] ~= nil then
            specials[client.id][name]()
        end
    end
    vim.notify("No LSP providing action '" .. name .. "' in current buffer!")
end

---Get lsps active in current buffer.
---@return table
function module.buf_lsps()
    local bufid = vim.api.nvim_get_current_buf()
    local clients = {}
    for _, value in pairs(vim.lsp.get_clients({ bufid = bufid })) do
        if value.attached_buffers[bufid] ~= true then
            goto continue
        end
        table.insert(clients, value)

        ::continue::
    end
    return clients
end

return module
