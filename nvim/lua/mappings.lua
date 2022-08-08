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
      s = { "<cmd>Telescope luasnip<cr>", "Find snippets" },
      c = { "<cmd>Telescope colorscheme<cr>", "Switch colorscheme" },
      m = { "<cmd>Telescope man_pages<cr>", "Find man pages" },
      t = { "<cmd>Telescope builtin<cr>", "Find builtin pickers" },
    },
    n = { "<cmd>NvimTreeFindFileToggle<cr>", "Toggle nvim-tree" },
    d = {
      name = "Debug",
      d = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle debug UI" },
      b = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", "Toggle breakpoint" },
      c = { "<cmd>lua require('dap').continue()<cr>", "Continue" },
      o = { "<cmd>lua require('dap').step_over()<cr>", "Step Over" },
      i = { "<cmd>lua require('dap').step_into()<cr>", "Step Into" },
      u = { "<cmd>lua require('dap').step_out()<cr>", "Step Out" },
      r = { "<cmd>lua require('dap').repl.open()<cr>", "Open Repl" },
      l = { "<cmd>lua require('dap').run_last()<cr>", "Run Last" },
    },
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
  g = {
    c = {
      name = "Comment line",
      c = { "Toggle current line" },
      o = { "Start comment below" },
      O = { "Start comment above" },
      A = { "Append comment" },
    },
    b = {
      name = "Comment block",
      c = { "Toggle current line" },
    },
  },
})

wk.register({
  g = {
    ["c"] = { "Comment lines" },
    ["b"] = { "Comment block" },
    [">"] = { "Comment" },
    ["<"] = { "Uncomment" }, -- TODO this label doesn't work for some reason
  },
}, { mode = "x" })

-- barbar
nmap("<A-,>", "<cmd>BufferPrevious<cr>")
nmap("<A-.>", "<cmd>BufferNext<cr>")
nmap("<A-<>", "<cmd>BufferMovePrevious<cr>")
nmap("<A->>", "<cmd>BufferMoveNext<cr>")
nmap("<A-1>", "<cmd>BufferGoto 1<cr>")
nmap("<A-2>", "<cmd>BufferGoto 2<cr>")
nmap("<A-3>", "<cmd>BufferGoto 3<cr>")
nmap("<A-4>", "<cmd>BufferGoto 4<cr>")
nmap("<A-5>", "<cmd>BufferGoto 5<cr>")
nmap("<A-6>", "<cmd>BufferGoto 6<cr>")
nmap("<A-7>", "<cmd>BufferGoto 7<cr>")
nmap("<A-8>", "<cmd>BufferGoto 8<cr>")
nmap("<A-9>", "<cmd>BufferLast<cr>")
nmap("<A-c>", "<cmd>BufferClose<cr>")

-- Window Control
nmap("<A-->", "<C-w>-")
nmap("<A-+>", "<C-w>+")
nmap("<A-<>", "<C-w><")
nmap("<A->>", "<C-w>>")
nmap("<A-=>", "<C-w>=")
