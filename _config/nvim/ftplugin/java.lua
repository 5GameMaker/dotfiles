local config = {
    cmd = { 'env', 'JAVA_HOME=/lib/jvm/java-21-openjdk', '/bin/jdtls', "--jvm-arg=-javaagent:/home/buj/.jdtls/plugins/lombok.jar" },
    root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)
