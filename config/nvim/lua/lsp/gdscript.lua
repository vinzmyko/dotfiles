local lsp_utils = require('lsp')

local function setup_gdscript_lsp()
    local project_file = vim.fn.findfile('project.godot', '.;')
    if project_file == '' then
        return
    end

    vim.lsp.start({
        name = 'gdscript',
        cmd = vim.lsp.rpc.connect('127.0.0.1', 6005),
        filetypes = { 'gdscript', 'gdscript3', 'gd' },
        root_dir = lsp_utils.find_root({ 'project.godot', '.git' }),
        on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false

            local opts = { buffer = bufnr }

            if vim.fn.executable('gdformat') == 1 then
                vim.keymap.set('n', '<leader>cf', function()
                    vim.cmd('silent !gdformat %')
                end, opts)
            else
                vim.keymap.set('n', '<leader>cf', function()
                    print("GDScript formatting not available. Install gdtoolkit")
                end, opts)
            end
        end,
    })
end

vim.filetype.add({
    extension = {
        gd = 'gdscript',
        gdscript = 'gdscript',
        tres = 'gdresource',
        tscn = 'gdresource',
    },
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspGDScript", { clear = true }),
    pattern = { "gdscript", "gdscript3", "gd" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = false
        vim.opt_local.smarttab = true

        setup_gdscript_lsp()
    end,
})
