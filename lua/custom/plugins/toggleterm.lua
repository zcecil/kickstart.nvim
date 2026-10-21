vim.pack.add {
  { src = 'https://github.com/akinsho/toggleterm.nvim', version = vim.version.range '*' },
}

require('toggleterm').setup {
  open_mapping = [[<c-\>]],
  -- horizontal 視窗高度 = 螢幕高度的 50%
  size = function(term)
    if term.direction == 'horizontal' then return math.floor(vim.o.lines * 0.5) end
  end,
  -- 每次開啟都套用上面的 size
  persist_size = false,
}

local Terminal = require('toggleterm.terminal').Terminal

-- lazygit：float
local lazygit = Terminal:new {
  cmd = 'lazygit',
  dir = 'git_dir',
  direction = 'float',
  hidden = true,
  float_opts = {
    border = 'rounded',
    width = function() return math.floor(vim.o.columns * 0.9) end,
    height = function() return math.floor(vim.o.lines * 0.9) end,
  },
  on_open = function() vim.cmd 'startinsert!' end,
}

-- claude CLI：horizontal，下方 50%
local claude = Terminal:new {
  cmd = 'claude',
  dir = 'git_dir',
  direction = 'horizontal',
  hidden = true,
  on_open = function(term)
    vim.cmd 'startinsert!'
    -- 在 claude 視窗內收起視窗
    vim.keymap.set('t', '<M-c>', function() term:toggle() end, { buffer = term.bufnr, desc = 'Hide Claude' })
  end,
}

vim.keymap.set('n', '<leader>gg', function() lazygit:toggle() end, { desc = 'Lazy[g]it (float)' })
vim.keymap.set('n', '<leader>ac', function() claude:toggle() end, { desc = '[A]I [C]laude (bottom 50%)' })
