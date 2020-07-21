# NSX-T Distributed IDS/IPS Proof of Value Lab

## Table of Contents

* [Description](#description)
* [Changelog](#changelog)
* [Requirements](#requirements)
* [FAQ](#faq)
* [Configuration](#configuration)
* [Logging](#logging)
* [Sample Execution](#sample-execution)
    * [Lab Deployment Script](#lab-deployment-script)

## Description
The goal of this Proof of Value (PoV) is to allow customers to get hands-on experience with the NSX Distributed IDS/IPS. The expectation from people participating in the PoC is that they will complete the exercises outline in this guide in order to become familair with the key capabilities offered by the NSX Distributed IDS/IPS. While not the focus of this PoV guide, particpants will also gain basic experience with the Distributed Firewall and other NSX capabilities during this PoV process. 

While this PoV guide is quite prescriptive, participants can choose to modify any part of the workflow as desired. The guide is primarily focused on getting customers familiar with IDS, hence the deployment of the lab environment and rest of the configuration is automated through the use of a provided PowerShell script. After meeting the-requisites and running the script, a fully configured nested NSX-T environment is available to particpants, including a number of attacker and victim workload which are used as part of the IDS/IPS exercises. 

This script makes it very easy for anyone to deploy a nested vSphere vSphere lab environment for learning and educational purposes. All required VMware components (ESXi, vCenter Server, NSX Unified Appliance and Edge) are automatically deployed, attacker and multiple victim workloads are deplyed, and NSX-T networking configuration is applied in order to anyone to start testing the NSX Distributed IDS/IPS as soon as the deploment is completed. 

Below is a diagram of what is deployed as part of the solution and you simply need to have an existing vSphere environment running that is managed by vCenter Server and with enough resources (CPU, Memory and Storage) to deploy this "Nested" lab

![](Images/IDPS_POC_1.PNG)
* Gray: Pre-requisites (Physical ESXi Server, vCenter managing the server and a Port group to provide connectivity of nested lab environment
* Blue: Management and Edge Components (vCenter, NSX Manager and NSX Edge) Deployed by PowerCLI Script
* Red: External VM running Metasploit and other functions deployed by PowerCLI Script on Physical Environment vCenter 
* Yellow: Nested ESXi hypevisors deployed by PowerCLI Script and managed by nested vCenter
* Purple: vSAN datastore across 3 nested ESXi hypervisors configured by PowerCLI Script
* Green: NSX Overlay DMZ Segment and vulnerable Web-VMs connected to it. Segment created and VMs deployed by PowerCLI Script.
* Orange: NSX Overlay Internal Segment and vulnerable App-VMs connected to it. Segment created and VMs deployed by PowerCLI Script.

## Disclaimer
This lab provides and leverages common pen-test tools including Metasploit as well as purposfully vulnerable workloads built using Vulhub (https://github.com/vulhub/vulhub) . Please only use these tools for the intended purpose of completing the PoC, isolate the lab enviornment properly from any other environment and discard when the PoC has been completed.

## Changelog

* **07/8/2020**
  * Intial partial draft of the guide

## Requirements
* vCenter Server running at least vSphere 6.7 or later
    * If your physical storage is vSAN, please ensure you've applied the following setting as mentioned [here](https://www.virtuallyghetto.com/2013/11/how-to-run-nested-esxi-on-top-of-vsan.html)
* Resource Requirements
    * Compute
        * Single Physical host running at least vSphere 6.7 or later
        * Ability to provision VMs with up to 8 vCPU
        * Ability to provision up to 64 GB of memory
    * Network
        * Single pre-configured Standard or Distributed Portgroup (Management VLAN) used to deploy all VMs In the example config, VLAN-194 is used as this isngle port-group
            * 8 x IP Addresses for VCSA, ESXi, NSX-T Manager, Edge VM Management, Edge VM Uplink and External VM
            * 4 x IP Addresses for TEP (Tunnel Endpoint) interfaces on ESXi and Edge VM
            * 1 x IP Address for T0 Static Route (optional)
            * All IP Addresses should be able to communicate with each other. These can all be in the same subnet (/27). In the example configuration provided the 10.114.209.128/27 subnet is used for all these IP addresses/interfaces: vCenter, NSX Manager Managenet Interface, T0 Router Uplink, Nested ESXi VMKernel and TEP interfaces (defined in IP pool), External VM.
    * Storage
        * Ability to provision up to 1TB of storage

* Preferrably, the deployed NSX Manager should have Internet access in order to download the lastest set of IDS/IPS signatures.
* Desktop (Windows, Mac or Linux) with latest PowerShell Core and PowerCLI 12.0 Core installed. See [ instructions here](https://blogs.vmware.com/PowerCLI/2018/03/installing-powercli-10-0-0-macos.html) for more details
* vSphere 7 & NSX-T OVAs:
    * [vCenter Server Appliance 7.0.0B] (https://my.vmware.com/group/vmware/downloads/details?downloadGroup=VC700B&productId=974&rPId=47905)
    * [NSX-T Manager 3.0.1 OVA](https://my.vmware.com/group/vmware/downloads/details?downloadGroup=NSX-T-301&productId=982&rPId=48086)
    * [NSX-T Edge 3.0.1 for ESXi OVA]((https://my.vmware.com/group/vmware/downloads/details?downloadGroup=NSX-T-301&productId=982&rPId=48086)
    * [Nested ESXi 7.0 OVA - Build 15344619](https://download3.vmware.com/software/vmw-tools/nested-esxi/Nested_ESXi7.0_Appliance_Template_v1.ova)
    
Note: if you are not entitled or not able to access the above links, you can download a free trial and obtain a license for all of the above through https://www.vmware.com/try-vmware.html 

## Intended Audience
This PoV guide is intended for existing and future NSX customers who want to evaluate the NSX Distributed IDS/IPS functionality. Ideally, this PoC involves people covring these roles:

* CISO Representative
* Data Center Infrastructure Team
* Network Architects
* Security Architects
* Security Operations Center Analyst
* Enterprise Applicatoin Owner

## Resources commitment and suggsted timeline
The expected time commitment to complete the PoV process is about 5 hours. This includes the time it takes for the automated deployment of the nested lab environment. We suggest to split up this time across 2 week. The below table provides an estimate of the time it takes to complete each task:

| Task  | Estimated Time to Complete | Suggested Week | 
| ------------- | ------------- | ------------- |
| Customize Deployment Script Variables  | 30 minutes  | Week 1 | 
| Run Deployment Script  | 90 minutes | Week 1 | 
| Verify Lab Deployment  | 30 minutes | Week 1 | 
| Initial IDS/IPS Configuration  | 30 minutes | Week 1 | 
| Simple Attack Scenario | 30 minutes | Week 2 | 
| Lateral Attack Scenario | 30 minutes | Week 2 | 
| Advanced Attack and configuration tuning | 30 minutes | Week 2 | 
| Apply micro-segmentation to limit the attack surface | 30 minutes | Week 2 | 

## Support during the PoV Process

Existing NSX customers should reach out to their account team for support during the PoV process, or to the NSX PoV lead that has been assigend to the customer. In additon, any participant can reach out to x@vmware.com for support during the PoV.

## Customize Deployment Script Variables
**Estimated Time to Complete: 60 minutes**

Before you can run the script, you will need to edit the script and update a number of variables to match your deployment environment. Details on each section is described below including actual values used my sample lab environment. The variables that need to adjusted are called out specifically. Other variables can in almost all cases be left to their default values.

In this example below, I will be using a single /27 subnet(10.114.209.128/27)  on a single port-group (VLAN-194) which all the VMs provisioned by the automation script will be connected to. It is expected that you will have a similar configuration which is the most basic configuration for PoV and testing purposes.

| Name                       | IP Address                     | Function                     |
|----------------------------|--------------------------------|------------------------------|
| pov-vcsa                   | 10.114.209.143                 | vCenter Server               |
| Nested_ESXi_1              | 10.114.209.140                 | ESXi                         |
| Nested_ESXi_2              | 10.114.209.142                 | ESXi                         |
| Nested_ESXi_3              | 10.114.209.143                 | ESXi                         |
| pov-nsx                    | 10.114.209.149                 | NSX-T Manager                |
| pov-nsx-edge               | 10.114.209.150                 | NSX-T Edge                   |
| T0-uplink                  | 10.114.209.148                 | T0 GW Interface IP           |
| TunnelEndpointGateway      | 10.114.209.129                 | Existing default GW          |
| T0 Static Default GW       | 10.114.209.129                 | Existing default GW          |
| TEP Pool                   | 10.114.209.144-10.114.209.147  | Tunnel Endpoint IPs          |
| External VM                | 10.114.209.151                 | Attacker (Metasploit) VM     |


This section describes the credentials to your physical environment vCenter Server in which the nested lab environment will be deployed to. Make sure to adjust **all** of the below variables to match your physical environment vCenter:
```console
$VIServer  = "vcenter-north.lab.svanveer.pa"
$VIUsername = "administrator@vsphere.local"
$VIPassword = "VMware1!"
```

This section describes the location of the files required for deployment. Update the below variables with the actual **location of the downloaded OVAs/extracted files** on the local machine you run this PowerShell script from

```console
$NestedESXiApplianceOVA = "C:\Users\stijn\downloads\ESXI\Nested_ESXi7.0_Appliance_Template_v1.ova"
$VCSAInstallerPath = "C:\Users\stijn\downloads\VCSA\VMware-VCSA-all-7.0.0-16189094"
$NSXTManagerOVA = "C:\Users\stijn\downloads\NSXMgr\nsx-unified-appliance-3.0.0.0.0.15946739.ova"
$NSXTEdgeOVA = "C:\Users\stijn\downloads\NSXEdge\nsx-edge-3.0.0.0.0.15946012.ova"
```
**Note:** The path to the VCSA Installer must be the extracted contents of the ISO


This section defines the number of Nested ESXi VMs to deploy along with their associated IP Address(s). The names are merely the display name of the VMs when deployed. At a minimum, you should deploy at least three hosts, but you can always add additional hosts and the script will automatically take care of provisioning them correctly. Adjust the **IP addresses** for the 3 below hosts. For simplicity, these IP addresses should part of the same Management subnet for the nested vCenter and NSX Manager. 
```console
$NestedESXiHostnameToIPs = @{
    "Nested_ESXi_1" = "10.114.209.140" 
    "Nested_ESXi_2" = "10.114.209.141" 
    "Nested_ESXi_3" = "10.114.209.142" 
}
```

This section describes the resources allocated to each of the Nested ESXi VM(s). Depending on your usage, you may need to increase the resources. For Memory and Disk configuration, the unit is in GB. The values set are the minimum required for this lab. **Default values are sufficient.**
```console
$NestedESXivCPU = "4"
$NestedESXivMEM = "12" #GB
$NestedESXiCachingvDisk = "8" #GB
$NestedESXiCapacityvDisk = "100" #GB
```

This section describes the VCSA deployment configuration such as the VCSA deployment size, Networking & SSO configurations. If you have ever used the VCSA CLI Installer, these options should look familiar. Adjust the **IP address** and **Prefix (Subnet Mask Bits)** to match the desired IP address of the nested ESXi. Use the Same IP address as the hostname, unless you can add an FQDN entry to your DSN server. 
```console
$VCSADeploymentSize = "tiny"
$VCSADisplayName = "pov-vcsa"
$VCSAIPAddress = "10.114.209.143" 
$VCSAHostname = "10.114.209.143" #Use IP if you don't have valid DNS. 
$VCSAPrefix = "27"
$VCSASSODomainName = "vsphere.local"
$VCSASSOPassword = "VMware1!"
$VCSARootPassword = "VMware1!"
$VCSASSHEnable = "true"
```

This section describes the location as well as the generic networking settings applied to Nested ESXi VCSA & NSX VMs. The following variable should be defined by users **VMDataceter**, **VMCluster**, **VMNetwork** and **VMdatastore**. Replace all the **IP addresses** and **netmaks** with the appropriate IP addresses/netmask. 
```console
$VMDatacenter = "PaloAlto-Main"
$VMCluster = "Physical-3"
$VMNetwork = "VLAN-194"
$VMDatastore = "NFS"
$VMNetmask = "255.255.255.224"
$VMGateway = "10.114.209.129"
$VMDNS = "10.114.222.70"
$VMNTP = "10.20.145.1"
$VMPassword = "VMware1!"
$VMDomain = "lab.svanveer.pa"
$VMSyslog = "10.114.222.70" # This should be the same IP address as the External VM IP address
$VMFolder = "NSX PoV"

# Applicable to Nested ESXi only
$VMSSH = "true"
$VMVMFS = "false"
```

This section describes the configuration of the new lab vCenter Server from the deployed VCSA. **Default values are sufficient.**
```console
$NewVCDatacenterName = "PoV-Datacenter"
$NewVCVSANClusterName = "Workload-Cluster"
$NewVCVDSName = "PoV-VDS"
$NewVCDVPGName = "DVPG-Management Network"
```

This section describes the PoV Configurations. **Default values are sufficient.**
```console
# PoV Configuration
$StoragePolicyName = "PoV-gold-storage-policy"
$StoragePolicyTagCategory = "PoV-demo-tag-category"
$StoragePolicyTagName = "PoV-demo-storage"
$DevOpsUsername = "devops"
$DevOpsPassword = "VMware1!"
```

This section describes the NSX-T configurations, the following variables must be defined by users and the rest can be left as defaults.
    **$NSXLicenseKey**, **$NSXVTEPNetwork**, **$T0GatewayInterfaceAddress**, **$T0GatewayInterfaceStaticRouteAddress** and the **NSX-T Manager**, **TEP IP Pool** and **Edge** Sections
```console
# NSX-T Configuration
NSXLicenseKey = "xxxxx-xxxxx-xxxxx-xxxxx-xxxxx" #Replace with valid NSX License key
$NSXRootPassword = "VMware1!VMware1!"
$NSXAdminUsername = "admin"
$NSXAdminPassword = "VMware1!VMware1!"
$NSXAuditUsername = "audit"
$NSXAuditPassword = "VMware1!VMware1!"
$NSXSSHEnable = "true"
$NSXEnableRootLogin = "true"
$NSXVTEPNetwork = "VLAN-194" # Replace with the appropriate pre-existing port-group 

# Transport Node Profile
$TransportNodeProfileName = "PoV-Transport-Node-Profile"

# TEP IP Pool  - Replace IP addresses to match the physical environment subnet you've allocated (i.e management network) 
$TunnelEndpointName = "TEP-IP-Pool"
$TunnelEndpointDescription = "Tunnel Endpoint for Transport Nodes"
$TunnelEndpointIPRangeStart = "10.114.209.144" 
$TunnelEndpointIPRangeEnd = "10.114.209.147"
$TunnelEndpointCIDR = "10.114.209.128/27" 
$TunnelEndpointGateway = "10.114.209.129 #Default Gateway of the Management Network

# Transport Zones - Default Values are sufficient
$OverlayTransportZoneName = "TZ-Overlay"
$OverlayTransportZoneHostSwitchName = "nsxswitch"
$VlanTransportZoneName = "TZ-VLAN"
$VlanTransportZoneNameHostSwitchName = "edgeswitch"

# Network Segment - Default Values are sufficient
$NetworkSegmentName = "PoV-Segment"
$NetworkSegmentVlan = "0"

# T0 Gateway
$T0GatewayName = "PoV-T0-Gateway"
$T0GatewayInterfaceAddress = "10.114.209.148" # should be a routable address
$T0GatewayInterfacePrefix = "27"
$T0GatewayInterfaceStaticRouteName = "PoV-Static-Route"
$T0GatewayInterfaceStaticRouteNetwork = "0.0.0.0/0"
$T0GatewayInterfaceStaticRouteAddress = "10.114.209.129" # This can be set to an invalid IP address to ensure the vulnerable workloads remain isolated from the rest of the environment

# Uplink Profiles  - Default Values are sufficient
$ESXiUplinkProfileName = "ESXi-Host-Uplink-Profile"
$ESXiUplinkProfilePolicy = "FAILOVER_ORDER"
$ESXiUplinkName = "uplink1"

$EdgeUplinkProfileName = "Edge-Uplink-Profile"
$EdgeUplinkProfilePolicy = "FAILOVER_ORDER"
$EdgeOverlayUplinkName = "uplink1"
$EdgeOverlayUplinkProfileActivepNIC = "fp-eth1"
$EdgeUplinkName = "tep-uplink"
$EdgeUplinkProfileActivepNIC = "fp-eth2"
$EdgeUplinkProfileTransportVLAN = "0" # Do not changes this VLAN
$EdgeUplinkProfileMTU = "1600"

# Edge Cluster  - Default Values are sufficient
$EdgeClusterName = "Edge-Cluster-01"

# NSX-T Manager Configurations 
# NSX-T Manager Configurations
$NSXTMgrDeploymentSize = "small"
$NSXTMgrvCPU = "6" #override default size
$NSXTMgrvMEM = "24" #override default size
$NSXTMgrDisplayName = "pov-nsx-manager"
$NSXTMgrHostname = "10.114.209.149" # Replace with the desired IP address for the NSX Manager
$NSXTMgrIPAddress = "10.114.209.149" # Replace with the desired IP address for the NSX Manager

# NSX-T Edge Configuration
$NSXTEdgeDeploymentSize = "medium"
$NSXTEdgevCPU = "8" #override default size
$NSXTEdgevMEM = "32" #override default size
$NSXTEdgeHostnameToIPs = @{
    "pov-nsx-edge" = "10.114.209.150" #Replace with the desired IP address for the NSX Edge Management Interface
}
```

## Run Deployment Scrip
**Estimated Time to Complete: 60 minutes**
Once you have saved your changes, you can now run the PowerCLI script as you normally would.

Here is a screenshot of running the script if all basic pre-reqs have been  met and the confirmation message before starting the deployment:
[INSERT SCREENSHOT OF SCRIPT EXECUTION]

Here is an example output of a complete deployment:

[INSERT SCREENSHOT OF SCRIPT COMPLETION]

**Note:** Deployment time will vary based on underlying physical infrastructure resources. On average, it can take between 45 minutes to 90 minutes. 

## Verify Lab Deployment
**Estimated Time to Complete: 30 minutes**

Once the Deployment Script has completed the installation and setup process. Your lab environment is fully ready to start testing the NSX Distributed IDS/IPS. Verify vCenter and NSX has been configured as intended.

**Physical Infrastructure Host/vCenter**: Login to the physial environment vcenter and Verify 6 VMs have been deployed, are up and running and are connected to the appropriate port-group: 
* 3 nested ESXI
* 1 NSX Manager
* 1 NSX Edge 
* 1 vCenter

![](Images/IDPS_POC_2.PNG)

**Lab vCenter**: Login to lab vCenter and verify the cluster of 3 nested ESXi appliances is functional and 4 vulnerable VMs have been deployed on the cluster:
* APP-1-WEB-TIER connected to **DMZSegment** Portgroup
* APP-2-WEB-TIER connected to **DMZSegment** Portgroup
* APP-1-APP-TIER connected to **InternalSegment** Portgroup
* APP-2-APP-TIER connected to **InternalSegment** Portgroup

![](Images/IDPS_POC_4.PNG)

[TO BE COMPLETED]

## Initial IDS/IPS Configuration
**Estimated Time to Complete: 30 minutes**

Now that we have verified the lab has been deployed correctly, basic NSX networking configuration has been applied and the appropriate vunlerable application VMs have been deployed, we can configure the NSX Distributed IDS/IPS.

**Create Groups**
1.	In the NSX Manager UI, navigate to Inventory -->  Groups 
2. Click **ADD GROUP**
3.	Create a Group with the below parameters. Click Save when done.
    * Name **Production Applications**
    * Compute Members: Membership Criteria: **Virtual Machine Tag Equals Production Scope Environment**
    ![](Images/IDPS_POC_7.PNG)     
3.	Create another Group with the below parameters. Click Save when done.
    * Name **Development Applications**
    * Compute Members: Membership Criteria: **Virtual Machine Tag Equals Development Scope Environment**
    ![](Images/IDPS_POC_8.PNG)    
4. Confirm previously deployed VMs became a member of appropriate groups due to applied tags. Click **View Members** for the 2 groups you created and confirm
    * Members of **Development Applications**: **APP-2-APP-TIER**, **APP-2-WEB-TIER**
    * Members of **Production Applications**: **APP-1-APP-TIER**, **APP-1-WEB-TIER**
    ![](Images/IDPS_POC_9.PNG)    
    
> Note: Tags were applied to the workloads through the Powershell script used to deploy the lab environment.

**Enable Intrusion Detection**
1.	In the NSX Manager UI, navigate to Security -->  Distributed IDS --> Settings
2.	Under Enable Intrusion Detection for Cluster(s), set **Workload-Cluster** to Enabled

![](Images/IDPS_POC_5.PNG)

NSX can automatically update it’s IDS signatures by checking our cloud-based service. By default, NSX manager will check once per day and we publish new signature update versions every two week (with additional non-scheduled 0-day updates). NSX can also be configured to optionally automatically apply newly updated signatures to all hosts that have IDS enabled.

**Enable Automated Signature Update propagation**
1.	Under Intrusion Detection Signatures, select **Auto Update new versions (recommended)** in order to propagate the latest signature updates from the cloud to the distributed IDS instances
2.	Optionally, click **View and Change Versions** and expand one of the signature sets to see what signatures have been added/updated/disabled in this particular release 
3.	Note: if a proxy server is configured for NSX Manager to access the internet, click Proxy Settings and complete the configuration


**Create IDS Profiles**
1.	In the NSX Manager UI, navigate to Security -->  Distributed IDS --> Profiles
2. Click **ADD IDS PROFILE**
3.	Create an IDS Profile with the below parameters. Click Save when done.
    * Name **Production**
    * Signatures to Include: **Critical**, **High**, **Medium**
3.	Create another IDS Profile with the below parameters. Click Save when done.
    * Name **Development**
    * Signatures to Include: **Critical**, **High**

![](Images/IDPS_POC_6.PNG)

**Create IDS Rules**
1.	In the NSX Manager UI, navigate to Security -->  Distributed IDS --> Rules
2. Click **ADD POLICY**
3.	Create an IDS Policy named **NSX PoV** .
4. Check the checkbox for the policy you just created and click **ADD RULE**.
5. Add an IDS Rule with the following parameters
    * Name **Production Applications IDS Policy**
    * IDS Profile **Production**
    * Applied to **Production Applicatons** (group)
    * Leave other settings to defaults
6. Add another IDS Rule with the following parameters
    * Name **Development Applications IDS Policy**
    * IDS Profile **Development**
    * Applied to **Development Applicatons** (group)
    * Leave other settings to defaults
7. Click **Publish**

![](Images/IDPS_POC_10.PNG)

You have now successfully configured the NSX Distributed IDS/IPS ! In the next exercise, we will run through a basic attack scenario to confirm intrusion attemtps are detected and get familair with the NSX IDS/IPS Events view.

## Simple Attack Scenario
**Estimated Time to Complete: 30 minutes**

**Confirm IP addressess of deployed VMs**
1.	In the NSX Manager UI, navigate to Inventory -->  Virtual Machines
2. Note the IP addresses for the 4 VMs that were deployed

![](Images/IDPS_POC_11.PNG)

**Initiate DrupalGeddon2 attack against App1-WEB-TIER VM**
1.	If your computer has access to the IP address you've assigend to the **External VM** (10.114.209.151 in my example), open your ssh client and initiate a session to it. Login with the below credentials. 
    * Username **vmware*
    * Password **VMware1!**
2. **Alternatively**, if your computer does not have access to the **External VM** directly, you can access the VM console from the  physical environment vCenter Web-UI.  
3. In order to launch the **Drupalgeddon2** exploit against the **App1-WEB-TIER VM**, you can either manually configure the **Metasploit** module, or edit and run a pre-defined script. If you want to run the attack manually, skip to step #5. If you want to go with the script option, run **sudo nano attack1.rc** and type **VMware1!** when asked for the password. Confirm that the **RHOST** line IP address matches with the IP address of **App1-WEB-TIER VM** you saw in the NSX VM Inventory. Change this IP address if needed, save your changes and exit **nano**
4. Type **./attack1.sh** to initiate the Metasploit script and Drupalgeddon exploit. Next, go to step #6
5  **Alternatively**, 

