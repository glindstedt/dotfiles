require("neotest").setup({
  adapters = {
    require("neotest-go"),
    require("rustaceanvim.neotest"),
  },
  consumers = {
    overseer = require("neotest.consumers.overseer"),
  },
})
