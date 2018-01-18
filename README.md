# VM-Redhat - Team Services Apache 2 Tomcat 7 installation

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazure%2Fazure-quickstart-templates%2Fmaster%2Fvsts-tomcat-redhat-vm%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fazure%2Fazure-quickstart-templates%2Fmaster%2Fvsts-tomcat-redhat-vm%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template allows you to create a RedHat VM running EAP 7 on top of RHEL 7.2 

To learn more about Visual Studio Team Services (VSTS) and Team Foundation Server (TFS) support for Java, check out:
http://java.visualstudio.com/


## Before you Deploy to Azure

To create the VM, you will need to:

1. Choose an admin user name and password for your VM.  
2. Choose a name for your VM. 

3. Choose a EAP user name and password to enable the EAP manager UI and deployment method. 

4. Choose a Pass phrase to use with your SSH certificate.  This pass phrase will be used as the Team Services SSH endpoint passphrase.

## After you Deploy to Azure

Once you create the VM, open a web broser and got to http://<PUBLIC_HOSTNAME>:8080/pollo/ and you should see the applicaiton running 





