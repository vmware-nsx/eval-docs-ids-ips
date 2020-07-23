# NSX-T - Distributed IDS/IPS Proof of Value Guide

<p align="center">
  <img width="292" height="172" src="docs/assets/images/NSX_Logo.jpeg">
</p>

---
## Overview
The goal of this Proof of Value (PoV) is to allow customers to get hands-on experience with the [NSX Distributed IDS/IPS](https://www.vmware.com/products/nsx-distributed-ids-ips.html). The expectation from people participating in the PoC is that they will complete the exercises outline in this guide in order to become familair with the key capabilities offered by the NSX Distributed IDS/IPS. While not the focus of this PoV guide, particpants will also gain basic experience with the Distributed Firewall and other NSX capabilities during this PoV process. 

While this PoV guide is quite prescriptive, participants can choose to modify any part of the workflow as desired. The guide is primarily focused on getting customers familiar with IDS/IPS, hence the deployment of the lab environment and rest of the configuration is automated through the use of a provided PowerShell script. After meeting the-requisites and running the script, a fully configured nested NSX-T environment is available to particpants, including a number of attacker and victim workload which are used as part of the IDS/IPS exercises. 

---
## Disclaimer and acknowledgements
This lab provides and leverages common pen-test tools including Metasploit as well as purposfully vulnerable workloads built using Vulhub (https://github.com/vulhub/vulhub) . Please only use these tools for the intended purpose of completing the PoC, isolate the lab enviornment properly from any other environment and discard when the PoC has been completed.

The automation script is based on work done by [William Lam](https://github.com/lamw) with additional vSphere and NSX automation by [Madhu Krishnarao](https://github.com/madhukark)

## Changelog

* **07/8/2020**
  * Intial partial draft of the guide

---
## Table of Contents
* [Requirements](/docs/1-Requirements.md)
* [FAQ](#faq)
* [Configuration](#configuration)
* [Logging](#logging)
* [Sample Execution](#sample-execution)
    * [Lab Deployment Script](#lab-deployment-script)

1. [Requirements](/docs/1-Requirements.md)
1. [Installation of NSX](/docs/2-Installation.md)
1. [NSX Evaluation](/docs/3-NSX-Evaluation.md)
   1. [Security only (no Logical Network)](/docs/3.1-Security-Only.md)
   1. [Logical Network + Security](/docs/3.2-LogicalNetwork-Security.md)
   1. [Operation Tools](/docs/3.3-Operation-Tools.md)

## Nested Lab Deployment Script
This script makes it very easy for anyone to deploy a nested vSphere vSphere lab environment for learning and educational purposes. All required VMware components (ESXi, vCenter Server, NSX Unified Appliance and Edge) are automatically deployed, attacker and multiple victim workloads are deplyed, and NSX-T networking configuration is applied in order to anyone to start testing the NSX Distributed IDS/IPS as soon as the deploment is completed. 

Below is a diagram of what is deployed as part of the solution and you simply need to have an existing vSphere environment running that is managed by vCenter Server and with enough resources (CPU, Memory and Storage) to deploy this "Nested" lab.
* Gray: Pre-requisites (Physical ESXi Server, vCenter managing the server and a Port group to provide connectivity of nested lab environment
* Blue: Management and Edge Components (vCenter, NSX Manager and NSX Edge) Deployed by PowerCLI Script
* Red: External VM running Metasploit and other functions deployed by PowerCLI Script on Physical Environment vCenter 
* Yellow: Nested ESXi hypevisors deployed by PowerCLI Script and managed by nested vCenter
* Purple: vSAN datastore across 3 nested ESXi hypervisors configured by PowerCLI Script
* Green: NSX Overlay DMZ Segment and vulnerable Web-VMs connected to it. Segment created and VMs deployed by PowerCLI Script.
* Orange: NSX Overlay Internal Segment and vulnerable App-VMs connected to it. Segment created and VMs deployed by PowerCLI Script.

Once the script has deployed the Lab environment, the rest of the lab is focussed on various attack scenarios that test the NSX Distributed IDS/IPS.

![](/docs/assets/images/IDPS_POC_1.PNG)

---
This document table of content is:
1. [Requirements](/docs/1-Requirements.md)
1. [Installation of NSX](/docs/2-Installation.md)
1. [NSX Evaluation](/docs/3-NSX-Evaluation.md)
   1. [Security only (no Logical Network)](/docs/3.1-Security-Only.md)
   1. [Logical Network + Security](/docs/3.2-LogicalNetwork-Security.md)
   1. [Operation Tools](/docs/3.3-Operation-Tools.md)


---

[***Next Step: 1. Requirements***](/docs/1-Requirements.md)
