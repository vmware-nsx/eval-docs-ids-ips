
<p align="center">
# DRAFT
</p>

# NSX-T - Distributed IDS/IPS PoV Guide

<p align="center">
  <img width="292" height="172" src="docs/assets/images/NSX_Logo.jpeg">
</p>

---

## Overview
The goal of this document is to offer a "step by step" NSX Evaluation Guide to test (some) NSX Services:
- Security Services
  - Micro-Segmentation (DFW)
- Logical Networking Services
  - Logical Switching
  - Logical Routing (with distributed routing)
- Operation tools
  - Network Topology
  - Traceflow

NSX offers many more services, such as Load Balancing, VPN, IDS, NSX Intelligence, Federation, etc.  
Those are currently out of scope of that document.  

Also to limit the ESXi/Storage requirements, this evaluation does not cover high-availability and only 1 element of each NSX component will be installed.

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
