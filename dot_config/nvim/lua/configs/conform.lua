local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    python = { "black" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
    yaml = { "prettier" },
    go = { "prettier" },
    rust = { "prettier" },
    sh = { "shfmt" },
    sql = { "sqlformat" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
