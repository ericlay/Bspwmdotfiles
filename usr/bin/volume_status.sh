#!/bin/dash
. ~/.limepanelrc

panel_volicon()
{
        volStatus=$(pulseaudio-ctl full-status | awk '{print $2}')
        volLevel=$(pulseaudio-ctl C)

        if [ "$volStatus" = "yes" ]
                then echo "$muted_icon"
        elif [ "$volStatus" = "no" ]
                then echo "$unmuted_icon"
		else echo " ?"
        fi
}

panel_avolicon()
{
        avolStatus=$(avol state)
        avolLevel=$(avol level)

        if [ "$avolStatus" = "off" ]
                then echo "$muted_icon"
        elif [ "$avolStatus" = "on" ]
                then echo "$unmuted_icon"
		else echo " ?"
        fi
}

if [ $(pgrep pulseaudio >/dev/null) ]; then
		echo "V"%{A:dvol:}%{A2:volume mute:}%{A5:volume down 1:}%{A4:volume up 1:}$(panel_volicon)%{A}%{A}%{A}%{A} > "/tmp/panel-fifo1" 
	else
		echo "V"%{A:dvol:}%{A2:volume mute:}%{A5:volume down 1:}%{A4:volume up 1:}$(panel_avolicon)%{A}%{A}%{A}%{A} > "/tmp/panel-fifo1"
fi
