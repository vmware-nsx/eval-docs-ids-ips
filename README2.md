# NSX-T - Distributed IDS/IPS PoV Guide

<p align="center">
  <img width="292" height="172" src="docs/assets/images/NSX_Logo.jpeg">
</p>

---
## Table of Contents

* [Description](#description)
* [Changelog](#changelog)
* [Requirements](#requirements)
* [FAQ](#faq)
* [Configuration](#configuration)
* [Logging](#logging)
* [Sample Execution](#sample-execution)
    * [Lab Deployment Script](#lab-deployment-script)
    
## Overview
The goal of this Proof of Value (PoV) is to allow customers to get hands-on experience with the NSX Distributed IDS/IPS. The expectation from people participating in the PoC is that they will complete the exercises outline in this guide in order to become familair with the key capabilities offered by the NSX Distributed IDS/IPS. While not the focus of this PoV guide, particpants will also gain basic experience with the Distributed Firewall and other NSX capabilities during this PoV process. 

While this PoV guide is quite prescriptive, participants can choose to modify any part of the workflow as desired. The guide is primarily focused on getting customers familiar with IDS/IPS, hence the deployment of the lab environment and rest of the configuration is automated through the use of a provided PowerShell script. After meeting the-requisites and running the script, a fully configured nested NSX-T environment is available to particpants, including a number of attacker and victim workload which are used as part of the IDS/IPS exercises. 

This script makes it very easy for anyone to deploy a nested vSphere vSphere lab environment for learning and educational purposes. All required VMware components (ESXi, vCenter Server, NSX Unified Appliance and Edge) are automatically deployed, attacker and multiple victim workloads are deplyed, and NSX-T networking configuration is applied in order to anyone to start testing the NSX Distributed IDS/IPS as soon as the deploment is completed. 

Below is a diagram of what is deployed as part of the solution and you simply need to have an existing vSphere environment running that is managed by vCenter Server and with enough resources (CPU, Memory and Storage) to deploy this "Nested" lab.

![](Images/docs/assets/images/IDPS_POC_1.PNG)

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
