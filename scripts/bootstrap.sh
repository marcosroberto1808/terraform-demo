#!/bin/bash

# Install Nginx
amazon-linux-extras install nginx1
sudo systemctl enable nginx && sudo systemctl start nginx

# Back up existing config
mv /etc/nginx /etc/nginx-backup

# Download the configuration from S3
aws s3 cp s3://{my_bucket}/nginxconfig.io-example.com.zip /tmp

# Install new configuration
unzip /tmp/nginxconfig.io-example.com.zip -d /etc/nginx


#!/bin/sh
#update the instance packages
yum update -y
#install java 8
yum install -y java-1.8.0
# install jq to parsing aws cli commands
yum install jq -y
# #download the executable jar package in app/ dir
mkdir app
cd app/
#getting region
AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r ".region")
curl -O https://s3.amazonaws.com/ee-assets-prod-us-east-1/modules/dbae6ed44c544fa5bfb22c7962c7017f/v1/scripts/monolithic-java-webapp.jar
#setting variables from secrets manager
SECRET_NAME=$(aws secretsmanager list-secrets --query 'SecretList[?starts_with(Name, `Lab1Legacy`) == `true`].{Name:Name}' --output text --region ${AWS_REGION})
json=$(aws secretsmanager get-secret-value --secret-id ${SECRET_NAME} --region $AWS_REGION | jq --raw-output .SecretString)
$(jq -r 'to_entries | map("export "+.key + "=" + (.value | tostring)) | .[]' <<<"$json")
# starting the application
java -jar /app/monolithic-java-webapp.jar --rds.dbinstance.host=jdbc:mysql://${host}:3306/${dbname} --rds.dbinstance.username=${username} --rds.dbinstance.password=${password}



#!/bin/sh
#update the instance packages
yum update -y
#install java 8
yum install -y java-1.8.0
# install jq to parsing aws cli commands
yum install jq -y
# #download the executable jar package in app/ dir
mkdir app
cd app/
#getting region
AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r ".region")
curl -O https://s3.amazonaws.com/ee-assets-prod-us-east-1/modules/dbae6ed44c544fa5bfb22c7962c7017f/v1/scripts/monolithic-java-webapp.jar
#setting variables from secrets manager
SECRET_NAME=$(aws secretsmanager list-secrets --query 'SecretList[?starts_with(Name, `Lab1Legacy`) == `true`].{Name:Name}' --output text --region ${AWS_REGION})
json=$(aws secretsmanager get-secret-value --secret-id ${SECRET_NAME} --region $AWS_REGION | jq --raw-output .SecretString)
$(jq -r 'to_entries | map("export "+.key + "=" + (.value | tostring)) | .[]' <<<"$json")
# starting the application
java -jar /app/monolithic-java-webapp.jar --rds.dbinstance.host=jdbc:mysql://${host}:3306/${dbname} --rds.dbinstance.username=${username} --rds.dbinstance.password=${password}