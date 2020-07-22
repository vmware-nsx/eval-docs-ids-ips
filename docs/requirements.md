
## 1. Requirements

Here are the requirements for NSX-T Evaluation.

### Compute & Storage

<details>
<summary>"Click to expand"</summary>

<p align="center">
  <img width=75% height=75% src="/docs/assets/Graphics/1.1.Pre-Req Compute.jpg">
</p>

| Compute          | Number | Version |                                                     Download                                                      |
|:-----------------|:------:|:-------:|:-----------------------------------------------------------------------------------------------------------------:|
| vCenter          |   1    |   7.0   | [download link](https://my.vmware.com/en/web/vmware/info/slug/datacenter_cloud_infrastructure/vmware_vsphere/7_0) |
| vCenter-Cluster  |   1+   |   n/a   |                                                        n/a                                                        |
| ESXi per Cluster |   2+   |   7.0   | [download link](https://my.vmware.com/en/web/vmware/info/slug/datacenter_cloud_infrastructure/vmware_vsphere/7_0) |
| CPU per ESXi     |   8+   |   n/a   |                                                        n/a                                                        |
| RAM per ESXi     | 48GB+  |   n/a   |                                                        n/a                                                        |
| NIC per ESXi     |   2+   |   n/a   |                                                        n/a                                                        |

| Storage | Shared storage - Recommended for live vMotion tests |
|:--------|:---------------------------------------------------:|
| Size    |                       500 GB                        |

</details>

---

### Networking

<details>
<summary>"Click to expand"</summary>

<p align="center">
  <img width=75% height=75% src="/docs/assets/Graphics/1.2.Pre-Req Networking.jpg">
</p>

| VLAN       | Number  | Description                                                                                  |
|:-----------|:-------:|:---------------------------------------------------------------------------------------------|
| Management | VLAN 11 | VLAN where Management is running (vCenter / ESXi-Mgt / future NSX-Mgr / future EdgeNode-Mgt) |
| Overlay    | VLAN 12 | VLAN where future NSX Logical Switches Overlay will run in                                   |

| Physical Router | VLAN      | IP                | MTU     | Note                                                                                          |
|:----------------|:----------|:------------------|:--------|:----------------------------------------------------------------------------------------------|
| Management      | VLAN 11   | 192.168.50.1/24   | 1500    |                                                                                               |
| Overlay         | VLAN 12   | 192.168.51.1/24 * | 1700+ * |                                                                                               |
| Web             | VLAN 16   | 10.16.1.1/24      | 1500    | Needed for [NSX Evaluation - Security only (no Logical Network)](/docs/3.1-Security-Only.md)  |
| External        | VLAN 3103 | 20.20.20.1/24     | 1500    | Needed for [NSX Evaluation -Logical Network + Security](/docs/3.2-LogicalNetwork-Security.md) |



\* Since in this lab all Transport Nodes (ESXi / Edge Nodes) run the Overlay traffic in the same VLAN 12, there is actually requirement to have an IP and MTU 1700+ on the physical router.


</details>


---

[***Next Step: 2. Installation of NSX***](/docs/2-Installation.md)
