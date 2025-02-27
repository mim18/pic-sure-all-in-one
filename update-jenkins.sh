#!/bin/bash
./stop-jenkins.sh
git pull
mkdir -p /var/jenkins_home_bak
cp -r /var/jenkins_home/* /var/jenkins_home_bak/
rm -rf /var/jenkins_home/*
cp -r initial-configuration/jenkins/jenkins-docker/jobs /var/jenkins_home/jobs
cp -r initial-configuration/jenkins/jenkins-docker/config.xml /var/jenkins_home/
cp -r initial-configuration/jenkins/jenkins-docker/scriptApproval.xml /var/jenkins_home/
cp -r initial-configuration/jenkins/jenkins-docker/hudson.tasks.Maven.xml /var/jenkins_home/hudson.tasks.Maven.xml

# Pull through previous PICSURE configurations
sed -i "s|__PROJECT_SPECIFIC_OVERRIDE_REPO__|`cat /var/jenkins_home_bak/config.xml | grep -A1 project_specific_override_repo | tail -1 | sed 's/<\/*string>//g' | sed 's/ //g' `|g" /var/jenkins_home/config.xml
sed -i "s|__RELEASE_CONTROL_REPO__|`cat /var/jenkins_home_bak/config.xml | grep -A1 release_control_repo | tail -1 | sed 's/<\/*string>//g' | sed 's/ //g' `|g" /var/jenkins_home/config.xml
sed -i "s|*/master|`cat /var/jenkins_home_bak/config.xml | grep -A1 release_control_branch | tail -1 | sed 's/<\/*string>//g' | sed 's/ //g' `|g" /var/jenkins_home/config.xml


# Pull through previous proxy configurations
cp /var/jenkins_home_bak/setProxy.sh /var/jenkins_home/setProxy.sh

./start-jenkins.sh
