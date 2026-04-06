#!/bin/bash

echo "========================================="
echo "Uninstalling LazyVim and Doom Emacs"
echo "========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================
# LAZYVIM UNINSTALLATION
# ============================================
echo -e "${YELLOW}Uninstalling LazyVim...${NC}"

if [ -d "$HOME/.config/nvim" ]; then
    echo "Removing LazyVim config directory..."
    rm -rf ~/.config/nvim
    echo -e "${GREEN}✓ Removed ~/.config/nvim${NC}"
else
    echo "LazyVim config not found (already removed)"
fi

if [ -d "$HOME/.local/share/nvim" ]; then
    echo "Removing Neovim data directory..."
    rm -rf ~/.local/share/nvim
    echo -e "${GREEN}✓ Removed ~/.local/share/nvim${NC}"
else
    echo "Neovim data directory not found"
fi

if [ -d "$HOME/.local/state/nvim" ]; then
    echo "Removing Neovim state directory..."
    rm -rf ~/.local/state/nvim
    echo -e "${GREEN}✓ Removed ~/.local/state/nvim${NC}"
else
    echo "Neovim state directory not found"
fi

if [ -d "$HOME/.cache/nvim" ]; then
    echo "Removing Neovim cache..."
    rm -rf ~/.cache/nvim
    echo -e "${GREEN}✓ Removed ~/.cache/nvim${NC}"
else
    echo "Neovim cache not found"
fi

echo ""
echo -e "${GREEN}LazyVim uninstalled!${NC}"
echo ""

# ============================================
# DOOM EMACS UNINSTALLATION
# ============================================
echo -e "${YELLOW}Uninstalling Doom Emacs...${NC}"

if [ -d "$HOME/.config/emacs" ]; then
    echo "Removing Doom Emacs installation..."
    rm -rf ~/.config/emacs
    echo -e "${GREEN}✓ Removed ~/.config/emacs${NC}"
else
    echo "Doom Emacs installation not found"
fi

if [ -d "$HOME/.config/doom" ]; then
    echo "Removing Doom config directory..."
    rm -rf ~/.config/doom
    echo -e "${GREEN}✓ Removed ~/.config/doom${NC}"
else
    echo "Doom config not found"
fi

if [ -d "$HOME/.emacs.d" ]; then
    echo "Removing old Emacs config (if exists)..."
    rm -rf ~/.emacs.d
    echo -e "${GREEN}✓ Removed ~/.emacs.d${NC}"
else
    echo "Old Emacs config not found"
fi

if [ -d "$HOME/.doom.d" ]; then
    echo "Removing old Doom config (if exists)..."
    rm -rf ~/.doom.d
    echo -e "${GREEN}✓ Removed ~/.doom.d${NC}"
else
    echo "Old Doom config not found"
fi

if [ -d "$HOME/.local/share/doom" ]; then
    echo "Removing Doom data directory..."
    rm -rf ~/.local/share/doom
    echo -e "${GREEN}✓ Removed ~/.local/share/doom${NC}"
else
    echo "Doom data directory not found"
fi

# Remove Doom from PATH in bashrc
if grep -q "/.config/emacs/bin" ~/.bashrc 2>/dev/null; then
    echo "Removing Doom from PATH in .bashrc..."
    sed -i '/\.config\/emacs\/bin/d' ~/.bashrc
    echo -e "${GREEN}✓ Removed from ~/.bashrc${NC}"
fi

# Remove Doom from PATH in zshrc
if [ -f ~/.zshrc ] && grep -q "/.config/emacs/bin" ~/.zshrc 2>/dev/null; then
    echo "Removing Doom from PATH in .zshrc..."
    sed -i '/\.config\/emacs\/bin/d' ~/.zshrc
    echo -e "${GREEN}✓ Removed from ~/.zshrc${NC}"
fi

echo ""
echo -e "${GREEN}Doom Emacs uninstalled!${NC}"
echo ""

# ============================================
# OPTIONAL: REMOVE BASE APPLICATIONS
# ============================================
echo "========================================="
echo -e "${YELLOW}Optional: Remove base applications${NC}"
echo "========================================="
echo ""
echo "The following were installed but are NOT removed by this script:"
echo "  - Neovim (nvim)"
echo "  - Emacs (emacs)"
echo "  - Node.js, npm, ripgrep, fd-find, etc."
echo "  - JetBrainsMono Nerd Font"
echo ""
echo "To remove Neovim:"
echo "  sudo rm /usr/local/bin/nvim"
echo ""
echo "To remove Emacs:"
echo "  sudo apt remove emacs-nox"
echo ""
echo "To remove development tools:"
echo "  sudo apt remove nodejs npm ripgrep fd-find python3-pip"
echo ""
echo "To remove the Nerd Font:"
echo "  rm -rf ~/.local/share/fonts/JetBrains*"
echo "  fc-cache -fv"
echo ""

# ============================================
# SHOW BACKUPS
# ============================================
echo "========================================="
echo "Backup Files"
echo "========================================="
echo ""

BACKUPS_FOUND=false

if ls ~/.config/nvim.backup.* 1> /dev/null 2>&1; then
    echo "LazyVim backups found:"
    ls -d ~/.config/nvim.backup.* 2>/dev/null
    BACKUPS_FOUND=true
fi

if ls ~/.emacs.d.backup.* 1> /dev/null 2>&1; then
    echo "Emacs backups found:"
    ls -d ~/.emacs.d.backup.* 2>/dev/null
    BACKUPS_FOUND=true
fi

if [ "$BACKUPS_FOUND" = false ]; then
    echo "No backup directories found."
else
    echo ""
    echo "To restore a backup, rename it back:"
    echo "  mv ~/.config/nvim.backup.YYYYMMDD_HHMMSS ~/.config/nvim"
    echo ""
    echo "To delete all backups:"
    echo "  rm -rf ~/.config/nvim.backup.*"
    echo "  rm -rf ~/.emacs.d.backup.*"
    echo "  rm -rf ~/.doom.d.backup.*"
    echo "  rm -rf ~/.local/share/nvim.backup.*"
fi

echo ""
echo "========================================="
echo -e "${GREEN}Uninstallation Complete!${NC}"
echo "========================================="
echo ""
echo "Reload your shell to update PATH:"
echo "  source ~/.bashrc  # or source ~/.zshrc"
echo ""
