# Emacs Setup Guide - From VS Code to Emacs

## Step 1: Install the Configuration

1. **Copy the init.el file to your home directory:**
   ```bash
   cp init.el ~/.emacs.d/init.el
   ```

2. **Start Emacs:**
   ```bash
   emacs
   ```

3. **Wait for packages to install (IMPORTANT!):**
   - The first time you start Emacs, it will download and install all packages
   - This takes 2-5 minutes depending on your internet speed
   - You'll see messages at the bottom like "Contacting host: melpa.org..."
   - **DO NOT close Emacs** until you see "Emacs configuration loaded successfully!"

4. **Restart Emacs** after the initial setup completes

---

## Step 2: Install LSP Servers (Language Support)

For languages to work properly, you need to install Language Server Protocol (LSP) servers.

### **JavaScript/TypeScript:**
```bash
npm install -g typescript typescript-language-server
```

### **Go:**
```bash
go install golang.org/x/tools/gopls@latest
```

### **C++:**
```bash
sudo apt install clangd
```

### **Tailwind CSS (optional but recommended):**
```bash
npm install -g @tailwindcss/language-server
```

### **HTML/CSS (optional, usually included):**
```bash
npm install -g vscode-langservers-extracted
```

---

## Step 3: Install Tree-sitter Grammars

When you first open a JavaScript/TypeScript/Go/C++ file, Emacs will ask:

```
Language grammar for typescript is missing. Install it from https://github.com/tree-sitter/tree-sitter-typescript? (y or n)
```

**Press `y`** for each language you want to use.

Or install them all manually:

1. Open Emacs
2. Press `M-x` (Alt+x)
3. Type: `treesit-install-language-grammar`
4. Press Enter
5. Type the language name: `typescript`, `tsx`, `javascript`, `go`, `cpp`, `css`, `html`
6. Press Enter
7. Repeat for each language

---

## Step 4: Basic Usage

### **Opening Files:**
- `C-x C-f` - Open file (Ctrl+x then Ctrl+f)
- Type the path and press Enter
- Or use `C-x C-r` to open recent files

### **File Explorer (like VS Code's sidebar):**
- Press `F8` to toggle the file tree (NeoTree)
- In the tree:
  - `n` - next line
  - `p` - previous line
  - `Enter` - open file
  - `g` - refresh
  - `A` - maximize/minimize tree
  - `q` - close tree

### **Finding Files (like Ctrl+P in VS Code):**
- `C-x b` - Switch between open files (buffers)
- `C-x p f` - Find files in project (if using Projectile)

### **Search:**
- `C-s` - Search in current file (like Ctrl+F in VS Code)
- Type your search term
- Press `C-s` again to go to next match
- Press `Enter` when done

### **Search and Replace:**
- `M-%` (Alt+Shift+5) - Query replace
- Type what to search for
- Type what to replace with
- Press `y` to replace, `n` to skip, `!` to replace all

### **Saving and Quitting:**
- `C-x C-s` - Save file
- `C-x C-c` - Quit Emacs
- `C-x k` - Close current file (buffer)

### **Git (Magit - THE KILLER FEATURE):**
- `C-x g` - Open Git status
- In Magit buffer:
  - `s` - Stage file under cursor
  - `u` - Unstage file
  - `c c` - Commit (type message, then `C-c C-c` to confirm)
  - `P p` - Push
  - `F p` - Pull
  - `l l` - View log
  - `q` - Close Magit

### **Code Navigation (with LSP):**
- `M-.` - Go to definition (Alt+.)
- `M-,` - Go back
- `C-c l r` - Rename symbol
- `C-c l a` - Code actions
- Hover over something - documentation shows automatically

### **Multiple Cursors (like in VS Code):**
- Select text
- `C->` - Add cursor at next match (Ctrl+Shift+.)
- `C-<` - Add cursor at previous match
- `C-c C-<` - Add cursor at all matches
- Type to edit all at once
- Press `C-g` to exit multi-cursor mode

### **Comment/Uncomment:**
- Select lines (or just put cursor on line)
- `C-/` - Toggle comment

### **Duplicate Line:**
- `C-d` - Duplicate current line (like Ctrl+D in VS Code)

### **Move Lines:**
- `M-<up>` - Move line up (Alt+Up)
- `M-<down>` - Move line down (Alt+Down)

---

## Step 5: Common Emacs Keybindings You Need to Know

### **Basic Navigation:**
- `C-f` - Forward one character
- `C-b` - Backward one character
- `C-n` - Next line
- `C-p` - Previous line
- `C-a` - Beginning of line
- `C-e` - End of line
- `M-f` - Forward one word
- `M-b` - Backward one word

### **Editing:**
- `C-d` - Delete character
- `M-d` - Delete word
- `C-k` - Kill (cut) to end of line
- `C-y` - Yank (paste)
- `C-w` - Kill (cut) region
- `M-w` - Copy region
- `C-/` or `C-_` - Undo

### **Selection:**
- `C-Space` - Start selection (mark)
- Move cursor to extend selection
- `C-x h` - Select all

### **Windows (split panes):**
- `C-x 2` - Split horizontally
- `C-x 3` - Split vertically
- `C-x 1` - Close all other windows
- `C-x 0` - Close current window
- `C-x o` - Switch to other window

---

## Step 6: Customization

Your config file is at: `~/.emacs.d/init.el`

To edit it:
```bash
emacs ~/.emacs.d/init.el
```

After making changes:
1. Save the file (`C-x C-s`)
2. Restart Emacs OR reload config: `M-x eval-buffer`

### **Change Theme:**

Find the line:
```elisp
(load-theme 'doom-one t)
```

Replace `doom-one` with:
- `doom-dracula`
- `doom-molokai`
- `doom-nord`
- `doom-solarized-dark`
- `doom-tomorrow-night`

### **Add More Languages:**

To add support for Python, Rust, or other languages:

1. Add the mode package (in the LANGUAGE-SPECIFIC CONFIGURATIONS section):
```elisp
(use-package python-mode
  :mode "\\.py\\'"
  :hook (python-mode . lsp-deferred))
```

2. Add LSP hook if needed (in the LSP section):
```elisp
(python-ts-mode . lsp-deferred)
```

3. Install the LSP server for that language
4. Install tree-sitter grammar: `M-x treesit-install-language-grammar RET python`

---

## Step 7: Package Management

### **Install New Packages:**
```
M-x package-install RET package-name RET
```

Or add to your init.el:
```elisp
(use-package package-name
  :config
  (your-config-here))
```

### **Update Packages:**
```
M-x package-refresh-contents
M-x package-list-packages
```
Press `U` to mark all upgradeable packages, then `x` to execute.

### **Remove Packages:**
```
M-x package-delete RET package-name RET
```

Or remove the `(use-package ...)` block from init.el and restart.

---

## Step 8: Troubleshooting

### **"Symbol's value as variable is void: X"**
- Restart Emacs
- Make sure all packages installed properly
- Try `M-x package-refresh-contents` then `M-x package-install-selected-packages`

### **LSP not working:**
- Make sure you installed the LSP server (see Step 2)
- Check if it's in your PATH: `which typescript-language-server`
- Try `M-x lsp-doctor` to diagnose issues

### **Tree-sitter not highlighting:**
- Make sure grammars are installed: `M-x treesit-install-language-grammar`
- Check if tree-sitter is available: `M-x treesit-available-p` (should return "t")

### **Emacs feels slow:**
- First startup is always slow (packages installing)
- Subsequent startups should be 2-3 seconds
- If still slow, try `M-x emacs-init-time` to see what's taking time

---

## Step 9: Learn More

### **Interactive Tutorial:**
```
M-x help-with-tutorial
```

### **Get Help:**
- `C-h k` - Describe key (what does this key do?)
- `C-h f` - Describe function
- `C-h v` - Describe variable
- `C-h m` - Describe current mode
- `C-h ?` - Help about help

### **Useful Resources:**
- Emacs Wiki: https://www.emacswiki.org/
- Emacs StackExchange: https://emacs.stackexchange.com/
- r/emacs: https://reddit.com/r/emacs

---

## Quick Reference Card

```
NOTATION:
C-x     = Ctrl+x
M-x     = Alt+x (or Esc then x)
C-x C-f = Ctrl+x then Ctrl+f

FILES:
C-x C-f     Open file
C-x C-s     Save file
C-x C-w     Save as
C-x C-c     Quit
F8          Toggle file tree

NAVIGATION:
C-s         Search (consult-line)
C-x b       Switch buffer
C-a / C-e   Start/End of line
M-< / M->   Start/End of file

EDITING:
C-/         Comment/uncomment
C-d         Duplicate line
M-↑ / M-↓   Move line up/down
C-> / C-<   Multiple cursors

GIT:
C-x g       Magit status

LSP:
M-.         Go to definition
C-c l r     Rename
C-c l a     Code actions

WINDOWS:
C-x 2       Split horizontal
C-x 3       Split vertical
C-x o       Switch window
C-x 1       Close others
```

---

## You're Ready!

Open a JavaScript file and start coding. Emacs will prompt you to install tree-sitter grammars and LSP will activate automatically.

Welcome to Emacs! 🎉
