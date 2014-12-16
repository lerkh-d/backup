#!/usr/bin/env bash

_duplicity="/usr/bin/duplicity"         				# путь до бинаря дуплисити
SITE_DIR=$1		                				# чо бекапим, получаем из первой переменной
BACKUP_DIR="file:///backup/minecraft"					# указываем диру куда льем файло
EXCLUDE_DIR="/home/minecraft/server/dynmap/web/tiles/world"		# 
mkdir -p /backup/minecraft						# можно лить куда угодно примеры ниже:
				                                        # scp:// или ftp://
# пример FTP реализации
# FTP_PASSWORD=secret duplicity /home/exampleuser ftp://backupuser@backup.example.com/subdirectory

BACKUP_LOG="/backup/backup.log"
BACKUP_DATE=`date`

MAIL_REPORT="/tmp/mail_report.txt"
MAIL_TO="lerhk.d@gmail.com"
MAIL_TITLE="Backup_Report_minecraft_tfc"

# генерируем новый репорт
echo -e "\n=======[${BACKUP_DATE}]========"                             >${MAIL_REPORT}

# echo -e "=======[Cleaning]========\n"                                 >>${MAIL_REPORT}
## Чистим диру, удаляем все к хе.ам  ##
# $_duplicity cleanup --force --no-encryption ${BACKUP_DIR}             >>${MAIL_REPORT}
##

echo -e "\n=======[Rotation if older then 7 day]========\n"             >>${MAIL_REPORT}
## Родируем бекапы если они старше 7 дней ##
$_duplicity remove-older-than 60D --no-encryption ${BACKUP_DIR}         >>${MAIL_REPORT}

echo -e "\n=======[Backup full if older then 7 day]========\n"          >>${MAIL_REPORT}
## Делаем бекапчик ##
$_duplicity --no-encryption --full-if-older-than 7D --exclude "**${EXCLUDE_DIR}/**" ${SITE_DIR} ${BACKUP_DIR} >>${MAIL_REPORT}

echo -e "\n=======[Backup collection-status]========\n"                 >>${MAIL_REPORT}
## Смотрим что у нас есть из бекапов ##
$_duplicity collection-status ${BACKUP_DIR}                     	>>${MAIL_REPORT}

# отправляем рапорт на мыло
cat ${MAIL_REPORT} | mail -s ${MAIL_TITLE} ${MAIL_TO}

# пишем рапорт в лог
cat ${MAIL_REPORT} >> ${BACKUP_LOG}
