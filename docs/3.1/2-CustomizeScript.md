
## 2. Customize Deployment Script Variables
**Estimated Time to Complete: 60 minutes**

Before you can run the [script](https://github.com/vmware-nsx/eval-docs-ids-ips/blob/master/Nested%20Lab%20Deployment-3.1.ps1), you will need to [download](hhttps://github.com/vmware-nsx/eval-docs-ids-ips/blob/master/Nested%20Lab%20Deployment-3.1.ps1) and edit the script and update a number of variables to match your deployment environment. Details on each section is described below including actual values used my sample lab environment. The variables that need to adjusted are called out specifically. Other variables can in almost all cases be left to their default values.

In this example below, I will be using a single /27 subnet(10.114.209.128/27)  on a single port-group (VLAN-194) which all the VMs provisioned by the automation script will be connected to. It is expected that you will have a similar configuration which is the most basic configuration for PoV and testing purposes.

| Name                       | IP Address                     | Function                     | Default Credentials          |
|----------------------------|--------------------------------|------------------------------|------------------------------|
| pov-vcsa                   | 10.114.209.143                 | vCenter Server               |administrator@vsphere.local/VMware1! |
| Nested_ESXi_1              | 10.114.209.140                 | ESXi                         |root/VMware1!
| Nested_ESXi_2              | 10.114.209.141                 | ESXi                         |root/VMware1!
| Nested_ESXi_3              | 10.114.209.142                 | ESXi                         |root/VMware1!
| pov-nsx                    | 10.114.209.149                 | NSX-T Manager                |admin/VMware1!VMware1!
| pov-nsx-edge               | 10.114.209.150                 | NSX-T Edge                   |admin/VMware1!
| T0-uplink                  | 10.114.209.148                 | T0 GW Interface IP           |n.a.
| TunnelEndpointGateway      | 10.114.209.129                 | Existing default GW          |n.a.
| T0 Static Default GW       | 10.114.209.129                 | Existing default GW          |n.a.
| TEP Pool                   | 10.114.209.144-10.114.209.147  | Tunnel Endpoint IPs          |n.a.
| External VM                | 10.114.209.151                 | Attacker (Metasploit) VM     |vmware/VMware1!

> **Note:** The remainder of this page contains the sections and variables within the script that should be modified to match the parameters of your environment. Other sections and variables within the script should be left at their pre-configured defaults.

This section describes the credentials to your physical environment vCenter Server in which the nested lab environment will be deployed to. Make sure to adjust **all** of the below variables to match your physical environment vCenter:
```console
# vCenter Server used to deploy vSphere with NSX lab
$VIServer  = "vcenter-north.lab.svanveer.pa"
$VIUsername = "administrator@vsphere.local"
$VIPassword = "VMware1!"
```

This section describes the location of the files required for deployment. This includes the OVAs for ESXi, NSX Manager and NSX Edge, the extracted bundle for vCenter and OVAs for the external and victim VMs.  Update the below variables with the actual **location of the downloaded OVAs/extracted files** on the local machine you run this PowerShell script from

```console
# Full Path to both the Nested ESXi 7.0 VA, Extracted VCSA 7.0 ISO, NSX-T OVAs, External and Victim VM OVAs
$NestedESXiApplianceOVA = "C:\Users\stijn\downloads\ESXI\Nested_ESXi7.0_Appliance_Template_v1.ova"
$VCSAInstallerPath = "C:\Users\stijn\downloads\VCSA\VMware-VCSA-all-7.0.0-16189094"
$NSXTManagerOVA = "C:\Users\stijn\downloads\NSXMgr\nsx-unified-appliance-3.0.0.0.0.15946739.ova"
$NSXTEdgeOVA = "C:\Users\stijn\downloads\NSXEdge\nsx-edge-3.0.0.0.0.15946012.ova"
$ExternalVMOVA = "C:\Users\stijn\downloads\Attacker\External-VM.ova"
$VictimVMOVA = "C:\Users\stijn\downloads/Victim\Victim-VM.ova"
```
> **Note:** The path to the VCSA Installer must be the extracted contents of the ISO


This section defines the number of Nested ESXi VMs to deploy along with their associated IP Address(s). The names are merely the display name of the VMs when deployed. At a minimum, you should deploy at least three hosts, but you can always add additional hosts and the script will automatically take care of provisioning them correctly. Adjust the **IP addresses** for the 3 below hosts. For simplicity, these IP addresses should part of the same Management subnet for the nested vCenter and NSX Manager. 
```console
# Nested ESXi VMs to deploy - Replace IP addresses (nested ESXi VMMKnic) to match the assigned subnet in your physical eenvironment
$NestedESXiHostnameToIPs = @{
    "Nested_ESXi_1" = "10.114.209.140" 
    "Nested_ESXi_2" = "10.114.209.141" 
    "Nested_ESXi_3" = "10.114.209.142" 
}
```

This section describes the VCSA deployment configuration such as the VCSA deployment size, Networking & SSO configurations. If you have ever used the VCSA CLI Installer, these options should look familiar. Adjust the **IP address** and **Prefix (Subnet Mask Bits)** to match the desired IP address of the nested ESXi. Use the Same IP address as the **hostname**, unless you can add an FQDN entry to your DSN server. 
```console
$VCSADeploymentSize = "tiny"
$VCSADisplayName = "pov-vcsa"
$VCSAIPAddress = "10.114.209.143" #Set to the desired IP address
$VCSAHostname = "10.114.209.143" #Use IP if you don't have valid DNS. 
$VCSAPrefix = "27" #Set to the appropriate prefix
$VCSASSODomainName = "vsphere.local"
$VCSASSOPassword = "VMware1!"
$VCSARootPassword = "VMware1!"
$VCSASSHEnable = "true"
```

This section describes the physical location as well as the generic networking settings applied to Nested ESXi VCSA & NSX VMs. The following variable should be defined by users **VMDataceter**, **VMCluster**, **VMNetwork** and **VMdatastore**. Replace all the **IP addresses** and **netmaks** with the appropriate IP addresses/netmask to match your phyiscal environment.  For the other values, default values are sufficient.
```console
$VMDatacenter = "PaloAlto-Main" # Existing Datacenter on the Physical vCenter
$VMCluster = "Physical-3" #Existing Cluster in the above Datacenter on the Physical vCenter
$VMNetwork = "VLAN-194" #Existing port-group on the physical host/ to use and connect all deployed workloads (except for victim VMs) to
$VMDatastore = "NFS" #Existing Datastore on the physical host/vCenter
$VMNetmask = "255.255.255.224" #Netmask of the designated existing subnet which will be used to connect all deployed workloads (except for victim VMs) to
$VMGateway = "10.114.209.129" #Existing Gateway allowing lab management components to reach the outside environment
$VMDNS = "10.114.222.70" #Existing DNS server that will be configured on lab management componenets
$VMNTP = "10.20.145.1" #Existing NTP server that will be configured on lab management components
$VMPassword = "VMware1!"
$VMDomain = "lab.svanveer.pa"
$VMSyslog = "" # Do not set this unless you want to send logs to an existing and reachable Syslog collector/SIEM.
$VMFolder = "NSX PoV" #The deployment script will create this folder
```

This section describes the NSX-T configurations, the following variables must be defined by users and the rest can be left as defaults.
    **$NSXLicenseKey**, **$NSXVTEPNetwork**, **$T0GatewayInterfaceAddress**, **$T0GatewayInterfacePrefix**, **$T0GatewayInterfaceStaticRouteAddress** and the **NSX-T Manager**, **TEP IP Pool** and **Edge** Sections
```console
# NSX-T Configuration - Adjust variables (license key, VTEPNetwork) to match your environment
NSXLicenseKey = "xxxxx-xxxxx-xxxxx-xxxxx-xxxxx" #Replace with valid NSX License key
$NSXRootPassword = "VMware1!VMware1!"
$NSXAdminUsername = "admin"
$NSXAdminPassword = "VMware1!VMware1!"
$NSXAuditUsername = "audit"
$NSXAuditPassword = "VMware1!VMware1!"
$NSXSSHEnable = "true"
$NSXEnableRootLogin = "true"
$NSXVTEPNetwork = "VLAN-194" # Replace with the appropriate pre-existing port-group 

# TEP IP Pool  - Replace IP addresses to match the physical environment subnet you've allocated (i.e management network) 
$TunnelEndpointName = "TEP-IP-Pool"
$TunnelEndpointDescription = "Tunnel Endpoint for Transport Nodes"
$TunnelEndpointIPRangeStart = "10.114.209.144" 
$TunnelEndpointIPRangeEnd = "10.114.209.147"
$TunnelEndpointCIDR = "10.114.209.128/27" 
$TunnelEndpointGateway = "10.114.209.129" #Default Gateway of the Management Network

# T0 Gateway - Adjust T0GatewayInterfaceAddress and Prefix as well as StaticRoute Address 
$T0GatewayName = "PoV-T0-Gateway"
$T0GatewayInterfaceAddress = "10.114.209.148" # should be a routable address
$T0GatewayInterfacePrefix = "27" #adjust to the correct prefix for your enviornment
$T0GatewayInterfaceStaticRouteName = "PoV-Static-Route"
$T0GatewayInterfaceStaticRouteNetwork = "0.0.0.0/0"
$T0GatewayInterfaceStaticRouteAddress = "10.114.209.129" # IP address of the next hop router in your environment. This can be set to an invalid IP address to ensure the vulnerable workloads remain isolated from the rest of the environment

# NSX-T Manager Configurations - Replace IP addresses
$NSXTMgrDeploymentSize = "small"
$NSXTMgrvCPU = "4" 
$NSXTMgrvMEM = "16" 
$NSXTMgrDisplayName = "pov-nsx-manager"
$NSXTMgrHostname = "10.114.209.149" # Replace with the desired IP address for the NSX Manager
$NSXTMgrIPAddress = "10.114.209.149" # Replace with the desired IP address for the NSX Manager

# NSX-T Edge Configuration
$NSXTEdgeDeploymentSize = "medium"
$NSXTEdgevCPU = "4" 
$NSXTEdgevMEM = "8"
$NSXTEdgeName = "poc-nsx-edge"
$NSXTEdgeHostnameToIPs = @{
    $NSXTEdgeName = "10.114.209.150" #Replace with the desired IP address for the NSX Edge Management Interface

}
```

---

[***Next Step: 3. Run Deployment Script***](/docs/3-RunScript.md)
