
## 9. Segmentation
**Estimated Time to Complete: 30 minutes**

In this final exercise, we will leverage the **Distributed Firewall** in order to limit the attack surface. 
First, we will apply a **Macro-segmentation** policy which will isolate our **Production** environment and the applications deployed in it from the **Development** environment. 
Then, we will implement a **Micro-segmentation** policy, which will employ an **allow-list** to only allow the flows required for our applications to function and block everything else.

**Macro-Segmentation: Isolating the Production and Development enviornments**

The goal of this exercise is to completley isolate workloads deployed in **Production** from workloads deployed in **Development**. All nested workloads were previously tagged to identify which of these environments they were deployed in, and earlier in this lab, you created groups for **Production Applications** and **Development Applications** respecively. In the next few steps, you will create the appropriate firewall rules to achieve this, and then run through the **lateral movement** attack scenario again to see how lateral movement has now been limited to a particular environment.

***Create a Distributed Firewall Environment Category Policy***
1. In the NSX Manager UI, navigate to Security -->  Distributed Firewall
2. Click on the **Environments(0)** Category tab.
3. Click **ADD POLICY**
4. Click **New Policy** and change the name of the policy to **Environment Isolation**
5. Check the checkbox next to the **Environment Isolation** Policy
6. Click **ADD RULE** twice, and configure the cnew new rules as per below setps
7. Rule 1
    * Name: **Isolate Production-Development**
    * Source: **Production Applications** 
    * Destination: **Development Applications** 
    * Services: **ANY** 
    * Profiles: **NONE** 
    * Applied To: **Production Applications** , **Development Applications** 
    * Action: **Drop**
8. Rule 2
    * Name: **Isolate Development-Production**
    * Source: **Development Applications** 
    * Destination: **Production Applications**  
    * Services: **ANY** 
    * Profiles: **NONE** 
    * Applied To: **Production Applications** , **Development Applications** 
    * Action: **Drop**

![](assets/images/IDPS_POC_38.PNG)

9. Click **Publish** to publish these rules to the **Distributed Firewall**.

***Open a SSH/Console session to the External VM***
1.	If your computer has access to the IP address you've assigend to the **External VM** (10.114.209.151 in my example), open your ssh client and initiate a session to it. Login with the below credentials. 
    * Username **vmware**
    * Password **VMware1!**
2. **Alternatively**, if your computer does not have access to the **External VM** directly, you can access the VM console from the  physical environment vCenter Web-UI. 

***Run through the the lateral attack scenario (again)***

In order to reduce the time needed for this, you can run the **attack2** script from the **external VM** which will initiate the complete lateral attack scenario without needing any manual metasploit steps. If you prefer, you can also manually go though these steps (See the chapter on Lateral Movement Scenario)

1. If you have not previously used this script, you will need to modify it to reflect your environment. Type **sudo nano attack2.rc** and replace the **RHOST** and **LHOST** IP addresses accordingly to match with the IP addresses in your environment. 
    * **RHOST** on line 3 should be the IP address of the App1-WEB-TIER VM 
    * **SUBNET** on line 6 (route add) should be the Internal Network subnet 
    * **LHOST** on line 9 should be the IP address of the External VM (this local machine) 
    * **RHOST** on line 10 should be the IP address of the App1-APP-TIER VM 
    * **RHOST** on line 13 should be the IP address of the App2-APP-TIER VM
2. Type **CTRL-O** and confirm to save your changes, then **CTRL-X** to exit **Nano**.
3. Type **sudo ./attack2.sh** to run the attack scenario

> **Note**: This scripted attack does not upgrade shell sessions to meterpreter sessions nor does it interact with the sessions. To interact with the established sessions, but it will cause the same signatures to fire on the NSX IDS/IPS.

4. Confirm that this time, although the script tried to exploit the **APP1-WEB-TIER** then laterally move to **APP1-APP-TIER** and then move once more to **APP2-APP-TIER** only 2 reverse shell sessions were established
    * One from the **APP1-WEB-TIER** VM
    * One from the **APP1-APP-TIER** VM 

> **Note**: The exploit of the **APP2-APP-TIER** VM failed, because the Distributed Firewall policy you just configured isolated the **APP2** workloads that are part of the **Development Applications** Group (Zone) from the **APP1** workloads which are part of the **Production Applications** Group (Zone).

1. In the NSX Manager UI, navigate to Security -->  Distributed Firewa

    ![](assets/images/IDPS_POC_38.PNG)
    
> **Note**: Tags were applied to the workloads through the Powershell script used to deploy the lab environment.


---

[***Next Step: 10. Conclusion***](/docs/10-Conclusion)
