#!/bin/zsh

INSTALL_DIR="$HOME/.zsh-droid-toolkit"

if [ -d "$INSTALL_DIR" ]; then
    print "ZshDroid-RE is already installed. Updating..."
    cd "$INSTALL_DIR" && git pull
else
    print "Cloning ZshDroid-RE..."
    git clone https://github.com/giorgosioak/zsh-droid-toolkit.git "$INSTALL_DIR"
fi

# Add source line if it doesn't exist
if ! grep -q "zsh-droid.plugin.zsh" "$HOME/.zshrc"; then
    print "Adding source line to ~/.zshrc"
    echo "source $INSTALL_DIR/zsh-droid.plugin.zsh" >> "$HOME/.zshrc"
fi

print "Done! Please run 'exec zsh' to start using pm."