#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 09/10/2018
# Versão: 0.13
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Configuração do Rsync para replicação de pastas
# Configuração do sistema de Backup utilizando o Backupninja
# Configuração do sistema de Monitoramente utilizando o Netdata
# Configuração da limpeza da Pasta Público
# Configuração da limpeza da Pasta Lixeira
# Configuração da limpeza das Filas de Email do Postfix
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-20.sh
LOG="/var/log/script-20.log"
#
# Variável da Data Inicial para calcular tempo de execução do Script
DATAINICIAL=`date +%s`
#
# Validando o ambiente, verificando se o usuário e "root"
USUARIO=`id -u`
UBUNTU=`lsb_release -rs`
KERNEL=`uname -r | cut -d'.' -f1,2`

if [ "$USUARIO" == "0" ]
then
	if [ "$UBUNTU" == "16.04" ]
		then
			if [ "$KERNEL" == "4.4" ]
				then
					 clear
					 # Exportando o recurso de Noninteractive do Debconf
					 export DEBIAN_FRONTEND="noninteractive"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-20.sh"
					 echo
					 echo -e "Rodando o Script-20.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "       Instalação e Configuração do Sistema de Backup e Monitoramento"
					 echo -e "================================================================================="
					 echo

					 echo -e "Instalação do Backupninja no servidor: `hostname`"
					 echo -e "Pressione <Enter> para instalar"
					 read
					 echo
					 
					 echo -e "Atualização as listas do Apt-Get, aguarde..."
					 #Fazendo a atualização das listas do apt-get
					 apt-get update &>> $LOG
					 echo -e "Atualização das lista do apt-get feita com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Atualizando os software instalados, aguarde..."
					 #Fazendo a atualização de todos os software do servidor
					 apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &>> $LOG
					 echo -e "Atualização do sistema feita com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Setando as configurações do Postfix, aguarde..."
					 #Setando as configurações do debconf para o postfix funcionar no modo Noninteractive
					 echo -e "postfix postfix/mailname string ptispo01dc01.pti.intra" | debconf-set-selections &>> $LOG
					 echo -e "postfix postfix/main_mailer_type string Internet Site" | debconf-set-selections &>> $LOG
					 echo -e "Configurações setadas com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Instalando o Backupninja, aguarde..."
					 #Instalando o Backupninja
					 apt-get -y install backupninja &>> $LOG
					 echo -e "Instalação do Backupninja feita com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "Instalação do sistema de monitoramente em tempo real Netdata"
					 echo -e "Após a instalação acessar a URL http://`hostname`:19999"
					 echo -e "Download e instalação das dependências do Netdata"
					 echo -e "Pressione <Enter> para instalar"
					 read
					 
					 echo -e "Instalação das dependências do Netdata, aguarde..."
					 #Instalando as dependências do Netdata
					 apt-get -y install zlib1g-dev gcc make git autoconf autogen automake pkg-config uuid-dev python python-pip python-dev python3-dev libmysqlclient-dev python-ipaddress &>> $LOG
					 echo -e "Instalação das dependêncais do Netdata feita com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Limpando as informações do cache do apt-get, aguarde..."
					 #Limpando o cache do apt-get
					 apt-get clean >> $LOG
					 echo -e "Limpeza do cache do apt-get feito com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Clonando o projeto do Netdata do Github, aguarde..."
					 #Clonando o site do GitHub do Netdata
					 git clone https://github.com/firehol/netdata.git --depth=1 &>> $LOG
					 echo -e "Clonagem do software do Netdata feito com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 #Acessando o diretório do Netdata
					 cd netdata
					 echo -e "Pressione <Enter> para compilar o software do NetData"
					 echo
					 read
					 
					 #Compilando e instalando o Netdata
					 ./netdata-installer.sh
					 #Saindo do diretório do Netdata
					 cd ..
					 echo
					 
					 echo -e "Removendo o diretório do Netdata, aguarde..."
					 #Removendo o diretório do Netdata
					 rm -Rfv netdata/ >> $LOG
					 echo -e "Diretório removido com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 #EM DESENVOLVIMENTO DAS CONFIGURAÇÕES DOS PLUGUINS DO NETDATA 01/10/2018
					 #echo -e "Instalando os recursos de acesso ao Banco de Dados MySQL, aguarde..."
					 #Utilizando o comando pip para instalar os pluguins do Python para acesso ao MySQL
					 #Atualizando o PIP
					 #pip install --upgrade pip &>> $LOG
					 #
					 #Instalando o PyMySQL
					 #pip2.7 install pymysql &>> $LOG
					 #
					 #Instalando o MySQLClient
					 #pip2.7 install mysqlclient
					 #
					 #Fazendo o Backup dos Arquivos de Configuração Original
					 #mv -v /usr/lib/netdata/conf.d/python.d/isc_dhcpd.conf /usr/lib/netdata/conf.d/python.d/isc_dhcpd.conf.old &>> $LOG
					 #mv -v /usr/lib/netdata/conf.d/python.d/mysql.conf /usr/lib/netdata/conf.d/python.d/mysql.conf.old &>> $LOG
					 #mv -v /usr/lib/netdata/conf.d/python.d/bind_rndc.conf /usr/lib/netdata/conf.d/python.d/bind_rndc.conf.old &>> $LOG
					 #
					 #Copiando os arquivos de Configuração do MySQL, ISC-DHCPD e Bind
					 #cp -v conf/mysql.conf /usr/lib/netdata/conf.d/python.d/ &>> $LOG
					 #cp -v conf/isc_dhcpd.conf /usr/lib/netdata/conf.d/python.d/ &>> $LOG
					 #cp -v conf/bind_rndc.conf /usr/lib/netdata/conf.d/python.d/ &>> $LOG
					 #
					 
					 echo -e "Instalação do Netdata feita com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "Configurando o Backupninja e criando os agendamentos de backup"
					 echo -e "Pressione <Enter> para configurar o backup"
					 read
					 #Criando e agendando o backup do diretório /arquivos/pti.intra
					 #Utilização do wizard do Backupninja (mais fácil)
					 ninjahelper
					 echo -e "Backupninja agendando com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Configurando o serviço do Rsync"
					 echo -e "Alterar a linha: RSYNC_ENABLE=false para RSYNC_ENABLE=true"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 
					 echo -e "Fazendo o backup do arquivo rsync, aguarde..."
					 #Fazendo o backup do arquivo de configuração do rsync
					 cp -v /etc/default/rsync /etc/default/rsync.old &>> $LOG
					 echo -e "Backup feito com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 #Editando o arquivo do serviço do rsync
					 vim /etc/default/rsync +8
					 echo
					 
					 echo -e "Reinicializando o serviço do Rsync, aguarde..."
					 #Reinicializando o serviço do rsync
					 sudo service rsync restart
					 echo -e "Serviço reinicializado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 
					 echo
					 echo -e "Criando o agendamento do sincronismo de pastas"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 
					 echo -e "Atualizando o arquivo do rsync_samba, aguarde..."
					 #Copiando o script do sincronismo do rsync do samba
					 cp -v conf/rsync_samba /usr/sbin >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Alterando as permissões do arquivo rsync_samba, aguarde..."
					 #Aplicando as permissões
					 chmod -v 750 /usr/sbin/rsync_samba >> $LOG
					 echo -e "Permissões alteradas com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo rsyncsamba, aguarde..."
					 #Copiando o agendamento do sincronismo do rsync do samba
					 cp -v conf/rsyncsamba /etc/cron.d/ >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
					 sleep 2
					 
					 #Editando o arquivo do sincronismo
					 vim /etc/cron.d/rsyncsamba +13
					 
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Agendamento da Limpeza da Pasta Público"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 
					 echo -e "Atualizando o arquivo clean_public, aguarde..."
					 #Copiando o script da limpeza da pasta público
					 cp -v conf/clean_public /usr/sbin >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Alterando as permissões do arquivo clean_public, aguarde..."
					 #Aplicando as permissões
					 chmod -v 750 /usr/sbin/clean_public >> $LOG
					 echo -e "Permissões alteradas com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo cleanpublic, aguarde..."
					 #Copiando o agendamento da limpeza da pasta público
					 cp -v conf/cleanpublic /etc/cron.d/ >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 #Editando o arquivo do agendamento
					 vim /etc/cron.d/cleanpublic +13
					 
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Agendamento da Limpeza da Pasta Lixeira"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 
					 echo -e "Atualizando o arquivo clean_recycle, aguarde..."
					 #Copiando os script da limpeza da pasta lixeira
					 cp -v conf/clean_recycle /usr/sbin >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Alterando as permissões do arquivo clean_recycle, aguarde..."
					 #Aplicando as permissões
					 chmod -v 750 /usr/sbin/clean_recycle >> $LOG
					 echo -e "Permissões alteradas com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo cleanrecycle, aguarde..."
					 #Copiando o agendamento da limpeza da pasta lixeira
					 cp -v conf/cleanrecycle /etc/cron.d/ >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 #Editando o arquivo do agendamento
					 vim /etc/cron.d/cleanrecycle +13
					 
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Agendamento da Limpeza dos E-mail do Postifix"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 
					 echo -e "Atualizando o arquivo postfix_queue, aguarde..."
					 #Copiando os script da limpeza da dos e-mail do postfix
					 cp -v conf/postfix_queue /usr/sbin >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Alterando as permissões do arquivo postfix_queue, aguarde..."
					 #Aplicando as permissões
					 chmod -v 750 /usr/sbin/postfix_queue >> $LOG
					 echo -e "Permissões alteradas com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo postfixqueue, aguarde..."
					 #Copiando o agendamento da limpeza dos e-mail do postfix
					 cp -v conf/postfixqueue /etc/cron.d/ >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 #Editando o arquivo do agendamento do postfix
					 vim /etc/cron.d/postfixqueue +13
					 
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "Fim do Script-20.sh em: `date`" >> $LOG
					 echo -e "        Instalação e Configuração do Sistema de Backup e Monitoramento"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-20.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-20.sh: $TEMPO"
					 echo -e "Pressione <Enter> para concluir o processo."
					 read
					 else
						 echo -e "Versão do Kernel: $KERNEL não homologada para esse script, versão: >= 4.4 "
						 echo -e "Pressione <Enter> para finalizar o script"
					 read
			fi
		else
			 echo -e "Distribuição GNU/Linux: `lsb_release -is` não homologada para esse script, versão: $UBUNTU"
			 echo -e "Pressione <Enter> para finalizar o script"
			read
		fi
else
	 echo -e "Usuário não é ROOT, execute o comando com a opção: sudo -i <Enter> depois digite a senha do usuário `whoami`"
	 echo -e "Pressione <Enter> para finalizar o script"
	read
fi
