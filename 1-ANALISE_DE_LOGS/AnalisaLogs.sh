#!/bin/bash

###########################################################################
# DESCRIÇÃO: Script para analise do arquivos de access.log do Apache 2
# CRIADOR: João Eduardo
# E-MAIL: joaoeducoft@gmail.com
# VERSÃO: 1.0
# OBS: Digite no prompt de comando:		bash AnalisaLogs.sh <arquivo.log>
###########################################################################

# ESTILOS
NEGRITO="\e[01m"
FIM="\e[0m"

# VARIAVEIS LOCAIS
IDENTIFICA_IPS=$(cut -d " " -f1 $1 | sort | uniq -c | sort -unr | sed 's/\ \+/\t/'| sed 's/\ \+/\t\t/')

IDENTIFICA_SUSPEITO=$(cut -d " " -f1 $1 | sort | uniq -c | sort -unr | awk '{ FS=" "; print $2 }' | head -n1 )

IDENTIFICA_REQUISICOES=$(cut -d " " -f1 $1 | sort | uniq -c | sort -unr | awk '{ FS=" "; print $1 }' | head -n1 )

IDENTIFICA_NAVEGADOR=$(grep $IDENTIFICA_SUSPEITO $1 | head -n1 | cut -d " " --complement -s -f1-11)

IDENTIFICA_FERRAMENTAS=$(grep $IDENTIFICA_SUSPEITO $1 | cut -d " " --complement -s -f1-11 | sort | uniq -c | sort -unr | sed 's/\ \+/\t/' | sed 's/\ \+/\t\t\t/' | nl )

VERIFICAR_INICIO=$(grep $IDENTIFICA_SUSPEITO $1 | head -n1 | awk '{ FS=" "; print $4 $5 }')

VERIFICAR_FIM=$(grep $IDENTIFICA_SUSPEITO $1 | tail -n1 | awk '{ FS=" "; print $4 $5 }')

# CORPO DO SCRIPT
figlet "$1"

echo -e "$NEGRITO Nº de Ocorrencias:	Conexões identificadas: $FIM"
echo -e "$IDENTIFICA_IPS \n"
echo -e "$NEGRITO IP Suspeito:$FIM $IDENTIFICA_SUSPEITO"
echo -e "$NEGRITO Ocorrencias:$FIM $IDENTIFICA_REQUISICOES"
echo -e "$NEGRITO Inicio:$FIM $VERIFICAR_INICIO"
echo -e "$NEGRITO Fim:$FIM $VERIFICAR_FIM"
echo -e "$NEGRITO Navegador:$FIM $IDENTIFICA_NAVEGADOR"
echo -e "$NEGRITO Ferramentas Utilizadas:$FIM \n\n"
echo -e "$NEGRITO ID:		Nº de Ocorrencias:	Descrição:$FIM \n"
echo -e "$IDENTIFICA_FERRAMENTAS \n"




