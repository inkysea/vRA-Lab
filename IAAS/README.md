# vRA IAAS Lab

This packer project builds and configures a vRA IAAS instance.  There are several builders included in this project.
The builders include desktop and ESX.

**** disclaimer.  This is intended for lab/POC use only.  The installation has not been hardened for an deployment that
 requires "production" like expectations. 

## Prerequisites

Software:

* VMware Fusion, Workstation or Player if building from desktop
* ESX 5.x if building on ESX
* Packer
* Server 2012 R2 license if not using an eval copy
        Add windows license to scripts/autounattend.xml at the following
       
        <ProductKey>
               <Key>XXXX-XXXX-XXXX-XXXX-XXXX</Key>
               <WillShowUI>OnError</WillShowUI>
        </ProductKey>
       
    
## Builders    
    

* Server2012R2
    - Server 2012 build with RDP enabled and includes VMware tools.
    
    Example:
    
    
    ```
    packer build \
           -only=Server2012R2\
           -var 'iso_file=ISO/en_windows_server_2012_r2_x64_dvd_2707946.iso' \
           -var 'iso_sha1sum=B6F063436056510357CB19CB77DB781ED9C11DF3' \
           -var 'vmware_tools_download=http://URL/VMware-tools-8.6.16-3054402-x86_64.exe' \
           -var 'sql_download=http://URL/SQLEXPR_x64_ENU.exe' \
           packer.json    
    ```    
    
   
    
* Server2012R2_gugent
    - Server 2012 build that includes VMware tools and vRA guest agent.
    - Not yet implemented
    
* Server2012R2_core_gugent
    -  Minimal Server2012 core install includes VMware tools and guest agent. 
    - Not yet implemented
     
* vRA IAAS base
    Incudes basic requirements for a vRA IAAS install.  Useful as a base for manually installing vRA IAAS.
    - SQL Express
    - IIS
    - Not yet completed


* vRA_IAAS_LAB and vRA_IAAS_LAB-vSphere
    Includes everything required for a vRA lab. 
    -  SQL Express
    -  IIS
    -  AD server.  domain = corp.local, cloudadmin@corp.local
    -  DNS
    -  vRA IAAS Managment agent :  Disabled for now. Feel free to look at the code!  Requires vRA appliance running.
        
    Example:
    
    
    ```
    packer build \
           -only=vRA_IAAS_lab\
           -var 'iso_file=http://URL/ISO/en_windows_server_2012_r2_x64_dvd_2707946.iso' \
           -var 'iso_sha1sum=B6F063436056510357CB19CB77DB781ED9C11DF3' \
           -var 'vra_iaas_agent_download=https://VRA-URL:5480/installer/vCAC-IaaSManagementAgent-Setup.msi' \
           packer.json
     ```
     
     ```
     packer build \
            -only=vRA_IAAS_lab-vSphere\
            -var 'iso_file=http://URL/ISO/en_windows_server_2012_r2_x64_dvd_2707946.iso' \
            -var 'iso_sha1sum=B6F063436056510357CB19CB77DB781ED9C11DF3' \
            -var 'vra_iaas_agent_download=https://VRA-URL:5480/installer/vCAC-IaaSManagementAgent-Setup.msi' \
            -var 'esx_host=ESX_HOST_IP' \
            -var 'esx_password=xxxxxx' \
            -var 'build_dir=vra_iaas' \
            -var 'esx_datastore=UR_DATASTORE' \
            packer.json
     ```
     
     Note:  The vRA_IAAS_lab-vSphere builder will setup a static IP address for the VM.  To configure the network 
            settings look under scripts/vSphere/  you will find a file named sample-network.txt.  Apply your network 
            settings to this file and rename the file to network.txt
 
    
Note that in all builders the iso_file variable can either be a local file or a URL to the ISO.  For installing 
VMware Tools and SQL Express, the installation is expecting a URL.  I recommend hosting these executables local with a 
repository like Artifactory.
