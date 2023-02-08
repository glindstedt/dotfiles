local wk = require("which-key")

-- Base level bindings
-- barbar
vim.keymap.set("n", "<A-,>", vim.cmd.BufferPrevious)
vim.keymap.set("n", "<A-.>", vim.cmd.BufferNext)
vim.keymap.set("n", "<A-<>", vim.cmd.BufferMovePrevious)
vim.keymap.set("n", "<A->>", vim.cmd.BufferMoveNext)
vim.keymap.set("n", "<A-1>", "<cmd>BufferGoto 1<cr>")
vim.keymap.set("n", "<A-2>", "<cmd>BufferGoto 2<cr>")
vim.keymap.set("n", "<A-3>", "<cmd>BufferGoto 3<cr>")
vim.keymap.set("n", "<A-4>", "<cmd>BufferGoto 4<cr>")
vim.keymap.set("n", "<A-5>", "<cmd>BufferGoto 5<cr>")
vim.keymap.set("n", "<A-6>", "<cmd>BufferGoto 6<cr>")
vim.keymap.set("n", "<A-7>", "<cmd>BufferGoto 7<cr>")
vim.keymap.set("n", "<A-8>", "<cmd>BufferGoto 8<cr>")
vim.keymap.set("n", "<A-9>", vim.cmd.BufferLast)
vim.keymap.set("n", "<A-c>", vim.cmd.BufferClose)

-- Window Control
vim.keymap.set("n", "<A-->", "<C-w>-")
vim.keymap.set("n", "<A-+>", "<C-w>+")
vim.keymap.set("n", "<A-=>", "<C-w>=")

-- Move visual blocks of code magic
vim.keymap.set("x", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<cr>gv=gv")
-- Don't move cursor when justifying
vim.keymap.set("n", "J", "mzJ`z")

-- Normal mode
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
    n = {
      name = "Nvim-Tree",
      n = { "<cmd>NvimTreeFindFileToggle<cr>", "Toggle nvim-tree" },
      g = { "<cmd>NvimTreeFindFile<cr>", "Find file in nvim-tree" },
      c = { "<cmd>NvimTreeClose<cr>", "Close nvim-tree" },
    },
    o = {
      name = "Overseer",
      i = { "<cmd>OverseerInfo<cr>", "Overseer Info" },
      r = { "<cmd>OverseerRun<cr>", "Run Overseer Task" },
      o = { "<cmd>OverseerToggle<cr>", "Toggle Overseer" },
    },
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
    t = {
      name = "Neotest",
      a = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach to nearest test" },
      t = { "<cmd>lua require('neotest').run.run()<cr>", "Run nearest test" },
      d = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug nearest test" },
      s = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop nearest test" },
      f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Run all tests" },
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

-- Visual only mode
wk.register({
  g = {
    ["c"] = { "Comment lines" },
    ["b"] = { "Comment block" },
    [">"] = { "Comment" },
    ["<"] = { "Uncomment" }, -- TODO this label doesn't work for some reason
  },
}, { mode = "x" })
