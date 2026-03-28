#!/bin/bash

set -e  # Exit on error

echo "========================================="
echo "Installing Neovim with LazyVim"
echo "Complete VS Code-like setup"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================
# STEP 1: Install Neovim
# ============================================
echo -e "${BLUE}Step 1: Installing Neovim...${NC}"

if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version | head -n1)
    echo "Neovim already installed: $NVIM_VERSION"
else
    echo "Installing Neovim via snap..."
    sudo snap install nvim --classic
    echo -e "${GREEN}✓ Neovim installed${NC}"
fi

# ============================================
# STEP 2: Install Dependencies
# ============================================
echo ""
echo -e "${BLUE}Step 2: Installing dependencies...${NC}"

# Update package list
sudo apt update

# Install build tools
sudo apt install -y build-essential git curl wget unzip

# Install ripgrep (for fast searching)
sudo apt install -y ripgrep

# Install fd (for fast file finding)
sudo apt install -y fd-find
if [ -f /usr/bin/fdfind ] && [ ! -f /usr/local/bin/fd ]; then
    sudo ln -s /usr/bin/fdfind /usr/local/bin/fd
fi

# Install tree-sitter CLI (optional but useful)
sudo npm install -g tree-sitter-cli || echo "Warning: tree-sitter-cli failed to install"

echo -e "${GREEN}✓ Dependencies installed${NC}"

# ============================================
# STEP 3: Install Language Servers
# ============================================
echo ""
echo -e "${BLUE}Step 3: Installing Language Servers (LSP)...${NC}"

# TypeScript/JavaScript
echo "Installing TypeScript Language Server..."
sudo npm install -g typescript typescript-language-server
echo -e "${GREEN}✓ TypeScript/JavaScript LSP installed${NC}"

# HTML/CSS/JSON
echo "Installing HTML/CSS/JSON Language Servers..."
sudo npm install -g vscode-langservers-extracted
echo -e "${GREEN}✓ HTML/CSS/JSON LSP installed${NC}"

# Tailwind CSS
echo "Installing Tailwind CSS Language Server..."
sudo npm install -g @tailwindcss/language-server
echo -e "${GREEN}✓ Tailwind LSP installed${NC}"

# Go
if command -v go &> /dev/null; then
    echo "Installing Go Language Server..."
    go install golang.org/x/tools/gopls@latest
    echo -e "${GREEN}✓ Go LSP installed${NC}"
else
    echo -e "${YELLOW}⚠ Go not found, skipping gopls installation${NC}"
fi

# C++
echo "Installing C++ Language Server..."
sudo apt install -y clangd
echo -e "${GREEN}✓ C++ LSP installed${NC}"

# ============================================
# STEP 4: Backup Existing Config
# ============================================
echo ""
echo -e "${BLUE}Step 4: Backing up existing Neovim config...${NC}"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

if [ -d "$HOME/.config/nvim" ]; then
    echo "Backing up existing config..."
    mv ~/.config/nvim ~/.config/nvim.backup.$TIMESTAMP
    echo -e "${GREEN}✓ Backup created: ~/.config/nvim.backup.$TIMESTAMP${NC}"
fi

if [ -d "$HOME/.local/share/nvim" ]; then
    mv ~/.local/share/nvim ~/.local/share/nvim.backup.$TIMESTAMP
fi

if [ -d "$HOME/.local/state/nvim" ]; then
    mv ~/.local/state/nvim ~/.local/state/nvim.backup.$TIMESTAMP
fi

if [ -d "$HOME/.cache/nvim" ]; then
    mv ~/.cache/nvim ~/.cache/nvim.backup.$TIMESTAMP
fi

# ============================================
# STEP 5: Install LazyVim
# ============================================
echo ""
echo -e "${BLUE}Step 5: Installing LazyVim starter...${NC}"

# Clone LazyVim starter
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

echo -e "${GREEN}✓ LazyVim starter installed${NC}"

# ============================================
# STEP 6: Create Custom Configuration
# ============================================
echo ""
echo -e "${BLUE}Step 6: Creating custom configuration...${NC}"

# Create custom config directory
mkdir -p ~/.config/nvim/lua/config
mkdir -p ~/.config/nvim/lua/plugins

# Create options.lua (settings)
cat > ~/.config/nvim/lua/config/options.lua << 'EOF'
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Line numbers
opt.relativenumber = true  -- Relative line numbers
opt.number = true          -- Show current line number

-- Tabs and indentation
opt.tabstop = 2            -- 2 spaces for tabs
opt.shiftwidth = 2         -- 2 spaces for indent width
opt.expandtab = true       -- Expand tab to spaces
opt.autoindent = true      -- Copy indent from current line

-- Line wrapping
opt.wrap = false           -- Disable line wrapping

-- Search settings
opt.ignorecase = true      -- Ignore case when searching
opt.smartcase = true       -- If you include mixed case, assumes case-sensitive

-- Cursor line
opt.cursorline = true      -- Highlight current line

-- Appearance
opt.termguicolors = true   -- True color support
opt.signcolumn = "yes"     -- Always show sign column

-- Backspace
opt.backspace = "indent,eol,start"  -- Allow backspace on indent, end of line, insert mode start

-- Clipboard
opt.clipboard:append("unnamedplus")  -- Use system clipboard

-- Split windows
opt.splitright = true      -- Split vertical window to the right
opt.splitbelow = true      -- Split horizontal window to the bottom

-- Scrolling
opt.scrolloff = 8          -- Min number of lines to keep above/below cursor
opt.sidescrolloff = 8      -- Min number of columns to keep left/right of cursor
EOF

# Create keymaps.lua (keybindings)
cat > ~/.config/nvim/lua/config/keymaps.lua << 'EOF'
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- ============================================
-- GENERAL KEYMAPS (VS Code-like)
-- ============================================

-- Clear search highlights
keymap.set("n", "<Esc>", ":noh<CR>", opts)

-- Save file
keymap.set("n", "<C-s>", ":w<CR>", opts)
keymap.set("i", "<C-s>", "<Esc>:w<CR>a", opts)

-- Quit
keymap.set("n", "<C-q>", ":q<CR>", opts)

-- Select all
keymap.set("n", "<C-a>", "ggVG", opts)

-- ============================================
-- WINDOW MANAGEMENT (Like VS Code splits)
-- ============================================

-- Split windows
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equal split size" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

-- Navigate between splits
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Resize splits
keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- ============================================
-- BUFFER MANAGEMENT (Like VS Code tabs)
-- ============================================

-- Navigate buffers
keymap.set("n", "<Tab>", ":bnext<CR>", opts)
keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
keymap.set("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })

-- ============================================
-- MOVE LINES (Like Alt+Up/Down in VS Code)
-- ============================================

-- Move lines up and down in normal mode
keymap.set("n", "<A-j>", ":m .+1<CR>==", opts)
keymap.set("n", "<A-k>", ":m .-2<CR>==", opts)

-- Move lines up and down in visual mode
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- ============================================
-- BETTER INDENTING
-- ============================================

-- Stay in indent mode
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- ============================================
-- COMMENTS (Like Ctrl+/ in VS Code)
-- ============================================

-- This is handled by Comment.nvim plugin
-- gcc - toggle comment on current line
-- gc in visual mode - toggle comment on selection

-- ============================================
-- TERMINAL (Like Ctrl+` in VS Code)
-- ============================================

-- Open terminal
keymap.set("n", "<C-`>", ":ToggleTerm<CR>", { desc = "Toggle terminal" })
keymap.set("t", "<C-`>", "<C-\\><C-n>:ToggleTerm<CR>", { desc = "Toggle terminal" })

-- Exit terminal mode
keymap.set("t", "<Esc>", "<C-\\><C-n>", opts)
EOF

# Create custom plugins configuration
cat > ~/.config/nvim/lua/plugins/custom.lua << 'EOF'
return {
  -- ============================================
  -- FILE EXPLORER (Like VS Code Explorer)
  -- ============================================
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        width = 30,
      },
    },
  },

  -- ============================================
  -- TERMINAL (Like VS Code Terminal)
  -- ============================================
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 20,
      open_mapping = [[<C-`>]],
      hide_numbers = true,
      shade_terminals = true,
      start_in_insert = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
    },
  },

  -- ============================================
  -- AUTO-COMPLETION (Like VS Code IntelliSense)
  -- ============================================
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      })
      opts.completion = {
        completeopt = "menu,menuone,noinsert",
      }
      opts.experimental = {
        ghost_text = true,  -- Show ghost text like VS Code
      }
    end,
  },

  -- ============================================
  -- AUTO-PAIRS (Auto close brackets)
  -- ============================================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- ============================================
  -- GIT INTEGRATION (Like VS Code Git)
  -- ============================================
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,  -- Show git blame on current line
      current_line_blame_opts = {
        delay = 300,
      },
    },
  },

  -- ============================================
  -- INDENT GUIDES (Like VS Code indent lines)
  -- ============================================
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
    },
  },

  -- ============================================
  -- COLORSCHEME (VS Code-like theme)
  -- ============================================
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",  -- storm, moon, night, day
      transparent = true,  -- No background (use terminal colors)
    },
  },

  -- ============================================
  -- LSP CONFIGURATION (Auto-import support)
  -- ============================================
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
              },
            },
          },
        },
        tailwindcss = {},
        gopls = {},
        clangd = {},
      },
      setup = {
        tsserver = function(_, opts)
          -- Enable auto-import
          opts.init_options = {
            preferences = {
              includeCompletionsForModuleExports = true,
              includeCompletionsWithInsertText = true,
            },
          }
        end,
      },
    },
  },

  -- ============================================
  -- FORMATTING (Format on save like VS Code)
  -- ============================================
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        go = { "gofmt", "goimports" },
        cpp = { "clang-format" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  -- ============================================
  -- LINTING (Like VS Code linting)
  -- ============================================
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      },
    },
  },
}
EOF

# Create lazyvim.json to enable extras
cat > ~/.config/nvim/lazyvim.json << 'EOF'
{
  "extras": [
    "lazyvim.plugins.extras.lang.typescript",
    "lazyvim.plugins.extras.lang.go",
    "lazyvim.plugins.extras.formatting.prettier",
    "lazyvim.plugins.extras.linting.eslint",
    "lazyvim.plugins.extras.editor.illuminate"
  ],
  "news": {
    "lazyvim.org": {}
  },
  "version": 6
}
EOF

echo -e "${GREEN}✓ Custom configuration created${NC}"

# ============================================
# STEP 7: Install Formatters and Linters
# ============================================
echo ""
echo -e "${BLUE}Step 7: Installing formatters and linters...${NC}"

# Prettier (formatting)
echo "Installing Prettier..."
sudo npm install -g prettier
echo -e "${GREEN}✓ Prettier installed${NC}"

# ESLint (linting)
echo "Installing ESLint..."
sudo npm install -g eslint_d
sudo apt install fzf
echo -e "${GREEN}✓ ESLint installed${NC}"

# ============================================
# STEP 8: Create Quick Reference
# ============================================
echo ""
echo -e "${BLUE}Step 8: Creating quick reference guide...${NC}"

cat > ~/nvim_quickstart.md << 'EOF'
# Neovim Quick Start Guide

## Starting Neovim

```bash
nvim                    # Start Neovim
nvim file.txt          # Open file
nvim .                 # Open in current directory
```

## Basic Vim Motions (Essential!)

### Navigation:
- `h` `j` `k` `l` - Left, Down, Up, Right
- `w` - Next word
- `b` - Previous word
- `0` - Start of line
- `$` - End of line
- `gg` - Start of file
- `G` - End of file
- `{` `}` - Previous/Next paragraph

### Modes:
- `i` - Insert mode (before cursor)
- `a` - Insert mode (after cursor)
- `o` - Insert new line below
- `O` - Insert new line above
- `ESC` or `Ctrl+[` - Back to normal mode
- `v` - Visual mode (select)
- `V` - Visual line mode

### Editing:
- `d` - Delete (use with motion, e.g., `dw` delete word)
- `dd` - Delete line
- `c` - Change (delete and enter insert mode)
- `cc` - Change line
- `y` - Yank (copy)
- `yy` - Yank line
- `p` - Paste
- `u` - Undo
- `Ctrl+r` - Redo

## VS Code-like Keybindings

### File Operations:
- `Space` `f` `f` - Find files (fuzzy search)
- `Space` `f` `r` - Recent files
- `Space` `f` `g` - Find in files (grep)
- `Ctrl+s` - Save file
- `Ctrl+q` - Quit

### Navigation:
- `Ctrl+p` - Find files (alternative)
- `Space` `/` - Search in current file
- `Space` `e` - Toggle file explorer
- `Tab` - Next buffer
- `Shift+Tab` - Previous buffer
- `Space` `x` - Close buffer

### Code:
- `g` `d` - Go to definition
- `g` `r` - Go to references
- `K` - Hover documentation
- `Space` `c` `a` - Code actions
- `Space` `c` `r` - Rename symbol
- `Space` `c` `f` - Format document
- `gcc` - Comment/uncomment line
- `gc` (in visual) - Comment selection

### Splits:
- `Space` `s` `v` - Split vertically
- `Space` `s` `h` - Split horizontally
- `Ctrl+h/j/k/l` - Navigate splits
- `Space` `s` `x` - Close split

### Terminal:
- `Ctrl+\`` - Toggle terminal
- `ESC` (in terminal) - Exit terminal mode

### Move Lines:
- `Alt+j` - Move line down
- `Alt+k` - Move line up

### LSP (Diagnostics):
- `]d` - Next diagnostic
- `[d` - Previous diagnostic
- `Space` `x` `x` - Show diagnostics

## LazyVim Features

### Plugin Manager:
- `:Lazy` - Open plugin manager
- `:Lazy sync` - Update plugins
- `:Lazy clean` - Remove unused plugins

### Mason (LSP/Tool Manager):
- `:Mason` - Open tool manager
- Search and install LSP servers, formatters, linters

### Git:
- `Space` `g` `g` - Open Lazygit
- `Space` `g` `b` - Git blame line
- `]h` / `[h` - Next/Previous hunk

### Telescope (Fuzzy Finder):
- `Space` `Space` - Find files
- `Space` `/` - Search in file
- `Space` `f` `g` - Find text in files

## First Time Setup

1. **Start Neovim:** `nvim`
2. **Wait for plugins to install** (2-5 minutes)
3. **Install language grammars:** `:TSUpdate`
4. **Check health:** `:checkhealth`
5. **Install missing tools:** `:Mason`

## Tips

1. **Learn Vim motions gradually** - Start with `h` `j` `k` `l`, add more as you go
2. **Use `Space`** - It's your main key, press it and see what's available
3. **Use `:checkhealth`** - Diagnose problems
4. **Read `:help`** - Built-in documentation is excellent
5. **Practice!** - Run `vimtutor` in terminal to learn Vim basics

## Common Issues

### "Language server not found"
→ Open `:Mason` and install the server

### "Treesitter parser not found"
→ Run `:TSInstall <language>`

### "Can't save file"
→ Make sure you're in normal mode (press `ESC`), then `:w`

## Resources

- LazyVim Docs: https://www.lazyvim.org/
- Vim Cheatsheet: https://vim.rtorr.com/
- Interactive Tutorial: Run `vimtutor` in terminal
EOF

echo -e "${GREEN}✓ Quick reference created: ~/nvim_quickstart.md${NC}"

# ============================================
# DONE!
# ============================================
echo ""
echo "========================================="
echo -e "${GREEN}Installation Complete!${NC}"
echo "========================================="
echo ""
echo "📝 What was installed:"
echo "  - Neovim (latest version)"
echo "  - LazyVim (Neovim distribution)"
echo "  - LSP servers: TypeScript, Go, C++, HTML/CSS"
echo "  - Formatters: Prettier, gofmt"
echo "  - Linters: ESLint"
echo "  - All necessary dependencies"
echo ""
echo "🚀 To start:"
echo "  1. Run: nvim"
echo "  2. Wait for plugins to install (2-5 minutes)"
echo "  3. Read ~/nvim_quickstart.md for keybindings"
echo ""
echo "📚 Quick reference:"
echo "  - cat ~/nvim_quickstart.md"
echo "  - Or open it: nvim ~/nvim_quickstart.md"
echo ""
echo "💡 First time tips:"
echo "  - Press 'Space' to see available commands"
echo "  - Press 'Space e' to open file explorer"
echo "  - Press 'Ctrl+\`' to open terminal"
echo "  - Run ':checkhealth' to diagnose issues"
echo "  - Run ':Mason' to manage LSP servers"
echo ""
echo "🎓 Learn Vim motions:"
echo "  - Run 'vimtutor' in terminal"
echo "  - Practice h/j/k/l for navigation"
echo ""
echo "Enjoy Neovim! 🎉"
