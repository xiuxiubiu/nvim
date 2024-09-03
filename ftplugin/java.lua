local jdtls = require('jdtls')

local bundles = {
    vim.fn.glob(
        "/Users/xudong/Documents/github/microsoft/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
        true)
};
vim.list_extend(bundles, vim.split(vim.fn.glob(
                                       "/Users/xudong/Documents/github/microsoft/vscode-java-test/server/*.jar",
                                       true), "\n"))
local config = {
    cmd = {'/opt/homebrew/bin/jdtls'},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'},
                                          {upward = true})[1]),
    init_options = {bundles = bundles}

}
jdtls.start_or_attach(config)
