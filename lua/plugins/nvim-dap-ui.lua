return {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
        local dap, dapui = require("dap"), require("dapui")

        dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
        end

        dapui.setup {}
    end

}
