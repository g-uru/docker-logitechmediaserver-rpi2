#!/bin/sh
set -x
echo "######################################################################################################################################################" >> /storage/Tomato/logs/getlms.log
echo stopping lms.service
systemctl stop lmslog.timer && \
systemctl stop lms && \
sleep 3
#systemctl disable lms
#systemctl disable lmslog.service
#systemctl disable lmslog.timer
/storage/.kodi/addons/service.system.docker/bin/docker stop $(/storage/.kodi/addons/service.system.docker/bin/docker ps -aq);
/storage/.kodi/addons/service.system.docker/bin/docker rm $(/storage/.kodi/addons/service.system.docker/bin/docker ps -aq);
/storage/.kodi/addons/service.system.docker/bin/docker rmi $(/storage/.kodi/addons/service.system.docker/bin/docker images -aq);
/storage/.kodi/addons/service.system.docker/bin/docker system prune -af

cd /storage/.kodi/docker
wget https://github.com/chwba/docker-logitechmediaserver-rpi2/archive/master.zip && unzip master.zip && \
cd docker-logitechmediaserver-rpi2-master

# overwrite service files
#cp -f *.service /storage/.kodi/addons/service.system.docker/examples
#cp -f *.service /storage/.config/system.d/
#cp -f *.timer /storage/.kodi/addons/service.system.docker/examples
#cp -f *.timer /storage/.config/system.d/

echo rebuilding Docker...
/storage/.kodi/addons/service.system.docker/bin/docker build -t logitechmediaserver-rpi2 .

echo restarting services ...
#systemctl enable lms.service
#systemctl enable lmslog.service
#systemctl enable lmslog.timer
systemctl start lms && \
systemctl start lmslog.timer && \


echo "Delete tmpfiles..overwrite .sh-files"
cd /storage/.kodi/docker
cp -f /storage/.kodi/docker/docker-logitechmediaserver-rpi2-master/getlms.sh /storage/.kodi/docker && \
cp -f /storage/.kodi/docker/docker-logitechmediaserver-rpi2-master/lmsup.sh /storage/.kodi/docker && \
chmod +x /storage/.kodi/docker/getlms.sh
chmod +x /storage/.kodi/docker/lmsup.sh
rm -f master.zip
rm -f -r docker-logitechmediaserver-rpi2-master


#echo Waiting 20 Seconds for LMS to finish ...
#sleep 20
#journalctl -u lms
#echo Rebooting in 5 seconds  ...
#sleep 5
echo "rebooting..."
reboot now
echo "######################################################################################################################################################" >> /storage/Tomato/logs/getlms.log

