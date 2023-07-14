Create the following symlinks: WARNING!: This will overwrite  
the files at the destination locations! Back up anything necessary.  

These commands assume the '.dotfiles' folder is at ~/.dotfiles
  
  ln -sf ~/.dotfiles/.bashrc ~/.bashrc  
  ln -sf ~/.dotfiles/.xinitrc ~/.xinitrc  
  ln -sf ~/.dotfiles/picom.conf ~/.config/picom.conf  
  ln -sf ~/.dotfiles/.fehbg ~/.fehbg  
  ln -sf ~/.dotfiles/nvim/ ~/.config/nvim
  
copy the file 00-input-devices.conf into this folder:  
    /etc/X11/xorg.conf.d/  

copy the file nvidia.hook into this folder:
    /etc/pacman.d/hooks/
  
Create any of these locations if they do not already exist.  

