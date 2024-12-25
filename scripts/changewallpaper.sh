# !/bin/bash
# _   _    __        __    _ 
#| | | |_ _\ \      / /_ _| |
#| | | | '_ \ \ /\ / / _` | |
#| |_| | |_) \ V  V / (_| | |
# \___/| .__/ \_/\_/ \__,_|_|
#      |_|        
#
#===========================================
# Select random wallpaper and create colorscheme
#===========================================
wal -q -i ~/gitrepos/wallpaper/

#===========================================
# Load current pywal colorscheme
#===========================================
source "$HOME/.cache/wal/colors.sh"

#===========================================
# Cope colorfile to waybar folder
#===========================================
cp ~/.cache/wal/colors-waybar.css ~/.config/waybar/

#===========================================
# Copy colored config to cava config
#===========================================
cp ~/.cache/wal/config ~/.config/cava

#===========================================
# Copy colored config to bpytop config
#===========================================
cp ~/.cache/wal/colors-bpytop.theme ~/.config/bpytop/themes/

#===========================================
# Get wallpaper image name
#===========================================
newwall=$(echo $wallpaper | sed "s|&HOME/gitrepos/wallpaper/||g")

#===========================================
# Set tne new wallpaper
#===========================================

swww img $wallpaper --transition-step 30 --transition-type grow --transition-fps=60
#~/.config/waybar/reload.sh
#===========================================
# Get wallpaper path
#===========================================
wallpaper_path=$(cat "$HOME/.cache/swww/eDP-1")

#===========================================
# Copy current wallpaper for hyprlock
#===========================================
cp "$wallpaper_path" "$HOME/.config/hypr/wallpaper_effects/current_wallpaper"

#===========================================
# Restart Waybar
#===========================================
~/dotfiles/scripts/restartwaybar.sh

#===========================================
# Send notification
#===========================================

# notify-send "Theme and Wallpaper updated" "With image $newwall"

echo "DONE!"
