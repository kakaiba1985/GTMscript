apt update -y
apt upgrade -y 
apt install dnsutils -y

cat <<\EOM > gtm1.sh
#!/bin/bash
## Copyright ©UDPTeam
## Discord: https://discord.gg/civ3
## Script to keep-alive your DNSTT server domain record query from target resolver/local dns server
## Run this script excluded to your VPN tunnel (split vpn tunneling mode)


## Your DNSTT Nameserver & your Domain A Record
NS='sl01.thunderbolt-marketing.site'
A='sl1.thunderbolt-marketing.site'
## Repeat dig cmd loop time (seconds) (positive interger only)
LOOP_DELAY=5

## Add your DNS here
declare -a HOSTS=('112.198.126.124' '112.198.126.116' '112.198.126.44')

## Linux' dig command executable filepath
## Select value: "CUSTOM|C" or "DEFAULT|D"
DIG_EXEC="DEFAULT"
## if set to CUSTOM, enter your custom dig executable path here
CUSTOM_DIG=/usr/bin/dig

######################################
######################################
######################################
######################################
######################################
VER=0.1
case "${DIG_EXEC}" in
 DEFAULT|D)
 _DIG="$(command -v dig)"
 ;;
 CUSTOM|C)
 _DIG="${CUSTOM_DIG}"
 ;;
esac
if [ ! $(command -v ${_DIG}) ]; then
 printf "%b" "Dig command failed to run, " \
 "please install dig(dnsutils) or check " \
 "\$DIG_EXEC & \$CUSTOM_DIG variable inside $( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/$(basename "$0") file.\n" && exit 1
fi
endscript() {
 unset NS A LOOP_DELAY HOSTS _DIG DIG_EXEC CUSTOM_DIG T R M
 exit 1
}
trap endscript 2 15
check(){
 for ((i=0; i<"${#HOSTS[*]}"; i++)); do
  for R in "${A}" "${NS}"; do
   T="${HOSTS[$i]}"
   [[ -z $(timeout -k 3 3 ${_DIG} @${T} ${R}) ]] && M=31 || M=32;
   echo -e "\e[1;${M}m\$ R:${R} D:${T}\e[0m"
   unset T R M
  done
 done
}

echo "DNSTT Keep-Alive script <BY JC GWAPO>"
echo -e "DNS List: [\e[1;34m${HOSTS[*]}\e[0m]"
echo "CTRL + C to close script"
[[ "${LOOP_DELAY}" -eq 1 ]] && let "LOOP_DELAY++";
case "${@}" in
 loop|l)
 echo "Script loop: ${LOOP_DELAY} seconds"
 while true; do
  check
  echo '.--. .-.. . .- ... .     .-- .- .. -'
  sleep ${LOOP_DELAY}
 done
 ;;
 *)
 check
 ;;
esac
exit 0
EOM
chmod +x gtm1.sh
./gtm1.sh l