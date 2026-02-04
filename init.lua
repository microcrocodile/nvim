require('config.options')
require('config.keybinds')
require('config.lazy')
require('lualine').setup()

vim.lsp.enable('based')
vim.lsp.enable('ruff')
vim.lsp.enable('ra')

vim.lsp.config('*', {
    capabilities = {
        general = {
            positionEncodings = { 'utf-16' }
        }
    }
})

vim.cmd("colorscheme dayfox")


vim.diagnostic.config({
    severity_sort = true,
    float = {
        border = 'rounded',
        source = 'if_many',
    },
    underline = {
        severity = vim.diagnostic.severity.ERROR,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
    },
--    virtual_text = {
--        source = 'if_many',
--        spacing = 2,
--        format = function(diagnostic)
--            local diagnostic_message = {
--                [vim.diagnostic.severity.ERROR] = diagnostic.message,
--                [vim.diagnostic.severity.WARN] = diagnostic.message,
--                [vim.diagnostic.severity.INFO] = diagnostic.message,
--                [vim.diagnostic.severity.HINT] = diagnostic.message,
--            }
--
--            if diagnostic.code == nil then
--                return diagnostic_message[diagnostic.severity]
--            else
--                return string.format('%s: %s', diagnostic.code, diagnostic_message[diagnostic.severity])
--            end
--        end,
--    },
})

local main_group = vim.api.nvim_create_augroup("MyLspAttachHooks", { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
    group = main_group,
    callback = function(args)
        local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, {
                buffer = args.buf,
                desc = 'LSP: ' .. desc,
            })
        end

        local id = vim.tbl_get(args, 'data', 'client_id')
        local client = id and vim.lsp.get_client_by_id(id)

        if client == nil then
            return
        end

        if client.supports_method('textDocument/documentHighlight') then
            local group = vim.api.nvim_create_augroup('highlight_symbol', { clear = false })

            vim.api.nvim_clear_autocmds({
                buffer = args.buf,
                group = group,
            })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = args.buf,
                group = group,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI'}, {
                buffer = args.buf,
                group = group,
                callback = vim.lsp.buf.clear_references,
            })
        end

        if client.supports_method('textDocument/inlayHint') then
            local methods = vim.lsp.protocol.Methods
            local inlay_hint_handler = vim.lsp.handlers[methods.textDocument_inlayHint]

            vim.lsp.handlers[methods.textDocument_inlayHint] = function(err, result, ctx, config)
                if client.name == 'based' then
                    result = vim.tbl_map(function(hint)
                        local label = hint.label ---@type string
                        if label:len() >= 25 then
                            label = label:sub(1, 24) .. "..."
                        end
                        hint.label = label
                        return hint
                    end, result)
                end

                inlay_hint_handler(err, result, ctx, config)
            end

            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end

        local non_c_line_comments_by_filetype = {
            lua = "--",
            python = "#",
            sql = "--",
        }

        local function comment_out(opts)
            local line_comment = non_c_line_comments_by_filetype[vim.bo.filetype] or "//"
            local start = math.min(opts.line1, opts.line2)
            local finish = math.max(opts.line1, opts.line2)

            vim.api.nvim_command(start .. "," .. finish .. "s:^:" .. line_comment .. ":")
            vim.api.nvim_command("noh")
        end

        local function uncomment(opts)
            local line_comment = non_c_line_comments_by_filetype[vim.bo.filetype] or "//"
            local start = math.min(opts.line1, opts.line2)
            local finish = math.max(opts.line1, opts.line2)

            pcall(vim.api.nvim_command, start .. "," .. finish .. "s:^\\(\\s\\{-\\}\\)" .. line_comment .. ":\\1:")
            vim.api.nvim_command("noh")
        end

        local function format()
            vim.lsp.buf.format { async = true }
        end

        vim.api.nvim_create_user_command("CommentOut", comment_out, { range = true })
        vim.api.nvim_create_user_command("Uncomment", uncomment, { range = true })

        map('[d', vim.diagnostic.goto_prev, 'Goto Previous Problem')
        map(']d', vim.diagnostic.goto_next, 'Goto Next Problem')
        map('<C-w>d', vim.diagnostic.open_float, 'Open Float')
        map('<C-s>', vim.lsp.buf.signature_help, 'Help with [S]ignature', { 'i', 's' })
        map('<leader>co', ':CommentOut<CR>', '[Co]mment Out Block', { 'v', 'n' })
        map('<leader>uc', ':Uncomment<CR>', '[U]n[C]omment Block', { 'v', 'n' })
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>aa', vim.lsp.buf.code_action, '[A]pply Code [A]ction', { 'n', 'x' })
        map('<leader>gr', vim.lsp.buf.references, '[G]oto [R]eferences')
        map('<leader>gi', vim.lsp.buf.implementation, '[G]oto [I]mplementations')
        map('<leader>gd', vim.lsp.buf.definition, '[G]oto [D]efinitions')
        map('<leader>gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('<leader>gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
        map('<leader>gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
        map('<leader>gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
        map('<leader>fc', format, '[F]ormat [C]ode')
    end,
    desc = 'LSP: handle on attach tasks',
})
