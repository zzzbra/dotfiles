require("flutter-tools").setup({
    flutter_path="/Users/aslan/opt/flutter/bin/flutter",
    dev_tools = {
        autostart = true,
        auto_open_browser = true,
    },
    widget_guides = {
        enabled = true,
        debug = true,
    },
    debugger = {
        enabled = true,
        run_via_dap = true,
    },
})
