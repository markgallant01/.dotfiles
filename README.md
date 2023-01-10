Create the following symlinks: WARNING!: This will overwrite  
the files at the destination locations! Back up anything necessary.  
  
  ln -sf .bashrc ~/.bashrc  
  ln -sf .xinitrc ~/.xinitrc  
  ln -sf .Xresources ~/.Xresources  
  ln -sf picom.conf ~/.config/picom.conf  
  ln -sf .fehbg ~/.fehbg  
  ln -sf config.lua ~/.config/lvim/config.lua  
  
copy the file 00-input-devices.conf into this folder:  
  /etc/X11/xorg.conf.d/  
  
Create any of these locations if they do not already exist.  

