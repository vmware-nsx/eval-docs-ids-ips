
## 1. Requirements

Here are the requirements for NSX-T Distributed IDS/IPS Proof of Value.

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
    
> **Note**: if you are not entitled or not able to access the above links, you can download a free trial and obtain a license for all of the above through https://www.vmware.com/try-vmware.html 


---

[***Next Step: 2. Installation of NSX***](/docs/2-Installation.md)
