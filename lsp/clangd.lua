return {
    cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_markers = {
        '.git',
        'compile_commands.json',
        'compile_flags.txt'
    },
    single_file_support = true
}
