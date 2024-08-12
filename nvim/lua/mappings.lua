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
wk.add({
  { "<leader>d", group = "Debug" },
  { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle breakpoint" },
  { "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "Continue" },
  { "<leader>dd", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle debug UI" },
  { "<leader>di", "<cmd>lua require('dap').step_into()<cr>", desc = "Step Into" },
  { "<leader>dl", "<cmd>lua require('dap').run_last()<cr>", desc = "Run Last" },
  { "<leader>do", "<cmd>lua require('dap').step_over()<cr>", desc = "Step Over" },
  { "<leader>dr", "<cmd>lua require('dap').repl.open()<cr>", desc = "Open Repl" },
  { "<leader>du", "<cmd>lua require('dap').step_out()<cr>", desc = "Step Out" },
  { "<leader>e", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Open diagnoztics float" },
  { "<leader>f", group = "Telescope" },
  { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
  { "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Switch colorscheme" },
  { "<leader>fe", "<cmd>Telescope egrepify<cr>", desc = "egrep in files" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep in files" },
  { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help tags" },
  { "<leader>fm", "<cmd>Telescope man_pages<cr>", desc = "Find man pages" },
  { "<leader>fn", "<cmd>Telescope notify<cr>", desc = "Find notifications" },
  { "<leader>fp", "<cmd>lua require('telescope.builtin').planets{}<cr>", desc = "Find planets" },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Find recent files" },
  { "<leader>fs", "<cmd>Telescope luasnip<cr>", desc = "Find snippets" },
  { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
  { "<leader>fw", "<cmd>Telescope workspaces<cr>", desc = "Find workspaces" },
  { "<leader>n", group = "Neotree/Neorg" },
  { "<leader>nb", "<cmd>Neotree buffers reveal float<cr>", desc = "Open buffers neotree" },
  { "<leader>nf", "<cmd>Neotree filesystem reveal<cr>", desc = "Open filesystem neotree" },
  { "<leader>ng", "<cmd>Neotree git_status reveal float<cr>", desc = "Open git status neotree" },
  { "<leader>ni", "<cmd>Neorg index<cr>", desc = "Neorg index" },
  { "<leader>nr", "<cmd>Neorg return<cr>", desc = "Neorg return" },
  { "<leader>o", group = "Overseer" },
  { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer Info" },
  { "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
  { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run Overseer Task" },
  { "<leader>t", group = "Neotest" },
  { "<leader>ta", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach to nearest test" },
  { "<leader>td", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug nearest test" },
  { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Run all tests" },
  { "<leader>to", "<cmd>lua require('neotest').output.open({enter = true})<cr>", desc = "Open output" },
  { "<leader>ts", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop nearest test" },
  { "<leader>tt", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test" },
  { "<localleader>\\", group = "vim-visual-multi" },
  { "<localleader>\\g", group = "reselect" },
  { "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Go to previous diagnostic" },
  { "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Go to next diagnostic" },
  { "gb", group = "Comment block" },
  { "gbc", desc = "Toggle current line" },
  { "gc", group = "Comment line" },
  { "gcA", desc = "Append comment" },
  { "gcO", desc = "Start comment above" },
  { "gcc", desc = "Toggle current line" },
  { "gco", desc = "Start comment below" },
})

-- Visual only mode
wk.add({
  mode = { "x" },
  { "gb", desc = "Comment block" },
  { "gc", desc = "Comment lines" },
})

-- AutoCommands
local whichKeyCustomID = vim.api.nvim_create_augroup("WhichKeyCustom", {})
-- Neorg
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = whichKeyCustomID,
  pattern = { "*.norg" },
  callback = function(_ev)
    require("which-key").register({
      ["<localleader>"] = {
        name = "+neorg",
        i = { name = "+insert" },
        m = { name = "+mode" },
        l = { name = "+list" },
        n = { name = "+note" },
        t = { name = "+task" },
      },
    }, { buffer = 0 })
  end,
})
