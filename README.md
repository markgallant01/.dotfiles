Create the following symlinks: WARNING!: This will overwrite  
the files at the destination locations! Back up anything necessary.  

These commands assume the '.dotfiles' folder is at ~/.dotfiles
  
  ln -sf ~/.dotfiles/.bashrc ~/.bashrc  
  ln -sf ~/.dotfiles/.xinitrc ~/.xinitrc  
  ln -sf ~/.dotfiles/.Xresources ~/.Xresources  
  ln -sf ~/.dotfiles/picom.conf ~/.config/picom.conf  
  ln -sf ~/.dotfiles/.fehbg ~/.fehbg  
  ln -sf ~/.dotfiles/rc.lua ~/.config/awesome/rc.lua  
  ln -sf ~/.dotfiles/theme.lua ~/.config/awesome/theme.lua  
  ln -sf ~/.dotfiles/awesome-wm-widgets/ ~/.config/awesome/awesome-wm-widgets  
  ln -sf ~/.dotfiles/nvim/ ~/.config/nvim
  
copy the file 00-input-devices.conf into this folder:  
  /etc/X11/xorg.conf.d/  
  
Create any of these locations if they do not already exist.  

