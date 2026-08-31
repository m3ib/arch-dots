local wk = require("which-key")

local builtin = require("telescope.builtin")
local conform = require("conform")
local oil = require("oil")
local gitsigns = require("gitsigns")

wk.add({
  -- Util
  { "<ESC>", ":nohl<CR>" },
  { "<Esc><Esc>", "<C-\\><C-n>", mode = "t", desc = "Exit terminal mode" },
  -- Misc
  { "<leader>e", oil.toggle_float, desc = "Toggle Oil" },
  { "<leader>r", ":Neotree toggle<CR>", desc = "Toggle Neo-Tree" },
  { "<leader>l", ":Lazy<CR>", desc = "Lazy" },
  -- Quiting & Saving
  { "<leader>qq", ":qa!<CR>", desc = "Quit All (force)" },
  { "<leader>qu", ":suspend<CR>", desc = "Suspend" },
  { "<leader>qw", ":wqa<CR>", desc = "Quit All (saving)" },
  {
    "<leader>qs",
    ":wqa | mksession" .. vim.fn.expand("~/.nvim/") .. vim.fn.getcwd():match("([^/]+)$") .. ".vim" .. "<CR>",
    desc = "Write, quit & save session (saving)",
  },
  -- Telescope
  { "<leader>f", group = "Find" },
  { "<leader>p", builtin.find_files, desc = "Telescope Find File" },
  { "<leader>fb", builtin.buffers, desc = "Telescope Find Buffer" },
  { "<leader>f.", builtin.resume, desc = "Telescope Repeat search" },
  { "<leader>/", builtin.live_grep, desc = "Grep Files" },
  { "<leader>fk", builtin.keymaps, desc = "Telescope Find Keymap" },
  { "<leader>fh", builtin.help_tags, desc = "Telescope Find Help" },
  { "<leader>fc", builtin.colorscheme, desc = "Telescope Find Colorscheme" },
  { "<leader>ft", ":TodoTelescope<CR>", desc = "Telescope Find Todos" },
  -- Code
  { "<leader>c", group = "Code" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions" },
  { "<leader>cd", vim.diagnostic.open_float, desc = "Code Diagnostic" },
  {
    "<leader>cD",
    function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end,
    desc = "Code Diagnostic",
  },
  { "<leader>cl", vim.diagnostic.setloclist, desc = "Open Diagnostic List" },
  { "<leader>cf", conform.format, desc = "Code Format" },
  -- Buffers
  { "<leader>b", group = "Buffer" },
  { "<leader>bn", ":bnext<CR>", desc = "Buffer Next" },
  { "<leader>bp", ":bprevious<CR>", desc = "Buffer Previous" },
  { "<leader>bd", ":bd<CR>", desc = "Buffer Delete" },
  { "<leader>bo", ":buf #<CR>", desc = "Buffer Go to Other" },
  -- delete all buffers before and after this one
  {
    "<leader>bO",
    function()
      local current_buf = vim.api.nvim_get_current_buf()
      vim
        .iter(vim.api.nvim_list_bufs())
        :filter(function(buf)
          return vim.api.nvim_buf_is_loaded(buf) and buf ~= current_buf
        end)
        :each(function(buf)
          vim.api.nvim_buf_delete(buf, {})
        end)
    end,
    desc = "Buffer Close others",
  },
  { "<S-l>", ":bnext<CR>", desc = "Buffer Next" },
  { "<S-h>", ":bprevious<CR>", desc = "Buffer Previous" },
  { "]b", ":bnext<CR>", desc = "Buffer Next" },
  { "[b", ":previous<CR>", desc = "Buffer Previous" },
  -- Terminal
  { "<leader>t", group = "Terminal" },
  { "<leader>tt", ":terminal<CR>a", desc = "Open Terminal New Buffer" },
  -- Git
  { "<leader>g", group = "Git" },
  { "<leader>gs", ":Neotree float git_status<CR>", desc = "Git Status" },
  { "<leader>gS", builtin.git_stash, desc = "Git Stash" },
  { "<leader>gc", builtin.git_commits, desc = "Git Commits" },
  { "<leader>gl", gitsigns.blame_line, desc = "Git Blame line" },
  { "<leader>gL", gitsigns.blame, desc = "Git Blame file" },
  { "<leader>gbs", gitsigns.stage_buffer, desc = "Git Buffer Stage" },
  { "<leader>gbr", gitsigns.reset_buffer, desc = "Git Buffer Reset" },
  { "<leader>gbR", gitsigns.reset_buffer, desc = "Git Buffer Reset (index)" },
  { "<leader>ghp", gitsigns.preview_hunk_inline, desc = "Git Hunk preview under cursor" },
  { "<leader>ghs", gitsigns.stage_hunk, desc = "Git Hunk Stage" },
  { "<leader>ghr", gitsigns.reset_hunk, desc = "Git Hunk Reset" },
  {
    "]g",
    function()
      gitsigns.nav_hunk("next")
    end,
    desc = "Next Git Hunk",
  },
  {
    "[g",
    function()
      gitsigns.nav_hunk("prev")
    end,
    desc = "Previous Git Hunk",
  },
  {
    "]G",
    function()
      gitsigns.nav_hunk("last")
    end,
    desc = "Last Git Hunk",
  },
  {
    "[G",
    function()
      gitsigns.nav_hunk("first")
    end,
    desc = "First Git Hunk",
  },
  { "<leader>ghv", gitsigns.select_hunk, desc = "Git Select Hunk under cursor" },
  -- Window
  { "<leader>w", proxy = "<C-w>", desc = "Window" },
  { "<C-h>", "<C-w>h" },
  { "<C-j>", "<C-w>j" },
  { "<C-k>", "<C-w>k" },
  { "<C-l>", "<C-w>l" },
})
