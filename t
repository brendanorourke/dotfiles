[1;33mdiff --git a/link/.polybar b/link/.polybar[m
[1;33mindex 5bcea26..82e93f3 100644[m
[1;33m--- a/link/.polybar[m
[1;33m+++ b/link/.polybar[m
[1;35m@@ -1,5 +1,5 @@[m
 [bar/top][m
[1;31m-monitor = eDP-1[m
[1;32m+[m[1;32mmonitor = ${env:POLY_MONITOR:eDP-1}[m
 width = 100%[m
 height = 28[m
 [m
[1;35m@@ -19,7 +19,7 @@[m [mfont-2 = Termsynu:size=8:antialias=false;-2[m
 font-3 = FontAwesome:size=10;0[m
 [m
 modules-left = powermenu cpu memory temperature filesystem [m
[1;31m-modules-right = wireless-network battery date[m
[1;32m+[m[1;32mmodules-right = wired-network wireless-network battery date[m
 [m
 [bar/bottom][m
 monitor = eDP-1[m
[1;35m@@ -142,8 +142,8 @@[m [minterval = 3.0[m
 ping-interval = 10[m
 [m
 format-connected = <ramp-signal> <label-connected>[m
[1;31m-label-connected = %essid% %{T3}%local_ip%%{T-}[m
[1;31m-label-disconnected = not connected[m
[1;32m+[m[1;32mlabel-connected = %essid% (%local_ip%):  %upspeed%  %downspeed%[m
[1;32m+[m[1;32mlabel-disconnected = %ifname%: ! not connected[m
 label-disconnected-foreground = #66[m
 [m
 ramp-signal-0 = 0[m
[1;35m@@ -158,6 +158,24 @@[m [manimation-packetloss-1 = x[m
 animation-packetloss-1-foreground = ${bar/top.foreground}[m
 animation-packetloss-framerate = 500[m
 [m
[1;32m+[m[1;32m[module/wired-network][m
[1;32m+[m[1;32mtype = internal/network[m
[1;32m+[m
[1;32m+[m[1;32minterface = enp0s31f6[m
[1;32m+[m[1;32minterval = 3.0[m
[1;32m+[m[1;32mping-interval = 10[m
[1;32m+[m
[1;32m+[m[1;32mformat-connected = <label-connected>[m
[1;32m+[m[1;32mlabel-connected = %ifname% (%local_ip%):  %upspeed%  %downspeed%[m
[1;32m+[m[1;32mlabel-disconnected = %ifname%: ! not connected[m
[1;32m+[m[1;32mlabel-disconnected-foreground = #66[m
[1;32m+[m
[1;32m+[m[1;32manimation-packetloss-0 = [m
[1;32m+[m[1;32manimation-packetloss-0-foreground = #ffa64c[m
[1;32m+[m[1;32manimation-packetloss-1 = x[m
[1;32m+[m[1;32manimation-packetloss-1-foreground = ${bar/top.foreground}[m
[1;32m+[m[1;32manimation-packetloss-framerate = 500[m
[1;32m+[m
 [module/powermenu][m
 type = custom/menu[m
 [m
[1;35m@@ -200,7 +218,7 @@[m [mtype = internal/temperature[m
 [m
 interval = 1[m
 thermal-zone = 0[m
[1;31m-hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input[m
[1;32m+[m[1;32mhwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon1/temp1_input[m
 warn-temperature = 80[m
 [m
 format = <ramp> <label>[m
[1;35m@@ -221,7 +239,7 @@[m [mramp-foreground = #ccffffff[m
 type = internal/fs[m
 [m
 mount-0 = /[m
[1;31m-mount-1 = /boot[m
[1;32m+[m[1;32mmount-1 = /boot/efi[m
 [m
 fixed-values = false[m
 internval = 30[m
[1;33mdiff --git a/link/.zshrc b/link/.zshrc[m
[1;33mindex 48f8066..85301e8 100644[m
[1;33m--- a/link/.zshrc[m
[1;33m+++ b/link/.zshrc[m
[1;35m@@ -12,7 +12,7 @@[m [mDEFAULT_USER="$(id -un)"[m
 BULLETTRAIN_TIME_BG="black"[m
 BULLETTRAIN_TIME_FG="white"[m
 ZSH=~/.oh-my-zsh[m
[1;31m-ZSH_THEME="common"[m
[1;32m+[m[1;32mZSH_THEME="bullet-train"[m
 [m
 source $ZSH/oh-my-zsh.sh[m
 [m
[1;33mdiff --git a/scripts/launch_polybar.sh b/scripts/launch_polybar.sh[m
[1;33mindex d931917..e90a45f 100755[m
[1;33m--- a/scripts/launch_polybar.sh[m
[1;33m+++ b/scripts/launch_polybar.sh[m
[1;35m@@ -1,5 +1,7 @@[m
 #!/usr/bin/env bash[m
 [m
[1;32m+[m[1;32mdeclare -r PRIMARY_MONITOR=$(xrandr --query | grep '\bconnected' | grep '\bprimary\b' | awk '{print $1;}')[m
[1;32m+[m
 # Terminate already running polybar instances[m
 killall -q polybar[m
 [m
[1;35m@@ -7,6 +9,6 @@[m [mkillall -q polybar[m
 while pgrep -u $UID polybar >/dev/null; do sleep 1; done[m
 [m
 # Launch top polybar[m
[1;31m-polybar top --config=$HOME/.polybar &[m
[1;32m+[m[1;32mPOLY_MONITOR=$PRIMARY_MONITOR bash -c 'polybar top --config=$HOME/.polybar &'[m
 [m
 echo "Polybar launched..."[m
