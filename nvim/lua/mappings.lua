function map(mode, shortcut, command, opts_override, bufnr)
  local opts = {
    noremap = true,
    silent = true,
  }

  if type(opts_override) == "table" then
    for i, v in pairs(opts_override) do
      opts[i] = v
    end
  end

  if bufnr ~= nil then
    vim.api.nvim_buf_set_keymap(bufnr, mode, shortcut, command, opts)
  else
    vim.api.nvim_set_keymap(mode, shortcut, command, opts)
  end
end

function nmap(shortcut, command, opts)
  map("n", shortcut, command, opts)
end

function nmap_buf(bufnr, shortcut, command, opts)
  map("n", shortcut, command, opts, bufnr)
end

-- Hide search highlighting
nmap("<leader>m", "<cmd>nohlsearch<cr>")

-- Show trailing whitespace
nmap("<leader>w", "<cmd>set nolist!<cr>")

-- Window Control
nmap("<A-->", "<C-w>-")
nmap("<A-+>", "<C-w>+")
nmap("<A-<>", "<C-w><")
nmap("<A->>", "<C-w>>")
nmap("<A-=>", "<C-w>=")

-- Packer
nmap("<leader>pu", "<cmd>PackerUpdate<cr>")
nmap("<leader>ps", "<cmd>PackerSync<cr>")
nmap("<leader>pc", "<cmd>PackerClean<cr>")

-- nvim-tree
nmap("<leader>n", "<cmd>NvimTreeFindFileToggle<cr>")

-- Telescope
nmap("<leader>ff", "<cmd>Telescope find_files<cr>")
nmap("<leader>fg", "<cmd>Telescope live_grep<cr>")
nmap("<leader>fb", "<cmd>Telescope buffers<cr>")
nmap("<leader>fh", "<cmd>Telescope help_tags<cr>")
nmap("<leader>pp", "<cmd>lua require('telescope.builtin').planets{}<cr>")

-- Global LSP
nmap("<space>e", "<cmd>lua vim.diagnostic.open_float()<cr>")
nmap("[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
nmap("]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
nmap("<space>q", "<cmd>lua vim.diagnostic.setloclist()<cr>")
