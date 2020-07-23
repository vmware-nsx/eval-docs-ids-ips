 
<p align="center">
# DRAFT - WORK IN PROGRESS
</p>

# NSX-T - Distributed IDS/IPS Proof of Value Guide

<p align="center">
  <img width="292" height="172" src="docs/assets/images/NSX_Logo.jpeg">
</p>

---
## Overview
The goal of this Proof of Value (PoV) is to allow customers to get hands-on experience with the [NSX Distributed IDS/IPS](https://www.vmware.com/products/nsx-distributed-ids-ips.html). The expectation from people participating in the PoC is that they will complete the exercises outline in this guide in order to become familair with the key capabilities offered by the NSX Distributed IDS/IPS. While not the focus of this PoV guide, particpants will also gain basic experience with the Distributed Firewall and other NSX capabilities during this PoV process. 

While this PoV guide is quite prescriptive, participants can choose to modify any part of the workflow as desired. The guide is primarily focused on getting customers familiar with IDS/IPS, hence the deployment of the lab environment and rest of the configuration is automated through the use of a provided PowerShell script. After meeting the-requisites and running the script, a fully configured nested NSX-T environment is available to particpants, including a number of attacker and victim workload which are used as part of the IDS/IPS exercises. Once the nested lab has been deployed, the lab guide walks users through a number of attack scenarios, using tools like **Metasploit** to showcase the value of the NSX Distributed IDS/IPS.


---
## Disclaimer and acknowledgements
This lab provides and leverages common pen-test tools including Metasploit as well as purposfully vulnerable workloads built using Vulhub (https://github.com/vulhub/vulhub) . Please only use these tools for the intended purpose of completing the PoC, isolate the lab enviornment properly from any other environment and discard when the PoC has been completed.

The automation script is based on work done by [William Lam](https://github.com/lamw) with additional vSphere and NSX automation by [Madhu Krishnarao](https://github.com/madhukark)

---
## Changelog

* **07/8/2020**
  * Intial partial draft of the guide

---
## Intended Audience
This PoV guide is intended for existing and future NSX customers who want to evaluate the NSX Distributed IDS/IPS functionality. Ideally, the PoV process involves people covering these roles:

* CISO Representative
* Data Center Infrastructure Team
* Network Architects
* Security Architects
* Security Operations Center Analyst
* Enterprise Applicatoin Owner

---
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

---
## Support during the PoV Process

Existing NSX customers should reach out to their NSX account team for support during the PoV process.

---
## Table of Contents
* [Requirements](/docs/1-Requirements.md)
* [Customize Deployment Script](/docs/2-CustomizeScript.md)
* [Verify Lab Deployment](/docs/3-VerifyLabDeployment.md)
* [Initial IDS/IPS Configuration](/docs/4-InitialConfiguration.md)
* [Basic Attack Scenario](/docs/5-BasicAttackScenario.md)
* [Lateral Movement Scenario](/docs/6-LateralMovementScenario.md)
* [Advanced Exercises](/docs/7-AdvancedExercises.md)
* [Segmenting the Evironment](/docs/8-Segmentation.md)

[***Next Step: 1. Requirements***](docs/1-Requirements.md)
