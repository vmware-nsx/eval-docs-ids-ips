
## 9. Segmenation
**Estimated Time to Complete: 30 minutes**

In this final exercise, we will leverage the **Distributed Firewall** in order to limit the attack surface. 
First, we will apply a **Macro-segmentation** policy which will isolate our **Production** environment and the applications deployed in it from the **Development** environment. 
Then, we will implement a **Micro-segmentation** policy, which will employ an **allow-list** to only allow the flows required for our applications to function and block everything else.

**Macro-Segmentation: Isolating the Production and Development enviornments**

The goal of this exercise is to completley isolate workloads deployed in **Production** from workloads deployed in **Development**. All nested workloads were previously tagged to identify which of these environments they were deployed in, and earlier in this lab, you created groups for **Production** and **Development** respecively. In the next few steps, you will create the appropriate firewall rules to achieve this, and then run through the **lateral movement** attack scenario again to see how lateral movement has now been limited to a particular environment.

**Create a Distributed Firewall Environment Category Policy**
1. In the NSX Manager UI, navigate to Security -->  Distributed Firewall
2. Click on the **Environments(0)** Category tab.
3. Click **ADD POLICY**
4. Click **New Policy** and change the name of the policy to **Environment Isolation**
5. Check the checkbox next to the **Environment Isolation** Policy
6. Click **ADD RULE** twice, and configure the new new rules as per below setps
7. Rule 1
    * Name **Production Applications**
    * Compute Members: Membership C
    
3.	Create a Group with the below parameters. Click Save when done.
    * Name **Production Applications**
    * Compute Members: Membership Criteria: **Virtual Machine Tag Equals Production Scope Environment**
    ![](assets/images/IDPS_POC_7.PNG)     
3.	Create another Group with the below parameters. Click Save when done.
    * Name **Development Applications**
    * Compute Members: Membership Criteria: **Virtual Machine Tag Equals Development Scope Environment**
    ![](assets/images/IDPS_POC_8.PNG)    
4. Confirm previously deployed VMs became a member of appropriate groups due to applied tags. Click **View Members** for the 2 groups you created and confirm
    * Members of **Development Applications**: **APP-2-APP-TIER**, **APP-2-WEB-TIER**
    * Members of **Production Applications**: **APP-1-APP-TIER**, **APP-1-WEB-TIER**
    ![](assets/images/IDPS_POC_9.PNG)    
    
> **Note**: Tags were applied to the workloads through the Powershell script used to deploy the lab environment.


---

[***Next Step: 10. Conclusion***](/docs/10-Conclusion)
