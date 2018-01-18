#!/bin/sh

# $1 - VM Host User Name

/bin/date +%H:%M:%S > /home/$1/install.progress.txt
echo "ooooo      REDHAT EAP7 RPM INSTALL      ooooo" >> /home/$1/install.progress.txt

export EAP_HOME="/opt/rh/eap7/root/usr/share/wildfly"
EAP_USER=$2
RHSM_USER=$4
RHSM_PASSWORD=$5 
echo "EAP admin user"+${EAP_USER} >> /home/$1/install.progress.txt
echo "Initial EAP7 setup" >> /home/$1/install.progress.txt
subscription-manager register --username mfentane@redhat.com --password Myr1am84 --auto-attach >> /home/$1/install.progress.txt 2>&1

#Change this for an eval subscription and add a parameter#
echo "Subscribing the system to get access to EAP 7 repos" >> /home/$1/install.progress.txt
# Install Apache2, EAP7 and then build mod-jk package
yum install -y httpd > /home/$1/install.out.txt 2>&1
subscription-manager repos --enable=jb-eap-7-for-rhel-7-server-rpms >> /home/$1/install.out.txt 2>&1
yum-config-manager --disable rhel-7-server-htb-rpms
yum update
echo "Installing EAP7 repos" >> /home/$1/install.progress.txt
yum groupinstall -y jboss-eap7 > /home/$1/install.out.txt 2>&1
echo "Enabling EAP7 service" >> /home/$1/install.progress.txt
systemctl enable eap7-standalone.service
#yum install -y gcc >> /home/$1/install.out.txt 2>&1
#yum install -y gcc-c++ >> /home/$1/install.out.txt 2>&1
yum install -y httpd-devel >> /home/$1/install.out.txt 2>&1
yum install -y git >> /home/$1/install.out.txt 2>&1

cd /home/$1
echo "Getting the sample pollo app to install" >> /home/$1/install.progress.txt
git clone https://github.com/MyriamFentanes/pollo.git >> /home/$1/install.out.txt 2>&1

#Update the permissions on the Tomcat webapps and install directory
#chown -R jboss.jboss $EAP_HOME

echo "Deploying the sample pollo app" >> /home/$1/install.progress.txt
mv /home/$1/pollo/target/pollo $EAP_HOME/standalone/deployments/pollo.war > /home/$1/install.out.txt 2>&1
cat > $EAP_HOME/standalone/deployments/pollo.war.dodeploy

#wget http://archive.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.41-src.tar.gz >> /home/$1/install.out.txt 2>&1
#tar xvfz tomcat-connectors-1.2.41-src.tar.gz >> /home/$1/install.out.txt 2>&1
#cd /home/$1/tomcat-connectors-1.2.41-src/native/
#./configure --with-apxs=/usr/bin/apxs >> /home/$1/install.out.txt 2>&1
#make >> /home/$1/install.out.txt 2>&1
#make install >> /home/$1/install.out.txt 2>&1
#cd /home/$1

echo "Configuring EAP managment user" >> /home/$1/install.progress.txt
$EAP_HOME/bin/add-user.sh -u 'jboss' -p 'r3dh4t1!!' -g 'guest,mgmtgroup'

echo "Start EAP 7" >> /home/$1/install.progress.txt
systemctl start eap7-standalone.service > /home/$1/install.out.txt 2>&1


# Open Red Hat software firewall for port 8080 and 9990:
firewall-cmd --zone=public --add-port=8080/tcp --permanent  >> /home/$1/install.out.txt 2>&1
firewall-cmd --zone=public --add-port=9990/tcp --permanent  >> /home/$1/install.out.txt 2>&1
firewall-cmd --reload  >> /home/$1/install.out.txt 2>&1

echo "Done." >> /home/$1/install.progress.txt
/bin/date +%H:%M:%S >> /home/$1/install.progress.txt


echo "Done." >> /home/$1/install.progress.txt
/bin/date +%H:%M:%S >> /home/$1/install.progress.txt


echo "Configuring SSH" >> /home/$1/install.progress.txt
echo "Done." >> /home/$1/install.progress.txt
/bin/date +%H:%M:%S >> /home/$1/install.progress.txt

# Update SSHd config to not use passwords and set default umask to be 002
cp /etc/ssh/sshd_config /etc/ssh/ORIG_sshd_config
sed -i 's,PasswordAuthentication yes,PasswordAuthentication no,g' /etc/ssh/sshd_config
echo "Match User "$1 >> /etc/ssh/sshd_config
echo "    ForceCommand internal-sftp -u 002" >> /etc/ssh/sshd_config

# Change group of user to same as JBoss
echo "Changing group of user "$1  >> /home/$1/install.out.txt 2>&1
#gpasswd -d $1 $1 >> /home/$1/install.out.txt 2>&1
#gpasswd -a $1 tomcat >> /home/$1/install.out.txt 2>&1
#usermod -g tomcat $1 >> /home/$1/install.out.txt 2>&1


# Configure the default umask for SSH to enable RW for user and group
cp /etc/pam.d/sshd /etc/pam.d/ORIG_sshd
echo "session optional pam_umask.so umask=002" >> /etc/pam.d/sshd

# Then start the SSH daemon:
systemctl daemon-reload >> /home/$1/install.out.txt 2>&1
systemctl start sshd.service >> /home/$1/install.out.txt 2>&1
systemctl enable sshd.service >> /home/$1/install.out.txt 2>&1

# Open Red Hat software firewall for port 22:
firewall-cmd --zone=public --add-port=22/tcp --permanent >> /home/$1/install.out.txt 2>&1
firewall-cmd --reload >> /home/$1/install.out.txt 2>&1

# Create an RSA public and private key for SSH
cd /home/$1
mkdir /home/$1/.ssh
ssh-keygen -q -N $4 -f /home/$1/.ssh/id_rsa >> /home/$1/install.out.txt 2>&1
cd /home/$1/.ssh
cp id_rsa.pub authorized_keys
chown -R $1.tomcat .
chown -R $1.tomcat *
echo "SSH User name:  "$1 > /home/$1/vsts_ssh_info
echo "SSH passphrase: "$4 >> /home/$1/vsts_ssh_info
echo "SSH Private key:" >> /home/$1/vsts_ssh_info
cat id_rsa >> /home/$1/vsts_ssh_info
chown $1.tomcat /home/$1/vsts_ssh_info


# Configure SELinux to use Linux ACL's for file protection
setsebool -P allow_ftpd_full_access 1 >> /home/$1/install.out.txt 2>&1

# Seeing a race condition timing error so sleep to deplay
sleep 20

echo "ALL DONE!" >> /home/$1/install.progress.txt
/bin/date +%H:%M:%S >> /home/$1/install.progress.txt


chown $1.jboss /home/$1/install.progress.txt
chown $1.jboss /home/$1/install.out.txt

