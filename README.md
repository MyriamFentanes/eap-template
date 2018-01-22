# VM-Redhat - JBoss EAP 7 standalone mode
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazure%2Fazure-quickstart-templates%2Fmaster%2Fvsts-tomcat-redhat-vm%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fazure%2Fazure-quickstart-templates%2Fmaster%2Fvsts-tomcat-redhat-vm%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template creates all of the compute resources to run JBoss EAP 7 on top of RHEL 7.2, instantiating the following components:
- RHEL 7.2 VM 
- Public DNS 
- Private Virtual Network 
- Security Configuration 
- JBoss EAP 7
- Sample application deployed to JBoss EAP 7.x

To learn more about JBoss Enterprise Application Platform, check out:
https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/

## Variables description
  - adminUsername: Name of RHEL's administrator user for the VM .
  
  - adminPassword: Password of RHEL's administrator user for the VM. 
  
  - rhsmUserName: Username for the RHN account with entitlements to JBoss EAP that will be used to subcribe the OS.
  
  - rhsmPassword: Password for the RHN account with entitlements to JBoss EAP that will be used to subcribe the OS.
  
  - dnsLabelPrefix: Prefix for the public dns used for the installation.
  
  - eapUserName: Username for the Application Server administrator.
  
  - eapPassword: Password for the Application Server administrator.
  
  - eapProfile: JBoss Enterprise Application Platform profile for the server.
  
  - sshPassPhrase: Passphrase for the ssh key to connect to the server.
  



## Before you Deploy to Azure

To create the VM, you will need to:

1. Choose an admin user name and password for your VM.  
2. Choose a name for your VM. 

3. Choose a EAP user name and password to enable the EAP manager UI and deployment method. 

4. Choose a Pass phrase to use with your SSH certificate.  This pass phrase will be used as the Team Services SSH endpoint passphrase.

## After you Deploy to Azure

Once you create the VM, open a web broser and got to http://<PUBLIC_HOSTNAME>:8080/pollo/ and you should see the applicaiton running

## Notes



