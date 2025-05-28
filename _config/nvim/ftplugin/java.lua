local lslib = require("buj.lib.lsp")

xpcall(function()
    local home = vim.uv.os_homedir()
    local lombok = home .. "/.jdtls/plugins/lombok.jar"
    local root_dir = nil

    pcall(function() root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]) end)
    if root_dir == nil then
        root_dir = vim.uv.cwd()
    end

    local cmd = { "env", "JAVA_HOME=/lib/jvm/java-21-openjdk", "/bin/jdtls" }
    if vim.uv.fs_stat(lombok) then
        table.insert(cmd, "--jvm-arg=-javaagent:" .. home .. "/.jdtls/plugins/lombok.jar")
    end
    for _, value in pairs({
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx4g",
    }) do
        table.insert(cmd, value)
    end

    local config = {
        cmd = cmd,
        root_dir = root_dir,
    }
    require('jdtls').start_or_attach(lslib.s(config))
end, function(x) vim.notify("Failed to start jdtls:\n" .. x, "error") end)
