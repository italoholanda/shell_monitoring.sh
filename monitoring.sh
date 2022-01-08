#!/bin/bash
arch=$( uname -a | awk '{print $2" "$1" "$3}' )
fcpu=$( cat /proc/cpuinfo | grep processor | wc -l )
vcpu=$( cat /proc/cpuinfo | grep 'physical id' | wc -l )
ramu=$( free -m | awk 'NR==2 {print $3"/"$4"MB "(100*$3/$2)"%"}' )
fdis=$( df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}' )
udis=$( df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}' )
pdis=$( df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}' )
cpuu=$( mpstat | awk 'NR==4 {print 100-$13"%"}' )
lreb=$( last reboot | awk 'NR==1 {print $5" "$6" "$7" "$8}' )
acon=$( ss -s | awk '/TCP:/{print $2}' )
lvmc=$( lsblk | grep "lvm" | wc -l )
lvmu=$( if [ $lvmc -eq 0 ]; then echo no; else echo yes; fi )
ulog=$( users | wc -l )
ipad=$( hostname -I )
maad=$( ip link show | awk '$1 == "link/ether" {print $2}' )
suco=$( journalctl _COMM=sudo -q | grep COMMAND | wc -l )

wall "
#Architecture: $arch
#CPU physical: $fcpu
#vCPU: $vcpu
#Memory Usage: $ramu
#Disk Usage: $udis/${fdis}Gb ($pdis%)
#CPU load: $cpuu
#Last boot: $lreb
#LVM use: $lvmu
#Connexions TCP: $acon ESTABLISHED
#User log: $ulog
#Network: IP $ipad ($maad)
#Sudo: $suco cmd
"
