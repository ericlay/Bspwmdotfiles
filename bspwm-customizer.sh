#!/bin/bash

#COLORS
#=======
RED='\e[41m'
BLUE='\e[44m'
ORANGE='\e[46m'
NC='\e[0m'

# Service messages section
ERRORMSG="$RED Wrong.$NC"
TRYAGAINMSG="$RED Enter desired option number and try again$NC"
CHANGECOLOR="Enter the six character RGB hex value for the desired color\nPlease do not prepend value with #\nPlease do not use any quotation marks"
CHANGEALPHA="Enter a two digit number from 00 -> 99\n 00 representing full transparency\n 99 representing full opacity"

#Functions for altering configs
#===============================

#COLORS MENU ###
function window_title_color {
	alpha_placeholder=`grep COLOR_TITLE_HACK ~/.limepanelrc | cut -c 20-21`
	sed -i -e "/COLOR_TITLE_HACK=/ s/#\w*/#$alpha_placeholder$color_wanted/" ~/.limepanelrc
	bspc wm -r
	colors_menu
}

function main_color {
	alpha_placeholder=`grep COLOR_FOCUSED_DESKTOP_FG ~/.limepanelrc | cut -c 28-29`
	sed -i -e "/COLOR_FOCUSED_DESKTOP_FG=/ s/#\w*/#$alpha_placeholder$color_wanted/" ~/.limepanelrc
	bspc wm -r
	colors_menu
}

function inactive_desktop {
	alpha_placeholder=`grep COLOR_DESKTOP_FG ~/.limepanelrc | cut -c 20-21`
	sed -i -e "/COLOR_DESKTOP_FG=/ s/#\w*/#$alpha_placeholder$color_wanted/" ~/.limepanelrc
	bspc wm -r
	colors_menu
}

function panel_bkgrnd {
	alpha_placeholder=`grep COLOR_DESKTOP_BG ~/.limepanelrc | cut -c 20-21`
	sed -i -e "/COLOR_DESKTOP_BG=/ s/#\w*/#$alpha_placeholder$color_wanted/" ~/.limepanelrc
	alpha_placeholder=`grep COLOR_FOCUSED_DESKTOP_BG ~/.limepanelrc | cut -c 28-29`
	sed -i -e "/COLOR_FOCUSED_DESKTOP_BG=/ s/#\w*/#$alpha_placeholder$color_wanted/" ~/.limepanelrc
	bspc wm -r
	colors_menu
}

function focused_window_border {
	sed -i -e "/focused_border_color/ s/#\w*/#$color_wanted/" ~/.config/bspwm/bspwmrc
	bspc wm -r
	window_colors_menu
}

function normal_window_border {
	sed -i -e "/normal_border_color/ s/#\w*/#$color_wanted" ~/.config/bspwm/bspwmrc
	bspc wm -r
	window_colors_menu
}

function presel_feedback_color {
	sed -i -e "/presel_feedback_color/ s/#\w*/#$color_wanted" ~/.config/bspwm/bspwmrc
	bspc wm -r
	window_colors_menu
}

#ALPHA MENU###
function panel_alpha {
	sed -i -e "/COLOR_DESKTOP_BG=/ s/#\w\w/#$alpha_wanted/" ~/.limepanelrc
	sed -i -e "/COLOR_FOCUSED_DESKTOP_BG=/ s/#\w\w/#$alpha_wanted/" ~/.limepanelrc
	bspc wm -r
	alpha_menu
}

function active_windows_alpha {
	if [ "$alpha_wanted" = "1" ]; then
		sed -i -e "/\bactive-opacity =/ s/=.*$/= $alpha_wanted;/" ~/.config/picom.conf
	elif [ "$alpa_wanted" = "0" ]; then
		sed -i -e "/\bactive-opacity =/ s/=.*$/= $alpha_wanted;/" ~/.config/picom.conf
	elif [ "$alpha_wanted" -gt 1 ]; then
		sed -i -e "/\bactive-opacity =/ s/=.*$/= 0.$alpha_wanted;/" ~/.config/picom.conf
	fi
	killall compton
	compton -b
	alpha_menu
}

function inactive_windows_alpha {
	if [ "$alpha_wanted" = "1" ]; then
		sed -i -e "/inactive-opacity =/ s/=.*$/= $alpha_wanted;/" ~/.config/picom.conf
	elif [ "$alpa_wanted" = "0" ]; then
		sed -i -e "/inactive-opacity =/ s/=.*$/= $alpha_wanted;/" ~/.config/picom.conf
	elif [ "$alpha_wanted" -gt 1 ]; then
		sed -i -e "/inactive-opacity =/ s/=.*$/= 0.$alpha_wanted;/" ~/.config/picom.conf
	fi
	killall compton
	compton -b
	alpha_menu
}

#function menu_alpha {
#	if [ "$alpha_wanted" = "0" ]; then
#		
#	
#}

#Functions for menu dialogs
#===========================

function window_colors_menu {
	while true ; do
	clear
    echo ""
    echo -e "     ::Window Borders Menu:: "
    echo -e " ┌─────────────────────────────┐"
    echo -e " │  1   Focused Window Border  │"
    echo -e " │  2   Normal Window Border   │"
    echo -e " │  3   Presel Feedback        │"    
    echo -e " └─────────────────────────────┘"
    echo -e "  Select an item    -   0  Exit "
    echo -e ""
	read -s -n1 choice
	case $choice in
		1)
			echo ""
			echo -e "$CHANGECOLOR"
			echo ""
			read color_wanted
			focused_window_border
			echo ""
			;;
		2)
		    echo ""
		    echo -e "$CHANGECOLOR"
		    echo ""
		    read color_wanted
		    normal_window_border
		    ;;
		3)
			echo ""
			echo -e "$CHANGECOLOR"
			echo ""
			read color_wanted
			presel_feedback_color
			echo ""
			;;
		0)
			colors_menu
			;;
		*)
			echo -e "$ERRORMSG$TRYAGAINMSG"
			read -s -n1
				clear
			;;
	esac
	done
}

function colors_menu {
	while true ; do
	clear
    echo ""
    echo -e "         ::Colors Menu:: "
    echo -e " ┌──────────────────────────────┐"
    echo -e " │     1   Window Title         │"
    echo -e " │     2   Main                 │"
    echo -e " │     3   Inactive Desktop     │"    
    echo -e " │     4   Panel Background     │"
    echo -e " │     5   Window Borders       │"
    echo -e " └──────────────────────────────┘"
    echo -e "  Select an item    -    0  Exit "
    echo ""
	read -s -n1 choice
	case $choice in
		1)
			echo ""
			echo -e "$CHANGECOLOR"
			echo ""
			read color_wanted
			window_title_color
			echo ""
			;;
		2)
		    echo ""
		    echo -e "$CHANGECOLOR"
		    echo ""
		    read color_wanted
		    main_color
		    ;;
		3)
			echo ""
			echo -e "$CHANGECOLOR"
			echo ""
			read color_wanted
			inactive_desktop
			echo ""
			;;
		4)
			echo ""
			echo -e "$CHANGECOLOR"
			echo ""
			read color_wanted
			panel_bkgrnd
			echo ""
			;;
		5)
			window_colors_menu
			;;
		0)
			main
			;;
		*)
			echo -e "$ERRORMSG$TRYAGAINMSG"
			read -s -n1
				clear
			;;
	esac
	done
}

function alpha_menu {
	while true ; do
	clear
    echo ""
    echo -e "   ::Transparency Menu:: "
    echo -e " ┌────────────────────────┐"
    echo -e " │  1   Panel             │"
    echo -e " │  2   Active Windows    │"
    echo -e " │  3   Inactive Windows  │"    
    echo -e " │  4   Menu              │"
    echo -e " │  5   Terminal          │"
    echo -e " └────────────────────────┘"
    echo -e " Select an item  -  0  Exit "
    echo ""
	read -s -n1 choice
	case $choice in
		1)
			echo ""
			echo -e "$CHANGEALPHA"
			echo ""
			read alpha_wanted
			panel_alpha
			echo ""
			;;
		2)
		    echo ""
		    echo -e "$CHANGEALPHA"
		    echo -e "    Use 1 for full opacity"
		    echo -e "  Use 01 for 10% transparency"
		    echo ""
		    read alpha_wanted
		    active_windows_alpha
		    echo ""
		    ;;
		3)
			echo ""
			echo -e "$CHANGEALPHA"
			echo ""
			read alpha_wanted
			inactive_windows_alpha
			echo ""
			;;
		4)
			echo ""
			echo ""
			echo -e "  The dmenu window is tied to the\n   inactive window opacity level.\n\n Changing this setting will overwrite\n   ALL previous focus-exclude rules."
			echo ""
			echo -e "Press 0 for transparent and 1 for opaque"
			read alpha_wanted
			menu_alpha
			echo ""
			;;
		5)
			terminal_alpha
			;;
		0)
			main
			;;
		*)
			echo -e "$ERRORMSG$TRYAGAINMSG"
			read -s -n1
				clear
			;;
	esac
	done
}

## MAIN MENU
#============
function main {
	while true ; do
	clear
    echo ""
    echo -e "         ::Main menu:: "
    echo -e "  ┌────────────────────────────┐"
    echo -e "  │      1   Colors            │"
    echo -e "  │      2   Transparency      │"
    echo -e "  │      3   Panel             │"    
    echo -e "  │      4   Rofi              │"
    echo -e "  │      5   Customize         │"
    echo -e "  └────────────────────────────┘"
    echo -e "   Select an item   -   0  Exit "
    echo ""
    echo -e "            WARNING! "
	echo -e "Program expects the stock Manjaro\nenvironment applications and file\nlocations as found on new install"
    echo ""
	read -s -n1 choice
	case $choice in
		1)
			echo
			colors_menu
			echo ""
			;;
		2)
			echo
			alpha_menu
			echo ""
			;;
		3)
			echo
			panel_
			echo ""
			;;
		4)
			echo
			rofi_
			echo""
			;;
		5)
			echo
			customize_
			echo ""
			;;
		0)
			clear && exit
			;;
		*)
			echo -e "$ERRORMSG$TRYAGAINMSG"
			read -s -n1
				clear
			;;
	esac
	done
}

main