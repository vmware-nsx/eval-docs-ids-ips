
## 9. Logging to an External Collector
**Estimated Time to Complete: 30 minutes**

In this **optional** exercise, we will explore some more advanced options in the NSX Distributed IDS/IPS Configuration

Prior to this exercise, change the **Mode** for both the **App-Tier** and **Web-Tier** IDS/IPS policy back to **Detect Only**.  

**Enable IDS/IPS event logging directly from each host to a syslog collector/SIEM**

> **Note**: In addition to sending IDS/IPS Events from each distributed IDS/IPS engine, you can send them directly to a Syslog collector or SIEM from each host. Events are sent in the EVE.JSON format for which many SIEMS have pre-existing parsers/dashboards. 

In this exercise, you will learn how to conigure IDS event export from each host to your syslog collector or SIEM of choice. I will use **vRealize Log Insight**. You can use the same or your own SIEM of choice.
We will not cover how to install **vRealize Log Insight** or any other logging platform, but the following steps will cover how to send IDS/IPS evens to an aleady configured collector.

1. Login to lab vCenter and click on **Hosts and Clusters**, then select one of the 3 hosts that were deployed.
2. Click the **Configure** Tab and Scroll down to **System**. Click **Advanced System Settings**
3. Click the **Edit** button
4. In the **Filter** field, type **loghost**
5. Enter the **IP address of your syslog server** in the **Syslog.global.logHost** value field and click **OK** to confirm.
![](assets/images/IDPS_POC_23.PNG)
6. Repeat the same for the remaining 2 hosts.
7. Click on **Firewall** in the same **System** menu
8. Click the **Edit** button
9. In the **Filter** field, type **syslog**
10. Tick the checkbox next to **syslog** to allow outbuound syslog from the host.
11. Repeat the same for the remaining 2 hosts.
![](assets/images/IDPS_POC_24.PNG)
12. Open Postman or another API tool and execute the below API PUT call to NSX Manager to retrieve the current syslog configuration. Note the **Revision** number from the API return body.
    * URI: https://10.114.222.108/api/v1/global-configs/IdsGlobalConfig (replace IP address with the IP address of your NSX Manager)
    * Method: GET
	* Authentication: Basic (enter username/password)
13. Now run a PUT call to enable syslog
    * URI: https://10.114.222.108/api/v1/global-configs/IdsGlobalConfig (replace IP address with the IP address of your NSX Manager)
    * Method: PUT
	* Authentication: Basic (enter username/password)
	* Body: 
```console
    {
    "global_idsevents_to_syslog_enabled": true,
    "resource_type": "IdsGlobalConfig",
    "_revision": 36 (change this to the revision number from the get call **incremented with 1**)
   }
```
![](assets/images/IDPS_POC_62.PNG)

14. Login to your syslog collector/SIEM and confirm you are receiving logs form each host.
15. Configure a parser or a filter to only look at IDS events. You can for example filter on the string **IDPS_EVT**. 
![](assets/images/IDPS_POC_25.PNG)
16. Now we will run the lateral attack scenario we used in an earlier exercise again. This time, use the pre-defined script to run the attack instead of manaully cofiguring the **Metasploit modules**.
17. Before you execute the script, if you have not previously used it, you need to ensure the IP addresses match your environment.  Type **sudo nano attack2.rc** and replace the **RHOST** and **LHOST** IP addresses accordingly to match with the IP addresses in your environment. 
    * **RHOST** on line 3 should be the IP address of the App1-WEB-TIER VM 
    * **SUBNET** on line 6 (route add) should be the Internal Network subnet 
    * **LHOST** on line 9 should be the IP address of the External VM (this local machine) 
    * **RHOST** on line 10 should be the IP address of the App1-APP-TIER VM RHOST on line 13 should be the IP address of the App2-APP-TIER VM
17. After saving your changes, run the attack2 script by executing **sudo ./attack2.sh**.
18. Confirm a total of 3 meterpreter/command shell sessions have been established
19. Confirm your syslog server/SIEM has received the IDS events, directly from the host
![](assets/images/IDPS_POC_26.PNG)

This completes this exercise. Before moving to the next exercise, folow [these instructions](/docs/ClearingIDSEvents.md) to clear the IDS events from NSX Manager

---

[***Next Step : (Optional) 10. Segmenting the Environment***](10-Segmentation.md)
