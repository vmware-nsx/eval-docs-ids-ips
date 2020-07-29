
## Clearing IDS Events from NSX Manager
**For purposes of a demo or PoV, the below describes how IDS events can be cleared from NSX Manager**



1.	Open your ssh client and initiate a session to NSX Manager. Login with the below credentials. 
    * Username **root**
    * Password **VMware1!VMware1!**
2. Modify the **IP address (--host=10.114.209.149) in the below command to match the IP address of your NSX Manager**. Other values should not be changed
```console
service idps-reporting-service stop
java -cp /usr/share/corfu/lib/corfudb-tools-0.3.0.20200504185111.2955-shaded.jar org.corfudb.browser.CorfuStoreBrowserMain --host=10.114.209.149 --port=9040 --namespace=security_data_service --tablename=ids_event_data --operation=dropTable --tlsEnabled=true --keystore=/config/cluster-manager/corfu/private/keystore.jks --ks_password=/config/cluster-manager/corfu/private/keystore.password --truststore=/config/cluster-manager/corfu/public/truststore.jks --truststore_password=/config/cluster-manager/corfu/public/truststore.password
curl -X PUT -H "Content-Type: application/json" "localhost:9200/security_data_service_metadata/_doc/security_data_service?pretty" -d' {"clusterId" : "-1"}'
service idps-reporting-service start
```
3. IDS events will now be cleared from the NSX manager and the reporting service will restart. This may take a few moments, but when you login to the NSX Manager UI, you should see the IDS events have been removed. You may have to refresh the UI/webpage a few times. You can now close the ssh session. 
---

***Next Step: Continue with the next exercise in the PoV Guide***
