#!/bin/bash

###########################################################################
# DESCRIÇÃO: Script para analise de estrutura do cabeçalho TCP/IP
# CRIADOR: João Eduardo
# E-MAIL: joaoeducoft@gmail.com
# VERSÃO: 1.0
# OBS 1: Digite no prompt de comando:		bash AnalisaEstruturaTCP.sh <arquivo.txt>
# OBS 2: Instale o programa "xxd" para conversão do conteúdo hexadecimal para decimal:	apt install xxd
###########################################################################

# ESTILOS
NEGRITO="\e[01m"
FIM="\e[0m"

# VARIAVEIS DST
DST_1=$(cut -d " " -f15-16 $1 | head -n2 | tail -n1 | sed 's/^/ /g' | sed 's/\ / 0x/g')
DST_2=$(cut -d " " -f1-2 $1 | head -n3 | tail -n1 | sed 's/^/ /g' | sed 's/\ / 0x/g')
# VARIAVEIS LOCAIS
MAC_DST=$(cut -d " " -f1-6 $1 | head -n1 | sed 's/\ /\:/g')
MAC_SRC=$(cut -d " " -f7-12 $1 | head -n1 | sed 's/\ /\:/g')
TYPE_ETHERNET=$(awk '{ FS=" "; print $13 $14 }' $1 | head -n1)
VERSION=$(awk '{ FS=" "; print substr ($15, 1,1) }' $1 | head -n1)
IHL=$( expr 4 \* "$(awk '{ FS=" "; print substr ($15, 2,2) }' $1 | head -n1)")
TOTAL_LENGTH=$(printf "%d" $(cut -d " " -f1-2 $1 | head -n2 | tail -n1 | sed 's/^/ 0x/g' | sed 's/\ //g'))
IDENTIFICATION=$(printf "%d" "0x$(awk '{ FS=" "; print $3 $4 }' $1 | head -n2 | tail -n1)")
TTL=$(printf "%d" "0x$(awk '{ FS=" "; print $5 }' $1 | head -n2 | tail -n1)")
TYPE_PROTO_IDENTIFY=$(printf "%d" "0x$(awk '{ FS=" "; print $6 }' $1 | head -n2 | tail -n1)")
IP_SRC=$(printf "%d:%d:%d:%d" $(cut -d " " -f11-14 $1 | head -n2 | tail -n1 | sed 's/^/ /g' | sed 's/\ / 0x/g'))
IP_DST=$(printf "%d:%d:%d:%d" $DST_1 $DST_2 2> /dev/null)
FLAG_TCP_IDENTIFY=$(printf "%d" $(cut -d " " -f16 $1 | head -n3 | tail -n1) 2> /dev/null)
MENSAGE=$(xxd -r -p "$1" | tail -n +3 2> /dev/null)

# VARIAVEIS ETHERNET
if [ "$TYPE_ETHERNET" = 0800 ]; then
	TYPE_IP="IPV4"
fi
if [ "$TYPE_ETHERNET" = 0802 ]; then
	TYPE_IP="ARP"
fi

# VARIAVEIS PROTOCOLO
if [ "$TYPE_PROTO_IDENTIFY" = 0 ]; then
	TYPE_PROTO="IP"
fi

if [ "$TYPE_PROTO_IDENTIFY" = 6 ]; then
	TYPE_PROTO="TCP (6)"
fi

if [ "$TYPE_PROTO_IDENTIFY" = 17 ]; then
	TYPE_PROTO="UDP (17)"
fi

if [ "$TYPE_PROTO_IDENTIFY" = 1 ]; then
	TYPE_PROTO="ICMP"
fi

# VARIAVEIS FLAG TCP
if [ "$FLAG_TCP_IDENTIFY" = 20 ]; then
	FLAG_TCP="RST/ACK"
fi

if [ "$FLAG_TCP_IDENTIFY" = 18 ]; then
	FLAG_TCP="SYN/ACK"
fi

if [ "$FLAG_TCP_IDENTIFY" = 17 ]; then
	FLAG_TCP="FIN/ACK"
fi

if [ "$FLAG_TCP_IDENTIFY" = 16 ]; then
	FLAG_TCP="ACK"
fi

if [ "$FLAG_TCP_IDENTIFY" = 2 ]; then
	FLAG_TCP="SYN"
fi


# CORPO DO SCRIPT
figlet "$1"

echo -e "$NEGRITO Tipo: $FIM		$TYPE_IP"
echo -e "$NEGRITO Versão: $FIM	$VERSION"
echo -e "$NEGRITO Header Length: $FIM$IHL bytes"
echo -e "$NEGRITO Total Length: $FIM	$TOTAL_LENGTH bytes"
echo -e "$NEGRITO Identificação: $FIM$IDENTIFICATION"
echo -e "$NEGRITO TTL: $FIM		$TTL"
echo -e "$NEGRITO Protocolo: $FIM	$TYPE_PROTO"
echo -e "$NEGRITO Flag: $FIM		$FLAG_TCP \n"

echo -e "$NEGRITO IP Origem: $FIM	$IP_SRC"
echo -e "$NEGRITO Mac Origem: $FIM	$MAC_SRC \n"
echo -e "$NEGRITO IP Destino: $FIM	$IP_DST"
echo -e "$NEGRITO Mac Destino: $FIM	$MAC_DST \n"
echo -e "$NEGRITO Mensagem: $FIM	\n $MENSAGE \n"





