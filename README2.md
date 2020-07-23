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



[***Next Step: 1. Requirements***](docs/1-Requirements.md)
