#!/bin/sh

# $1 - VM Host User Name

/bin/date +%H:%M:%S > /home/$1/install.progress.txt
echo "ooooo      REDHAT EAP7 RPM INSTALL      ooooo" >> /home/$1/install.progress.txt

export EAP_HOME="/opt/rh/eap7/root/usr/share/wildfly"
EAP_USER=$2
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

echo "Deploying the sample pollo app" >> /home/$1/install.progress.txt
mv /home/$1/pollo/target/pollo $EAP_HOME/standalone/deployments/pollo.war > /home/$1/install.out.txt 2>&1

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



# Create a mod_jk config file
#echo "# Load mod_jk module" > /etc/httpd/conf/mod_jk.conf
#echo "# Specify the filename of the mod_jk lib" >> /etc/httpd/conf/mod_jk.conf
#echo "LoadModule jk_module modules/mod_jk.so" >> /etc/httpd/conf/mod_jk.conf
#echo "# Where to find workers.properties" >> /etc/httpd/conf/mod_jk.conf
#echo "JkWorkersFile conf/workers.properties" >> /etc/httpd/conf/mod_jk.conf
#echo "# Where to put jk logs" >> /etc/httpd/conf/mod_jk.conf
#echo "JkLogFile /var/log/httpd/mod_jk.log" >> /etc/httpd/conf/mod_jk.conf
#echo "# Set the jk log level [debug/error/info]" >> /etc/httpd/conf/mod_jk.conf
#echo "JkLogLevel info" >> /etc/httpd/conf/mod_jk.conf
#echo "# Select the log format" >> /etc/httpd/conf/mod_jk.conf
#echo "JkLogStampFormat \"[%a %b %d %H:%M:%S %Y]\"" >> /etc/httpd/conf/mod_jk.conf
#echo "# JkOptions indicates to send SSK KEY SIZE" >> /etc/httpd/conf/mod_jk.conf
#echo "JkOptions +ForwardKeySize +ForwardURICompat -ForwardDirectories" >> /etc/httpd/conf/mod_jk.conf
#echo "# JkRequestLogFormat" >> /etc/httpd/conf/mod_jk.conf
#echo "JkRequestLogFormat \"%w %V %T\"" >> /etc/httpd/conf/mod_jk.conf
#echo "# Mount your applications" >> /etc/httpd/conf/mod_jk.conf
#echo "JkMount /* worker1" >> /etc/httpd/conf/mod_jk.conf
#echo "JkShmFile /var/run/mod_jk/jk-runtime-status" >> /etc/httpd/conf/mod_jk.conf

# Create mod_jk workers file
#echo "# Define 1 real worker using ajp13" > /etc/httpd/conf/workers.properties
#echo "worker.list=worker1" >> /etc/httpd/conf/workers.properties
#echo "worker.worker1.type=ajp13" >> /etc/httpd/conf/workers.properties
#echo "worker.worker1.host=localhost" >> /etc/httpd/conf/workers.properties
#echo "worker.worker1.port=8009" >> /etc/httpd/conf/workers.properties
#echo "worker.worker1.socket_keepalive=true" >> /etc/httpd/conf/workers.properties
#echo "worker.worker1.lbfactor=1" >> /etc/httpd/conf/workers.properties
#echo "worker.worker1.connection_pool_size=50" >> /etc/httpd/conf/workers.properties
#echo "worker.worker1.connect_timeout=5000" >> /etc/httpd/conf/workers.properties
#echo "worker.worker1.prepost_timeout=5000" >> /etc/httpd/conf/workers.properties

# Update httpd conf file with server name and mod_jk config file name
#cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/ORIG_httpd.conf
#sed -i 's,#ServerName,ServerName,g' /etc/httpd/conf/httpd.conf
#sed -i "s,www.example.com:80,`hostname`:80,g" /etc/httpd/conf/httpd.conf
#echo "# Include mod_jk's specific configuration file" >> /etc/httpd/conf/httpd.conf
#echo "Include conf/mod_jk.conf" >> /etc/httpd/conf/httpd.conf

# Update the server.xml file to specify the mod_jk worker
#cp /usr/share/tomcat/conf/server.xml /usr/share/tomcat/conf/ORIG_server.xml
#sed -i 's,"localhost">,"localhost" jvmRoute="worker1">,g' /usr/share/tomcat/conf/server.xml

# Update the permissions on the Tomcat webapps and install directory
#chown -R tomcat.tomcat /var/lib/tomcat/webapps
#chown tomcat.tomcat /usr/share/tomcat
#chown tomcat.tomcat /var/lib/tomcat

# Set the default umask for Tomcat
#cp /usr/libexec/tomcat/server /usr/libexec/tomcat/ORIG_server
#sed -i 's,run start,umask 002\n  run start,g' /usr/libexec/tomcat/server
#systemctl daemon-reload >> /home/$1/install.out.txt 2>&1

# Configure SELinux to allow mod_jk to work
#yum install -y policycoreutils-python >> /home/$1/install.out.txt 2>&1
#mkdir /var/run/mod_jk
#/usr/sbin/semanage fcontext -a -t httpd_var_run_t "/var/run/mod_jk(/.*)?" >> /home/$1/install.out.txt 2>&1

# Remove unnecessary http modules that create warnings
#cp /etc/httpd/conf.modules.d/00-proxy.conf /etc/httpd/conf.modules.d/ORIG_00-proxy.conf
#sed -i 's,LoadModule lbmethod_heartbeat,# LoadModule lbmethod_heartbeat,g' /etc/httpd/conf.modules.d/00-proxy.conf

#Configure the system to run httpd and tomcat every time the server is booted:
#systemctl enable httpd  >> /home/$1/install.out.txt 2>&1

# Restart the Tomcat7 and Apache2 servers:
#service httpd start  >> /home/$1/install.out.txt 2>&1

# Open Red Hat software firewall for port 80:
firewall-cmd --zone=public --add-port=80/tcp --permanent  >> /home/$1/install.out.txt 2>&1
firewall-cmd --reload  >> /home/$1/install.out.txt 2>&1

echo "Done." >> /home/$1/install.progress.txt
/bin/date +%H:%M:%S >> /home/$1/install.progress.txt


# mv /etc/tomcat/tomcat-users.xml /etc/tomcat/ORIG_tomcat-users.xml
# echo "<?xml version='1.0' encoding='utf-8'?>" > /tmp/tomcat-users.xml
# echo "<tomcat-users>" >> /tmp/tomcat-users.xml
# echo "<role rolename=\"tomcat\"/>" >> /tmp/tomcat-users.xml
# echo "<role rolename=\"manager-script\"/>" >> /tmp/tomcat-users.xml
# echo "<role rolename=\"manager-gui\"/>" >> /tmp/tomcat-users.xml
# echo "<role rolename=\"manager\"/>" >> /tmp/tomcat-users.xml
# echo "<role rolename=\"admin-gui\"/>" >> /tmp/tomcat-users.xml
# echo "<user username=\"tomcat\" password=\"tomcat\" roles=\"tomcat\"/>" >> /tmp/tomcat-users.xml
# echo "<user username=\"$2\" password=\"$3\" roles=\"tomcat,manager-script,manager-gui,admin-gui\"/>" >> /tmp/tomcat-users.xml
# echo "</tomcat-users>" >> /tmp/tomcat-users.xml
# mv /tmp/tomcat-users.xml /etc/tomcat
# chown root.tomcat /etc/tomcat/tomcat-users.xml 
# chmod 0640 /etc/tomcat/tomcat-users.xml

# Restart httpd and tomcat servers
# service tomcat restart >> /home/$1/install.out.txt 2>&1
#service httpd restart >> /home/$1/install.out.txt 2>&1

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

# Change group of user to same as Tomcat
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

# Open the ftp ports on the Red Hat software firewall:
firewall-cmd --zone=public --add-port=21/tcp --permanent >> /home/$1/install.out.txt 2>&1
firewall-cmd --zone=public --add-port=13450/tcp --permanent >> /home/$1/install.out.txt 2>&1
firewall-cmd --zone=public --add-port=13451/tcp --permanent >> /home/$1/install.out.txt 2>&1
firewall-cmd --zone=public --add-port=13452/tcp --permanent >> /home/$1/install.out.txt 2>&1
firewall-cmd --zone=public --add-port=13453/tcp --permanent >> /home/$1/install.out.txt 2>&1
firewall-cmd --zone=public --add-port=13454/tcp --permanent >> /home/$1/install.out.txt 2>&1
firewall-cmd --reload >> /home/$1/install.out.txt 2>&1

# Seeing a race condition timing error so sleep to deplay
sleep 20

# Restart the ftp service:
echo "Restart vsftp" >> /home/$1/install.out.txt 2>&1
#service vsftpd restart >> /home/$1/install.out.txt 2>&1
#systemctl enable vsftpd >> /home/$1/install.out.txt 2>&1

echo "ALL DONE!" >> /home/$1/install.progress.txt
/bin/date +%H:%M:%S >> /home/$1/install.progress.txt

echo "These original files were saved in case you want to return to default settings:" >> /home/$1/install.progress.txt
find /etc -name ORIG_* -print >> /home/$1/install.progress.txt
find /usr/share/tomcat/conf -name ORIG_* -print >> /home/$1/install.progress.txt
find /usr/libexec/tomcat -name ORIG_* -print >> /home/$1/install.progress.txt


chown $1.jboss /home/$1/install.progress.txt
chown $1.jboss /home/$1/install.out.txt

