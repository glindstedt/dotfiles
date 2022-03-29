local wk = require("which-key")

local function map(mode, shortcut, command, opts_override, bufnr)
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

local function nmap(shortcut, command, opts)
  map("n", shortcut, command, opts)
end

local function nmap_buf(bufnr, shortcut, command, opts)
  map("n", shortcut, command, opts, bufnr)
end

wk.register({
  ["<leader>"] = {
    m = {
      "<cmd>nohlsearch<cr>",
      "Hide search highlighting",
    },
    w = {
      "<cmd>set nolist!<cr>",
      "Toggle trailing whitespace",
    },
    p = {
      name = "Packer",
      u = { "<cmd>PackerUpdate<cr>", "Clean, then update and install plugins." },
      s = { "<cmd>PackerSync<cr>", "Perform `PackerUpdate` and then `PackerCompile`." },
      c = { "<cmd>PackerClean<cr>", "Remove any disabled or unused plugins." },
    },
    f = {
      name = "Telescope",
      f = { "<cmd>Telescope find_files<cr>", "Find files" },
      r = { "<cmd>Telescope oldfiles<cr>", "Find recent files" },
      g = { "<cmd>Telescope live_grep<cr>", "Grep in files" },
      b = { "<cmd>Telescope buffers<cr>", "Find buffers" },
      h = { "<cmd>Telescope help_tags<cr>", "Find help tags" },
      p = { "<cmd>lua require('telescope.builtin').planets{}<cr>", "Find planets" },
      n = { "<cmd>Telescope notify<cr>", "Find notifications" },
    },
    n = { "<cmd>NvimTreeFindFileToggle<cr>", "Toggle nvim-tree" },
  },
  ["<space>"] = {
    e = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Open diagnoztics float" },
    q = { "<cmd>TroubleToggle document_diagnostics<cr>", "Open diagnostics in trouble" },
  },
  ["["] = {
    d = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Go to previous diagnostic" },
  },
  ["]"] = {
    d = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Go to next diagnostic" },
  },
})

-- Window Control
nmap("<A-->", "<C-w>-")
nmap("<A-+>", "<C-w>+")
nmap("<A-<>", "<C-w><")
nmap("<A->>", "<C-w>>")
nmap("<A-=>", "<C-w>=")
