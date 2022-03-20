#!/bin/bash
set -x
echo  Strapi process initiated $(date) > /tmp/strapi-init.log
exec &> /tmp/userdata.log
export ENV=%ENV%
export NAME=%NAME%
export vpcendpoint=%VPCE%
rm -rf  /home/jenkins/strapi/
mkdir -p /home/jenkins/strapi/strapi-${ENV}/
cd /home/jenkins/strapi/strapi-${ENV}/
aws s3 --endpoint-url ${vpcendpoint} cp s3://${NAME}-${ENV}-strapi/artifacts/strapi/latest/strapi-${ENV}.zip .
unzip -qo strapi-${ENV}.zip
rm -f strapi-${ENV}.zip
chown -R  jenkins:jenkins /home/jenkins/strapi
sed -i "s/dev/$ENV/g" /etc/nginx/nginx.conf
sed -i "s/agrim/$NAME/g" /etc/nginx/nginx.conf
service nginx restart
su jenkins -c "yarn install"
su jenkins -c "yarn build"
su jenkins -c "pm2 stop all && echo Stopped the process. || echo Process already stopped."
su jenkins -c "pm2 delete all && echo Delete the process. || echo Process already deleted."
su jenkins -c "pm2 start npm --name strapi-${ENV} -- run develop"
su jenkins -c "pm2 save"
