# Based on work by William Lam / www.virtuallyghetto.com 
# Additinal NSX automation by Madhu Krishnarao and Stijn Vanveerdeghem

# vCenter Server used to deploy vSphere with NSX lab
$VIServer = "vcenter-north.lab.svanveer.pa"
$VIUsername = "administrator@vsphere.local"
$VIPassword = "VMware1!"

# Full Path to both the Nested ESXi 7.0 VA, Extracted VCSA 7.0 ISO, NSX-T OVAs, External and Victim VM OVAs
$NestedESXiApplianceOVA = "C:\Users\stijn\downloads\ESXI\Nested_ESXi7.0_Appliance_Template_v1.ova"
$VCSAInstallerPath = "C:\Users\stijn\downloads\VCSA\VMware-VCSA-all-7.0.0-16189094"
$NSXTManagerOVA = "C:\Users\stijn\downloads\NSXMgr\nsx-unified-appliance-3.1.0.0.0.16746585.ova"
$NSXTEdgeOVA = "C:\Users\stijn\downloads\NSXEdge\nsx-edge-3.1.0.0.0.16746590.ova"
$ExternalVMOVA = "C:\Users\stijn\downloads\Attacker\External-VM.ova"
$VictimVMOVA = "C:\Users\stijn\downloads\Victim\Victim-VM.ova"


# Nested ESXi VMs to deploy  - Replace IP addresses (nested ESXi VMMKnic) to match the assigned subnet in your physical eenvironment
$NestedESXiHostnameToIPs = @{
    "10.114.222.104" = "10.114.222.104"
    "10.114.222.105" = "10.114.222.105"
    "10.114.222.106" = "10.114.222.106" 
}

# Nested ESXi VM Resources - Default values are sufficient
$NestedESXivCPU = "4"
$NestedESXivMEM = "16" #GB
$NestedESXiCachingvDisk = "8" #GB
$NestedESXiCapacityvDisk = "100" #GB

# VCSA Deployment Configuration
$VCSADeploymentSize = "tiny"
$VCSADisplayName = "pov-vcsa-2"
$VCSAIPAddress = "10.114.222.107" #Set to the desired IP address
$VCSAHostname = "10.114.222.107" #Use IP if you don't have valid DNS. 
$VCSAPrefix = "28" #Set to the appropriate prefix
$VCSASSODomainName = "vsphere.local"
$VCSASSOPassword = "VMware1!"
$VCSARootPassword = "VMware1!"
$VCSASSHEnable = "true"

# General Deployment Configuration for Nested ESXi, VCSA & NSX VMs
$VMDatacenter = "PaloAlto-Main"
$VMCluster = "Physical-2"
$VMNetwork = "VLAN-212-Main" #Existing port-group on the physical host/ to use and connect all deployed workloads (except for victim VMs) to
$VMDatastore = "NFS" #Existing Datastore on the physical host/vCenter
$VMNetmask = "255.255.255.240"
$VMGateway = "10.114.222.97"
$VMDNS = "10.114.222.70"
$VMNTP = "10.20.145.1"
$VMPassword = "VMware1!"
$VMDomain = "lab.svanveer.pa"
$VMSyslog = "10.114.209.153" # Do not set this unless you want to send logs to an existing and reachable Syslog collector/SIEM.
$VMFolder = "NSX PoV 2" #The deployment script will create this folder

# Applicable to Nested ESXi only
$VMSSH = "true"
$VMVMFS = "false"

# Name of new vSphere Datacenter/Cluster when VCSA is deployed - Default values are sufficient
$NewVCDatacenterName = "PoC-Datacenter"
$NewVCVSANClusterName = "Workload-Cluster"
$NewDatastore = "vsanDatastore"
$NewVCVDSName = "PoC-VDS"
$NewVCDVPGName = "DVPG-Management Network"

# PoV Configuration - Default values are sufficient
$StoragePolicyName = "PoV-gold-storage-policy"
$StoragePolicyTagCategory = "PoV-demo-tag-category"
$StoragePolicyTagName = "PoV-demo-storage"
$DevOpsUsername = "devops"
$DevOpsPassword = "VMware1!"

# NSX-T Configuration
$NSXLicenseKey = ""
$NSXRootPassword = "VMware1!VMware1!"
$NSXAdminUsername = "admin"
$NSXAdminPassword = "VMware1!VMware1!"
$NSXAuditUsername = "audit"
$NSXAuditPassword = "VMware1!VMware1!"
$NSXSSHEnable = "true"
$NSXEnableRootLogin = "true"
$NSXVTEPNetwork = "VLAN-213"

# Transport Node Profile - Default values are sufficient
$TransportNodeProfileName = "PoV-Transport-Node-Profile"

# TEP IP Pool  - Replace IP addresses to match the physical environment subnet you've allocated (i.e management network) 
$TunnelEndpointName = "TEP-IP-Pool"
$TunnelEndpointDescription = "Tunnel Endpoint for Transport Nodes"
$TunnelEndpointIPRangeStart = "10.114.222.121"
$TunnelEndpointIPRangeEnd = "10.114.222.124"
$TunnelEndpointCIDR = "10.114.222.112/28"
$TunnelEndpointGateway = "10.114.222.113"

# Transport Zones - Default Values are sufficient
$OverlayTransportZoneName = "TZ-Overlay"
$OverlayTransportZoneHostSwitchName = "nsxswitch"
$VlanTransportZoneName = "TZ-VLAN"
$VlanTransportZoneNameHostSwitchName = "edgeswitch"

# Network Segment - Default Values are sufficient
$NetworkSegmentName = "PoV-Segment"
$NetworkSegmentVlan = "213" #maybe change back 0

# DHCP Server - Default Values are sufficient
$DHCPServerName = "DHCP_Server"

# T0 Gateway - Adjust T0GatewayInterfaceAddress and Prefix as well as StaticRoute Address 
$T0GatewayName = "PoV-T0-Gateway"
$T0GatewayInterface = "t0_interface_01"
$T0GatewayInterfaceAddress = "10.114.222.124" # should be a routable address
$T0GatewayInterfacePrefix = "28"
$T0GatewayInterfaceStaticRouteName = "PoC-Static-Route"
$T0GatewayInterfaceStaticRouteNetwork = "0.0.0.0/0"
$T0GatewayInterfaceStaticRouteAddress = "10.114.222.113"

# Uplink Profiles  - Default Values are sufficient
$ESXiUplinkProfileName = "ESXi-Host-Uplink-Profile"
$ESXiUplinkProfilePolicy = "FAILOVER_ORDER"
$ESXiUplinkName = "uplink1"
$ESXiUplinkProfileTransportVLAN = "0"

$EdgeUplinkProfileName = "Edge-Uplink-Profile"
$EdgeUplinkProfilePolicy = "FAILOVER_ORDER"
$EdgeOverlayUplinkName = "uplink1"
$EdgeOverlayUplinkProfileActivepNIC = "fp-eth1"
$EdgeUplinkName = "tep-uplink"
$EdgeUplinkProfileActivepNIC = "fp-eth2"
$EdgeUplinkProfileTransportVLAN = "0" # Do not changes this VLAN
$EdgeUplinkProfileMTU = "1600"

# Edge Cluster  - Default Values are sufficient
$EdgeClusterName = "Edge-Cluster-01"


# NSX-T Manager Configurations - Replace IP address
$NSXTMgrDeploymentSize = "small"
$NSXTMgrvCPU = "4" 
$NSXTMgrvMEM = "16"
$NSXTMgrDisplayName = "pov-nsx-manager-2"
$NSXTMgrHostname = "10.114.222.108"
$NSXTMgrIPAddress = "10.114.222.108"

# NSX-T Edge Configuration - Replace IP address
$NSXTEdgeDeploymentSize = "medium"
$NSXTEdgevCPU = "4" 
$NSXTEdgevMEM = "8"
$NSXTEdgeName = "pov2-nsx-edge-2"
$NSXTEdgeHostnameToIPs = @{
    $NSXTEdgeName = "10.114.222.109" 
}


# Segments
$DMZSegment = [pscustomobject] @{
    Name = 'DMZSegment'
    Gateway = '192.168.10.1/24'
    Subnet = '192.168.10.0/24'
    DHCPPool = '192.168.10.100-192.168.10.150'
}

$InternalSegment = [pscustomobject] @{
    Name = 'InternalSegment'
    Gateway = '192.168.20.1/24'
    Subnet = '192.168.20.0/24'
    DHCPPool = '192.168.20.100-192.168.20.150'
}

# SNAT Rule
$NATName = "SNAT_Internal"
$NATSourceNetwork = "192.168.20.0/24"
$NATTranslatedNetwork = $T0GatewayInterfaceAddress

# Attacker and Victim VMs
$App1WebVM= [pscustomobject] @{
    Name = "APP-1-WEB-TIER"
    Network = $DMZSegment.Name
    HostIndex = 0
}

$App2WebVM = [pscustomobject] @{
    Name = "APP-2-WEB-TIER"
    Network = $DMZSegment.Name
    HostIndex = 1
}

$App1AppVM = [pscustomobject] @{
    Name = "APP-1-APP-TIER"
    Network = $InternalSegment.Name
    HostIndex = 2
}

$App2AppVM = [pscustomobject] @{
    Name = "APP-2-APP-TIER"
    Network = $InternalSegment.Name
    HostIndex = 0
}

# Tags
$DevelopmentTag = [pscustomobject] @{
    Name = 'Development'
    Scope = 'Environment'
}

$ProductionTag = [pscustomobject] @{
    Name = 'Production'
    Scope = 'Environment'
}

$App1Tag = [pscustomobject] @{
    Name = 'App-1'
    Scope = 'Application'
}

$App2Tag = [pscustomobject] @{
    Name = 'App-2'
    Scope = 'Application'
}

$WebTierTag = [pscustomobject] @{
    Name = 'Web-Tier'
    Scope = 'Tier'
}

$AppTierTag = [pscustomobject] @{
    Name = 'App-Tier'
    Scope = 'Tier'
}

$ExternalVM = "External-VM-2"

# Advanced Configurations
# Set to 1 only if you have DNS (forward/reverse) for ESXi hostnames
$addHostByDnsName = 0

#### DO NOT EDIT BEYOND HERE ####

$debug = $true
$verboseLogFile = "nsxt-external-lab-deployment.log"
$random_string = -join ((65..90) + (97..122) | Get-Random -Count 8 | % {[char]$_})
$VAppName = "NSX-T-External-Lab-$random_string"

$siteID = 'default'
$enforcementpointID = 'default'

$preCheck = 1
$confirmDeployment = 1
$deployNestedESXiVMs = 1
$deployVCSA = 1
$setupNewVC = 1
$addESXiHostsToVC = 1
$configureVSANDiskGroup = 1
$configureVDS = 1
$clearVSANHealthCheckAlarm = 1
$setupPacificStoragePolicy = 1
$setupESXiSyslogSecurityProfile = 0
$deployExternalVM = 1
$deployVictimVM = 1
$deployNSXManager = 1
$deployNSXEdge = 1
$postDeployNSXConfig = 1
$tagVictimVM = 1
$setupPacific = 0 #Leave this to 0 for IDS PoC Lab
$moveVMsIntovApp = 0 #Leave this to 0 for IDS PoC Lab

$vcsaSize2MemoryStorageMap = @{
"tiny"=@{"cpu"="2";"mem"="12";"disk"="415"};
"small"=@{"cpu"="4";"mem"="19";"disk"="480"};
"medium"=@{"cpu"="8";"mem"="28";"disk"="700"};
"large"=@{"cpu"="16";"mem"="37";"disk"="1065"};
"xlarge"=@{"cpu"="24";"mem"="56";"disk"="1805"}
}

$nsxStorageMap = @{
"manager"="200";
"edge"="200"
}

$esxiTotalCPU = 0
$vcsaTotalCPU = 0
$nsxManagerTotalCPU = 0
$nsxEdgeTotalCPU = 0
$esxiTotalMemory = 0
$vcsaTotalMemory = 0
$nsxManagerTotalMemory = 0
$nsxEdgeTotalMemory = 0
$esxiTotalStorage = 0
$vcsaTotalStorage = 0
$nsxManagerTotalStorage = 0
$nsxEdgeTotalStorage = 0

$StartTime = Get-Date

Function Get-SSLThumbprint256 {
    param(
    [Parameter(
        Position=0,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)
    ]
    [Alias('FullName')]
    [String]$URL
    )

    $Code = @'
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

namespace CertificateCapture
{
    public class Utility
    {
        public static Func<HttpRequestMessage,X509Certificate2,X509Chain,SslPolicyErrors,Boolean> ValidationCallback =
            (message, cert, chain, errors) => {
                var newCert = new X509Certificate2(cert);
                var newChain = new X509Chain();
                newChain.Build(newCert);
                CapturedCertificates.Add(new CapturedCertificate(){
                    Certificate =  newCert,
                    CertificateChain = newChain,
                    PolicyErrors = errors,
                    URI = message.RequestUri
                });
                return true;
            };
        public static List<CapturedCertificate> CapturedCertificates = new List<CapturedCertificate>();
    }

    public class CapturedCertificate
    {
        public X509Certificate2 Certificate { get; set; }
        public X509Chain CertificateChain { get; set; }
        public SslPolicyErrors PolicyErrors { get; set; }
        public Uri URI { get; set; }
    }
}
'@
    if ($PSEdition -ne 'Core'){
        Add-Type -AssemblyName System.Net.Http
        if (-not ("CertificateCapture" -as [type])) {
            Add-Type $Code -ReferencedAssemblies System.Net.Http
        }
    } else {
        if (-not ("CertificateCapture" -as [type])) {
            Add-Type $Code
        }
    }

    $Certs = [CertificateCapture.Utility]::CapturedCertificates

    $Handler = [System.Net.Http.HttpClientHandler]::new()
    $Handler.ServerCertificateCustomValidationCallback = [CertificateCapture.Utility]::ValidationCallback
    $Client = [System.Net.Http.HttpClient]::new($Handler)
    $Result = $Client.GetAsync($Url).Result

    $sha256 = [Security.Cryptography.SHA256]::Create()
    $certBytes = $Certs[-1].Certificate.GetRawCertData()
    $hash = $sha256.ComputeHash($certBytes)
    $thumbprint = [BitConverter]::ToString($hash).Replace('-',':')
    return $thumbprint
}

Function My-Logger {
    param(
    [Parameter(Mandatory=$true)]
    [String]$message
    )

    $timeStamp = Get-Date -Format "MM-dd-yyyy_hh:mm:ss"

    Write-Host -NoNewline -ForegroundColor White "[$timestamp]"
    Write-Host -ForegroundColor Green " $message"
    $logMessage = "[$timeStamp] $message"
    $logMessage | Out-File -Append -LiteralPath $verboseLogFile
}

Function URL-Check([string] $url) {
    $isWorking = $true

    try {
        $request = [System.Net.WebRequest]::Create($url)
        $request.Method = "HEAD"
        $request.UseDefaultCredentials = $true

        $response = $request.GetResponse()
        $httpStatus = $response.StatusCode

        $isWorking = ($httpStatus -eq "OK")
    }
    catch {
        $isWorking = $false
    }
    return $isWorking
}

Function Set-VMTags {
    Param (
        [string]$VMName, [pscustomobject[]]$Tags
    )

    $inventoryvms = Get-NsxtService -name "com.vmware.nsx.fabric.virtual_machines"
    $appvm = ($inventoryvms.list().results | where { $_.display_name -eq $VMName})
    $customTags = @()
    foreach ($tag in $Tags) {
        $customtag = [pscustomobject] @{
            "tag" = $tag.Name
            "scope" = $tag.Scope
        }
        $customtags = $customtags + $customtag
    }

    $appvm.tags = $customtags
    $inventoryvms.updatetags($appvm)
}

if($preCheck -eq 1) {
    if(!(Test-Path $NestedESXiApplianceOVA)) {
        Write-Host -ForegroundColor Red "`nUnable to find $NestedESXiApplianceOVA ...`n"
        exit
    }

    if(!(Test-Path $VCSAInstallerPath)) {
        Write-Host -ForegroundColor Red "`nUnable to find $VCSAInstallerPath ...`n"
        exit
    }

    if(!(Test-Path $NSXTManagerOVA) -and $deployNSXManager -eq 1) {
        Write-Host -ForegroundColor Red "`nUnable to find $NSXTManagerOVA ...`n"
        exit
    }

    if(!(Test-Path $ExternalVMOVA) -and $deployExternalVM -eq 1) {
        Write-Host -ForegroundColor Red "`nUnable to find $ExternalVMOVA ...`n"
        exit
    }

    if(!(Test-Path $VictimVMOVA) -and $deployVictimVM -eq 1) {
        Write-Host -ForegroundColor Red "`nUnable to find $VictimVMOVA ...`n"
        exit
    }

    if($PSVersionTable.PSEdition -ne "Core") {
        Write-Host -ForegroundColor Red "`tPowerShell Core was not detected, please install that before continuing ... `n"
        exit
    }

    # pre-check VTEP Network exists
    $viConnection = Connect-VIServer $VIServer -User $VIUsername -Password $VIPassword -WarningAction SilentlyContinue
    if(! (Get-VirtualNetwork $NSXVTEPNetwork -ErrorAction 'silentlycontinue')) {
        Write-Host -ForegroundColor Red "`tUnable to locate $NSXVTEPNetwork portgroup, please create this network before continuing ... `n"
        exit
    }
    Disconnect-VIServer $viConnection -Confirm:$false

    if($NSXLicenseKey -eq "") {
        Write-Host -ForegroundColor Red "`tNSX-T License is required, please fill out `$NSXLicenseKey variable...`n"
        exit
    }
}

if($confirmDeployment -eq 1) {
    Write-Host -ForegroundColor Magenta "`nPlease confirm the following configuration will be deployed:`n"

    Write-Host -ForegroundColor Yellow "---- vSphere with Kubernetes External NSX-T Automated Lab Deployment Configuration ---- "
    Write-Host -NoNewline -ForegroundColor Green "Nested ESXi Image Path: "
    Write-Host -ForegroundColor White $NestedESXiApplianceOVA
    Write-Host -NoNewline -ForegroundColor Green "VCSA Image Path: "
    Write-Host -ForegroundColor White $VCSAInstallerPath

    if($deployNSXManager -eq 1) {
        Write-Host -NoNewline -ForegroundColor Green "NSX-T Manager Image Path: "
        Write-Host -ForegroundColor White $NSXTManagerOVA
    }
    if($deployNSXEdge -eq 1) {
        Write-Host -NoNewline -ForegroundColor Green "NSX-T Edge Image Path: "
        Write-Host -ForegroundColor White $NSXTEdgeOVA
    }

    Write-Host -ForegroundColor Yellow "`n---- vCenter Server Deployment Target Configuration ----"
    Write-Host -NoNewline -ForegroundColor Green "vCenter Server Address: "
    Write-Host -ForegroundColor White $VIServer
    Write-Host -NoNewline -ForegroundColor Green "VM Network: "
    Write-Host -ForegroundColor White $VMNetwork

    if($deployNSXManager -eq 1 -or $deployNSXEdge -eq 1) {
        Write-Host -NoNewline -ForegroundColor Green "NSX-T VTEP Network: "
        Write-Host -ForegroundColor White $NSXVTEPNetwork
    }

    Write-Host -NoNewline -ForegroundColor Green "VM Storage: "
    Write-Host -ForegroundColor White $VMDatastore
    Write-Host -NoNewline -ForegroundColor Green "VM Cluster: "
    Write-Host -ForegroundColor White $VMCluster
    Write-Host -NoNewline -ForegroundColor Green "VM vApp: "
    Write-Host -ForegroundColor White $VAppName

    Write-Host -ForegroundColor Yellow "`n---- vESXi Configuration ----"
    Write-Host -NoNewline -ForegroundColor Green "# of Nested ESXi VMs: "
    Write-Host -ForegroundColor White $NestedESXiHostnameToIPs.count
    Write-Host -NoNewline -ForegroundColor Green "vCPU: "
    Write-Host -ForegroundColor White $NestedESXivCPU
    Write-Host -NoNewline -ForegroundColor Green "vMEM: "
    Write-Host -ForegroundColor White "$NestedESXivMEM GB"
    Write-Host -NoNewline -ForegroundColor Green "Caching VMDK: "
    Write-Host -ForegroundColor White "$NestedESXiCachingvDisk GB"
    Write-Host -NoNewline -ForegroundColor Green "Capacity VMDK: "
    Write-Host -ForegroundColor White "$NestedESXiCapacityvDisk GB"
    Write-Host -NoNewline -ForegroundColor Green "IP Address(s): "
    Write-Host -ForegroundColor White $NestedESXiHostnameToIPs.Values
    Write-Host -NoNewline -ForegroundColor Green "Netmask "
    Write-Host -ForegroundColor White $VMNetmask
    Write-Host -NoNewline -ForegroundColor Green "Gateway: "
    Write-Host -ForegroundColor White $VMGateway
    Write-Host -NoNewline -ForegroundColor Green "DNS: "
    Write-Host -ForegroundColor White $VMDNS
    Write-Host -NoNewline -ForegroundColor Green "NTP: "
    Write-Host -ForegroundColor White $VMNTP
    Write-Host -NoNewline -ForegroundColor Green "Syslog: "
    Write-Host -ForegroundColor White $VMSyslog
    Write-Host -NoNewline -ForegroundColor Green "Enable SSH: "
    Write-Host -ForegroundColor White $VMSSH
    Write-Host -NoNewline -ForegroundColor Green "Create VMFS Volume: "
    Write-Host -ForegroundColor White $VMVMFS

    Write-Host -ForegroundColor Yellow "`n---- VCSA Configuration ----"
    Write-Host -NoNewline -ForegroundColor Green "Deployment Size: "
    Write-Host -ForegroundColor White $VCSADeploymentSize
    Write-Host -NoNewline -ForegroundColor Green "SSO Domain: "
    Write-Host -ForegroundColor White $VCSASSODomainName
    Write-Host -NoNewline -ForegroundColor Green "Enable SSH: "
    Write-Host -ForegroundColor White $VCSASSHEnable
    Write-Host -NoNewline -ForegroundColor Green "Hostname: "
    Write-Host -ForegroundColor White $VCSAHostname
    Write-Host -NoNewline -ForegroundColor Green "IP Address: "
    Write-Host -ForegroundColor White $VCSAIPAddress
    Write-Host -NoNewline -ForegroundColor Green "Netmask "
    Write-Host -ForegroundColor White $VMNetmask
    Write-Host -NoNewline -ForegroundColor Green "Gateway: "
    Write-Host -ForegroundColor White $VMGateway

    if($deployNSXManager -eq 1 -or $deployNSXEdge -eq 1) {
        Write-Host -ForegroundColor Yellow "`n---- NSX-T Configuration ----"
        Write-Host -NoNewline -ForegroundColor Green "NSX Manager Hostname: "
        Write-Host -ForegroundColor White $NSXTMgrHostname
        Write-Host -NoNewline -ForegroundColor Green "NSX Manager IP Address: "
        Write-Host -ForegroundColor White $NSXTMgrIPAddress

        if($deployNSXEdge -eq 1) {
            Write-Host -NoNewline -ForegroundColor Green "# of NSX Edge VMs: "
            Write-Host -ForegroundColor White $NSXTEdgeHostnameToIPs.count
            Write-Host -NoNewline -ForegroundColor Green "IP Address(s): "
            Write-Host -ForegroundColor White $NSXTEdgeHostnameToIPs.Values
        }

        Write-Host -NoNewline -ForegroundColor Green "Netmask: "
        Write-Host -ForegroundColor White $VMNetmask
        Write-Host -NoNewline -ForegroundColor Green "Gateway: "
        Write-Host -ForegroundColor White $VMGateway
        Write-Host -NoNewline -ForegroundColor Green "Enable SSH: "
        Write-Host -ForegroundColor White $NSXSSHEnable
        Write-Host -NoNewline -ForegroundColor Green "Enable Root Login: "
        Write-Host -ForegroundColor White $NSXEnableRootLogin
    }

    $esxiTotalCPU = $NestedESXiHostnameToIPs.count * [int]$NestedESXivCPU
    $esxiTotalMemory = $NestedESXiHostnameToIPs.count * [int]$NestedESXivMEM
    $esxiTotalStorage = ($NestedESXiHostnameToIPs.count * [int]$NestedESXiCachingvDisk) + ($NestedESXiHostnameToIPs.count * [int]$NestedESXiCapacityvDisk)
    $vcsaTotalCPU = $vcsaSize2MemoryStorageMap.$VCSADeploymentSize.cpu
    $vcsaTotalMemory = $vcsaSize2MemoryStorageMap.$VCSADeploymentSize.mem
    $vcsaTotalStorage = $vcsaSize2MemoryStorageMap.$VCSADeploymentSize.disk

    Write-Host -ForegroundColor Yellow "`n---- Resource Requirements ----"
    Write-Host -NoNewline -ForegroundColor Green "ESXi     VM CPU: "
    Write-Host -NoNewline -ForegroundColor White $esxiTotalCPU
    Write-Host -NoNewline -ForegroundColor Green " ESXi     VM Memory: "
    Write-Host -NoNewline -ForegroundColor White $esxiTotalMemory "GB "
    Write-Host -NoNewline -ForegroundColor Green "ESXi     VM Storage: "
    Write-Host -ForegroundColor White $esxiTotalStorage "GB"
    Write-Host -NoNewline -ForegroundColor Green "VCSA     VM CPU: "
    Write-Host -NoNewline -ForegroundColor White $vcsaTotalCPU
    Write-Host -NoNewline -ForegroundColor Green " VCSA     VM Memory: "
    Write-Host -NoNewline -ForegroundColor White $vcsaTotalMemory "GB "
    Write-Host -NoNewline -ForegroundColor Green "VCSA     VM Storage: "
    Write-Host -ForegroundColor White $vcsaTotalStorage "GB"

    if($deployNSXManager -eq 1 -or $deployNSXEdge -eq 1) {
        if($deployNSXManager -eq 1) {
            $nsxManagerTotalCPU += [int]$NSXTMgrvCPU
            $nsxManagerTotalMemory += [int]$NSXTMgrvMEM
            $nsxManagerTotalStorage += [int]$nsxStorageMap["manager"]

            Write-Host -NoNewline -ForegroundColor Green "NSX-UA   VM CPU: "
            Write-Host -NoNewline -ForegroundColor White $nsxManagerTotalCPU
            Write-Host -NoNewline -ForegroundColor Green " NSX-UA   VM Memory: "
            Write-Host -NoNewline -ForegroundColor White $nsxManagerTotalMemory "GB "
            Write-Host -NoNewline -ForegroundColor Green " NSX-UA   VM Storage: "
            Write-Host -ForegroundColor White $nsxManagerTotalStorage "GB"
        }

        if($deployNSXEdge -eq 1) {
            $nsxEdgeTotalCPU += $NSXTEdgeHostnameToIPs.count * [int]$NSXTEdgevCPU
            $nsxEdgeTotalMemory += $NSXTEdgeHostnameToIPs.count * [int]$NSXTEdgevMEM
            $nsxEdgeTotalStorage += $NSXTEdgeHostnameToIPs.count * [int]$nsxStorageMap["edge"]

            Write-Host -NoNewline -ForegroundColor Green "NSX-Edge VM CPU: "
            Write-Host -NoNewline -ForegroundColor White $nsxEdgeTotalCPU
            Write-Host -NoNewline -ForegroundColor Green " NSX-Edge VM Memory: "
            Write-Host -NoNewline -ForegroundColor White $nsxEdgeTotalMemory "GB "
            Write-Host -NoNewline -ForegroundColor Green " NSX-Edge VM Storage: "
            Write-Host -ForegroundColor White $nsxEdgeTotalStorage "GB"
        }
    }

    Write-Host -ForegroundColor White "---------------------------------------------"
    Write-Host -NoNewline -ForegroundColor Green "Total CPU: "
    Write-Host -ForegroundColor White ($esxiTotalCPU + $vcsaTotalCPU + $nsxManagerTotalCPU + $nsxEdgeTotalCPU)
    Write-Host -NoNewline -ForegroundColor Green "Total Memory: "
    Write-Host -ForegroundColor White ($esxiTotalMemory + $vcsaTotalMemory + $nsxManagerTotalMemory + $nsxEdgeTotalMemory) "GB"
    Write-Host -NoNewline -ForegroundColor Green "Total Storage: "
    Write-Host -ForegroundColor White ($esxiTotalStorage + $vcsaTotalStorage + $nsxManagerTotalStorage + $nsxEdgeTotalStorage) "GB"

    Write-Host -ForegroundColor Magenta "`nWould you like to proceed with this deployment?`n"
    $answer = Read-Host -Prompt "Do you accept (Y or N)"
    if($answer -ne "Y" -or $answer -ne "y") {
        exit
    }
    Clear-Host
}

if( $deployNestedESXiVMs -eq 1 -or $deployVCSA -eq 1 -or $deployNSXManager -eq 1 -or $deployNSXEdge -eq 1 -or $deployExternalVM -eq 1) {
    My-Logger "Connecting to Management vCenter Server $VIServer ..."
    $viConnection = Connect-VIServer $VIServer -User $VIUsername -Password $VIPassword -WarningAction SilentlyContinue

    $datastore = Get-Datastore -Server $viConnection -Name $VMDatastore | Select -First 1
    $cluster = Get-Cluster -Server $viConnection -Name $VMCluster
    $datacenter = $cluster | Get-Datacenter
    $vmhost = $cluster | Get-VMHost | Select -First 1
}

if($deployNestedESXiVMs -eq 1) {
    $NestedESXiHostnameToIPs.GetEnumerator() | Sort-Object -Property Value | Foreach-Object {
        $VMName = $_.Key
        $VMIPAddress = $_.Value

        $ovfconfig = Get-OvfConfiguration $NestedESXiApplianceOVA
        $networkMapLabel = ($ovfconfig.ToHashTable().keys | where {$_ -Match "NetworkMapping"}).replace("NetworkMapping.","").replace("-","_").replace(" ","_")
        $ovfconfig.NetworkMapping.$networkMapLabel.value = $VMNetwork

        $ovfconfig.common.guestinfo.hostname.value = $VMName
        $ovfconfig.common.guestinfo.ipaddress.value = $VMIPAddress
        $ovfconfig.common.guestinfo.netmask.value = $VMNetmask
        $ovfconfig.common.guestinfo.gateway.value = $VMGateway
        $ovfconfig.common.guestinfo.dns.value = $VMDNS
        $ovfconfig.common.guestinfo.domain.value = $VMDomain
        $ovfconfig.common.guestinfo.ntp.value = $VMNTP
        $ovfconfig.common.guestinfo.syslog.value = $VMSyslog
        $ovfconfig.common.guestinfo.password.value = $VMPassword
        if($VMSSH -eq "true") {
            $VMSSHVar = $true
        } else {
            $VMSSHVar = $false
        }
        $ovfconfig.common.guestinfo.ssh.value = $VMSSHVar

        if($configureVSANDiskGroup -eq 0) {
            $ovfconfig.common.guestinfo.createvmfs.value = $true
        }

        My-Logger "Deploying Nested ESXi VM $VMName ..."
        $vm = Import-VApp -Source $NestedESXiApplianceOVA -OvfConfiguration $ovfconfig -Name $VMName -Location $cluster -VMHost $vmhost -Datastore $datastore -DiskStorageFormat thin

        My-Logger "Adding vmnic2/vmnic3 to $NSXVTEPNetwork ..."
        New-NetworkAdapter -VM $vm -Type Vmxnet3 -NetworkName $NSXVTEPNetwork -StartConnected -confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
        New-NetworkAdapter -VM $vm -Type Vmxnet3 -NetworkName $NSXVTEPNetwork -StartConnected -confirm:$false | Out-File -Append -LiteralPath $verboseLogFile

        $vm | New-AdvancedSetting -name "ethernet2.filter4.name" -value "dvfilter-maclearn" -confirm:$false -ErrorAction SilentlyContinue | Out-File -Append -LiteralPath $verboseLogFile
        $vm | New-AdvancedSetting -Name "ethernet2.filter4.onFailure" -value "failOpen" -confirm:$false -ErrorAction SilentlyContinue | Out-File -Append -LiteralPath $verboseLogFile

        $vm | New-AdvancedSetting -name "ethernet3.filter4.name" -value "dvfilter-maclearn" -confirm:$false -ErrorAction SilentlyContinue | Out-File -Append -LiteralPath $verboseLogFile
        $vm | New-AdvancedSetting -Name "ethernet3.filter4.onFailure" -value "failOpen" -confirm:$false -ErrorAction SilentlyContinue | Out-File -Append -LiteralPath $verboseLogFile

        My-Logger "Updating vCPU Count to $NestedESXivCPU & vMEM to $NestedESXivMEM GB ..."
        Set-VM -Server $viConnection -VM $vm -NumCpu $NestedESXivCPU -MemoryGB $NestedESXivMEM -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile

        if($configureVSANDiskGroup -eq 1) {
            My-Logger "Updating vSAN Cache VMDK size to $NestedESXiCachingvDisk GB & Capacity VMDK size to $NestedESXiCapacityvDisk GB ..."
            Get-HardDisk -Server $viConnection -VM $vm -Name "Hard disk 2" | Set-HardDisk -CapacityGB $NestedESXiCachingvDisk -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
            Get-HardDisk -Server $viConnection -VM $vm -Name "Hard disk 3" | Set-HardDisk -CapacityGB $NestedESXiCapacityvDisk -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
        } else {
            Get-HardDisk -Server $viConnection -VM $vm -Name "Hard disk 3" | Set-HardDisk -CapacityGB $NestedESXiCapacityvDisk -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
        }

        My-Logger "Powering On $vmname ..."
        $vm | Start-Vm -RunAsync | Out-Null
    }
}

if ($setupESXiSyslogSecurityProfile -eq 1) {
    foreach ($hostobj in Get-VMHost) {
        My-Logger "Editing Security Profile on host $hostobj to allow Syslog"
        $h = Get-View -Id $hostobj.Id
        $hostconfig = $h.ConfigManager
        $type = $hostconfig.FirewallSystem.Type
        $value = $hostconfig.FirewallSystem.Value
        $id = 'syslog'
        $securityprofile = Get-View -Id $type-$value
        $securityprofile.EnableRuleset($id)
    }
}

if($deployNSXManager -eq 1) {
    # Deploy NSX Manager
    $nsxMgrOvfConfig = Get-OvfConfiguration $NSXTManagerOVA
    $nsxMgrOvfConfig.DeploymentOption.Value = $NSXTMgrDeploymentSize
    $nsxMgrOvfConfig.NetworkMapping.Network_1.value = $VMNetwork

    $nsxMgrOvfConfig.Common.nsx_role.Value = "NSX Manager"
    $nsxMgrOvfConfig.Common.nsx_hostname.Value = $NSXTMgrHostname
    $nsxMgrOvfConfig.Common.nsx_ip_0.Value = $NSXTMgrIPAddress
    $nsxMgrOvfConfig.Common.nsx_netmask_0.Value = $VMNetmask
    $nsxMgrOvfConfig.Common.nsx_gateway_0.Value = $VMGateway
    $nsxMgrOvfConfig.Common.nsx_dns1_0.Value = $VMDNS
    $nsxMgrOvfConfig.Common.nsx_domain_0.Value = $VMDomain
    $nsxMgrOvfConfig.Common.nsx_ntp_0.Value = $VMNTP

    if($NSXSSHEnable -eq "true") {
        $NSXSSHEnableVar = $true
    } else {
        $NSXSSHEnableVar = $false
    }
    $nsxMgrOvfConfig.Common.nsx_isSSHEnabled.Value = $NSXSSHEnableVar
    if($NSXEnableRootLogin -eq "true") {
        $NSXRootPasswordVar = $true
    } else {
        $NSXRootPasswordVar = $false
    }
    $nsxMgrOvfConfig.Common.nsx_allowSSHRootLogin.Value = $NSXRootPasswordVar

    $nsxMgrOvfConfig.Common.nsx_passwd_0.Value = $NSXRootPassword
    $nsxMgrOvfConfig.Common.nsx_cli_username.Value = $NSXAdminUsername
    $nsxMgrOvfConfig.Common.nsx_cli_passwd_0.Value = $NSXAdminPassword
    $nsxMgrOvfConfig.Common.nsx_cli_audit_username.Value = $NSXAuditUsername
    $nsxMgrOvfConfig.Common.nsx_cli_audit_passwd_0.Value = $NSXAuditPassword

    My-Logger "Deploying NSX Manager VM $NSXTMgrDisplayName ..."
    $nsxmgr_vm = Import-VApp -Source $NSXTManagerOVA -OvfConfiguration $nsxMgrOvfConfig -Name $NSXTMgrDisplayName -Location $cluster -VMHost $vmhost -Datastore $datastore -DiskStorageFormat thin

    My-Logger "Updating vCPU Count to $NSXTMgrvCPU & vMEM to $NSXTMgrvMEM GB ..."
    Set-VM -Server $viConnection -VM $nsxmgr_vm -NumCpu $NSXTMgrvCPU -MemoryGB $NSXTMgrvMEM -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile

    My-Logger "Disabling vCPU Reservation ..."
    Get-VM -Server $viConnection -Name $nsxmgr_vm | Get-VMResourceConfiguration | Set-VMResourceConfiguration -CpuReservationMhz 0 | Out-File -Append -LiteralPath $verboseLogFile

    My-Logger "Powering On $NSXTMgrDisplayName ..."
    $nsxmgr_vm | Start-Vm -RunAsync | Out-Null
}

if($deployVCSA -eq 1) {
        if($IsWindows) {
            $config = (Get-Content -Raw "$($VCSAInstallerPath)\vcsa-cli-installer\templates\install\embedded_vCSA_on_VC.json") | convertfrom-json
        } else {
            $config = (Get-Content -Raw "$($VCSAInstallerPath)/vcsa-cli-installer/templates/install/embedded_vCSA_on_VC.json") | convertfrom-json
        }
        $config.'new_vcsa'.vc.hostname = $VIServer
        $config.'new_vcsa'.vc.username = $VIUsername
        $config.'new_vcsa'.vc.password = $VIPassword
        $config.'new_vcsa'.vc.deployment_network = $VMNetwork
        $config.'new_vcsa'.vc.datastore = $datastore
        $config.'new_vcsa'.vc.datacenter = $datacenter.name
        $config.'new_vcsa'.vc.target = $VMCluster
        $config.'new_vcsa'.appliance.thin_disk_mode = $true
        $config.'new_vcsa'.appliance.deployment_option = $VCSADeploymentSize
        $config.'new_vcsa'.appliance.name = $VCSADisplayName
        $config.'new_vcsa'.network.ip_family = "ipv4"
        $config.'new_vcsa'.network.mode = "static"
        $config.'new_vcsa'.network.ip = $VCSAIPAddress
        $config.'new_vcsa'.network.dns_servers[0] = $VMDNS
        $config.'new_vcsa'.network.prefix = $VCSAPrefix
        $config.'new_vcsa'.network.gateway = $VMGateway
        $config.'new_vcsa'.os.ntp_servers = $VMNTP
        $config.'new_vcsa'.network.system_name = $VCSAHostname
        $config.'new_vcsa'.os.password = $VCSARootPassword
        if($VCSASSHEnable -eq "true") {
            $VCSASSHEnableVar = $true
        } else {
            $VCSASSHEnableVar = $false
        }
        $config.'new_vcsa'.os.ssh_enable = $VCSASSHEnableVar
        $config.'new_vcsa'.sso.password = $VCSASSOPassword
        $config.'new_vcsa'.sso.domain_name = $VCSASSODomainName

        if($IsWindows) {
            My-Logger "Creating VCSA JSON Configuration file for deployment ..."
            $config | ConvertTo-Json | Set-Content -Path "$($ENV:Temp)\jsontemplate.json"

            My-Logger "Deploying the VCSA ..."
            Invoke-Expression "$($VCSAInstallerPath)\vcsa-cli-installer\win32\vcsa-deploy.exe install --no-esx-ssl-verify --accept-eula --acknowledge-ceip $($ENV:Temp)\jsontemplate.json"| Out-File -Append -LiteralPath $verboseLogFile
        } elseif($IsMacOS) {
            My-Logger "Creating VCSA JSON Configuration file for deployment ..."
            $config | ConvertTo-Json | Set-Content -Path "$($ENV:TMPDIR)jsontemplate.json"

            My-Logger "Deploying the VCSA ..."
            Invoke-Expression "$($VCSAInstallerPath)/vcsa-cli-installer/mac/vcsa-deploy install --no-esx-ssl-verify --accept-eula --acknowledge-ceip $($ENV:TMPDIR)jsontemplate.json"| Out-File -Append -LiteralPath $verboseLogFile
        } elseif ($IsLinux) {
            My-Logger "Creating VCSA JSON Configuration file for deployment ..."
            $config | ConvertTo-Json | Set-Content -Path "/tmp/jsontemplate.json"

            My-Logger "Deploying the VCSA ..."
            Invoke-Expression "$($VCSAInstallerPath)/vcsa-cli-installer/lin64/vcsa-deploy install --no-esx-ssl-verify --accept-eula --acknowledge-ceip /tmp/jsontemplate.json"| Out-File -Append -LiteralPath $verboseLogFile
        }
}

if($deployNSXEdge -eq 1) {
    My-Logger "Setting up NSX-T Edge to join NSX-T Management Plane ..."
    if(!(Connect-NsxtServer -Server $NSXTMgrHostname -Username $NSXAdminUsername -Password $NSXAdminPassword -WarningAction SilentlyContinue)) {
        Write-Host -ForegroundColor Red "Unable to connect to NSX-T Manager, please check the deployment"
        exit
    } else {
        My-Logger "Successfully logged into NSX-T Manager $NSXTMgrHostname  ..."
    }

    # Retrieve NSX Manager Thumbprint which will be needed later
    My-Logger "Retrieving NSX Manager Thumbprint ..."
    $nsxMgrID = ((Get-NsxtService -Name "com.vmware.nsx.cluster.nodes").list().results | where {$_.manager_role -ne $null}).id
    $nsxMgrCertThumbprint = (Get-NsxtService -Name "com.vmware.nsx.cluster.nodes").get($nsxMgrID).manager_role.api_listen_addr.certificate_sha256_thumbprint

    My-Logger "Accepting NSX Manager EULA ..."
    $eulaService = Get-NsxtService -Name "com.vmware.nsx.eula.accept"
    $eulaService.create()

    $LicenseService = Get-NsxtService -Name "com.vmware.nsx.licenses"
    $LicenseSpec = $LicenseService.Help.create.license.Create()
    $LicenseSpec.license_key = $NSXLicenseKey
    $LicenseResult = $LicenseService.create($LicenseSpec)

    My-Logger "Disconnecting from NSX-T Manager ..."
    Disconnect-NsxtServer -Confirm:$false

    # Deploy Edges
    $nsxEdgeOvfConfig = Get-OvfConfiguration $NSXTEdgeOVA
    $NSXTEdgeHostnameToIPs.GetEnumerator() | Sort-Object -Property Value | Foreach-Object {
        $VMName = $_.Key
        $VMIPAddress = $_.Value
        $VMHostname = "$VMName" + "." + $VMDomain

        $nsxEdgeOvfConfig.DeploymentOption.Value = $NSXTEdgeDeploymentSize
        $nsxEdgeOvfConfig.NetworkMapping.Network_0.value = $VMNetwork
        $nsxEdgeOvfConfig.NetworkMapping.Network_1.value = $NSXVTEPNetwork
        $nsxEdgeOvfConfig.NetworkMapping.Network_2.value = $VMNetwork
        $nsxEdgeOvfConfig.NetworkMapping.Network_3.value = $VMNetwork

        $nsxEdgeOvfConfig.Common.nsx_hostname.Value = $VMHostname
        $nsxEdgeOvfConfig.Common.nsx_ip_0.Value = $VMIPAddress
        $nsxEdgeOvfConfig.Common.nsx_netmask_0.Value = $VMNetmask
        $nsxEdgeOvfConfig.Common.nsx_gateway_0.Value = $VMGateway
        $nsxEdgeOvfConfig.Common.nsx_dns1_0.Value = $VMDNS
        $nsxEdgeOvfConfig.Common.nsx_domain_0.Value = $VMDomain
        $nsxEdgeOvfConfig.Common.nsx_ntp_0.Value = $VMNTP

        $nsxEdgeOvfConfig.Common.mpUser.Value = $NSXAdminUsername
        $nsxEdgeOvfConfig.Common.mpPassword.Value = $NSXAdminPassword
        $nsxEdgeOvfConfig.Common.mpIp.Value = $NSXTMgrIPAddress
        $nsxEdgeOvfConfig.Common.mpThumbprint.Value = $nsxMgrCertThumbprint

        if($NSXSSHEnable -eq "true") {
            $NSXSSHEnableVar = $true
        } else {
            $NSXSSHEnableVar = $false
        }
        $nsxEdgeOvfConfig.Common.nsx_isSSHEnabled.Value = $NSXSSHEnableVar
        if($NSXEnableRootLogin -eq "true") {
            $NSXRootPasswordVar = $true
        } else {
            $NSXRootPasswordVar = $false
        }
        $nsxEdgeOvfConfig.Common.nsx_allowSSHRootLogin.Value = $NSXRootPasswordVar

        $nsxEdgeOvfConfig.Common.nsx_passwd_0.Value = $NSXRootPassword
        $nsxEdgeOvfConfig.Common.nsx_cli_username.Value = $NSXAdminUsername
        $nsxEdgeOvfConfig.Common.nsx_cli_passwd_0.Value = $NSXAdminPassword
        $nsxEdgeOvfConfig.Common.nsx_cli_audit_username.Value = $NSXAuditUsername
        $nsxEdgeOvfConfig.Common.nsx_cli_audit_passwd_0.Value = $NSXAuditPassword

        My-Logger "Deploying NSX Edge VM $VMName ..."
        $nsxedge_vm = Import-VApp -Source $NSXTEdgeOVA -OvfConfiguration $nsxEdgeOvfConfig -Name $VMName -Location $cluster -VMHost $vmhost -Datastore $datastore -DiskStorageFormat thin

        My-Logger "Updating vCPU Count to $NSXTEdgevCPU & vMEM to $NSXTEdgevMEM GB ..."
        Set-VM -Server $viConnection -VM $nsxedge_vm -NumCpu $NSXTEdgevCPU -MemoryGB $NSXTEdgevMEM -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile

        My-Logger "Powering On $VMName ..."
        $nsxedge_vm | Start-Vm -RunAsync | Out-Null
    }
}

if($moveVMsIntovApp -eq 1) {
    My-Logger "Creating vApp $VAppName ..."
    $VApp = New-VApp -Name $VAppName -Server $viConnection -Location $cluster

    if(-Not (Get-Folder $VMFolder -ErrorAction Ignore)) {
        My-Logger "Creating VM Folder $VMFolder ..."
        $folder = New-Folder -Name $VMFolder -Server $viConnection -Location (Get-Datacenter $VMDatacenter | Get-Folder vm)
    }

    if($deployNestedESXiVMs -eq 1) {
        My-Logger "Moving Nested ESXi VMs into $VAppName vApp ..."
        $NestedESXiHostnameToIPs.GetEnumerator() | Sort-Object -Property Value | Foreach-Object {
            $vm = Get-VM -Name $_.Key -Server $viConnection
            Move-VM -VM $vm -Server $viConnection -Destination $VApp -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
        }
    }

    if($deployVCSA -eq 1) {
        $vcsaVM = Get-VM -Name $VCSADisplayName -Server $viConnection
        My-Logger "Moving $VCSADisplayName into $VAppName vApp ..."
        Move-VM -VM $vcsaVM -Server $viConnection -Destination $VApp -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
    }

    if($deployNSXManager -eq 1) {
        $nsxMgrVM = Get-VM -Name $NSXTMgrDisplayName -Server $viConnection
        My-Logger "Moving $NSXTMgrDisplayName into $VAppName vApp ..."
        Move-VM -VM $nsxMgrVM -Server $viConnection -Destination $VApp -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
    }

    if($deployNSXEdge -eq 1) {
        My-Logger "Moving NSX Edge VMs into $VAppName vApp ..."
        $NSXTEdgeHostnameToIPs.GetEnumerator() | Sort-Object -Property Value | Foreach-Object {
            $nsxEdgeVM = Get-VM -Name $_.Key -Server $viConnection
            Move-VM -VM $nsxEdgeVM -Server $viConnection -Destination $VApp -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
        }
    }

    My-Logger "Moving $VAppName to VM Folder $VMFolder ..."
    Move-VApp -Server $viConnection $VAppName -Destination (Get-Folder -Server $viConnection $VMFolder) | Out-File -Append -LiteralPath $verboseLogFile
}

if ($deployExternalVM) {
    $externalVMOvfConfig = Get-OvfConfiguration -Server $viConnection $ExternalVMOVA

    My-Logger "Deploying External VM $ExternalVM ..."
    $vm = Import-VApp -Server $viConnection -Source $ExternalVMOVA -OvfConfiguration $externalVMOvfConfig -Name $ExternalVM -Location $cluster -VMHost $vmhost -Datastore $datastore -DiskStorageFormat thin
    My-Logger "Reconfiguring VM $ExternalVM network to $VMNetwork ..."
    $vm | Get-NetworkAdapter -Server $viConnection | Set-NetworkAdapter -Server $viConnection -Portgroup $VMNetwork -Confirm:$false | Out-Null
    My-Logger "Powering On $ExternalVM ..."
    $vm | Start-Vm -Server $viConnection -RunAsync | Out-Null
}

if( $deployNestedESXiVMs -eq 1 -or $deployVCSA -eq 1 -or $deployNSXManager -eq 1 -or $deployNSXEdge -eq 1 -or $deployExternalVM -eq 1) {
    My-Logger "Disconnecting from $VIServer ..."
    Disconnect-VIServer -Server $viConnection -Confirm:$false
}

if ($setupNewVC -eq 1 -or $deployVictimVM -eq 1) {
    My-Logger "Connecting to the new VCSA ..."
    $vc = Connect-VIServer $VCSAIPAddress -User "administrator@$VCSASSODomainName" -Password $VCSASSOPassword -WarningAction SilentlyContinue
}

if($setupNewVC -eq 1) {
    $d = Get-Datacenter -Server $vc $NewVCDatacenterName -ErrorAction Ignore
    if( -Not $d) {
        My-Logger "Creating Datacenter $NewVCDatacenterName ..."
        New-Datacenter -Server $vc -Name $NewVCDatacenterName -Location (Get-Folder -Type Datacenter -Server $vc) | Out-File -Append -LiteralPath $verboseLogFile
    }

    $c = Get-Cluster -Server $vc $NewVCVSANClusterName -ErrorAction Ignore
    if( -Not $c) {
        if($configureVSANDiskGroup -eq 1) {
            My-Logger "Creating VSAN Cluster $NewVCVSANClusterName ..."
            New-Cluster -Server $vc -Name $NewVCVSANClusterName -Location (Get-Datacenter -Name $NewVCDatacenterName -Server $vc) -DrsEnabled -HAEnabled -VsanEnabled | Out-File -Append -LiteralPath $verboseLogFile
        } else {
            My-Logger "Creating vSphere Cluster $NewVCVSANClusterName ..."
            New-Cluster -Server $vc -Name $NewVCVSANClusterName -Location (Get-Datacenter -Name $NewVCDatacenterName -Server $vc) -DrsEnabled -HAEnabled | Out-File -Append -LiteralPath $verboseLogFile
        }
        (Get-Cluster $NewVCVSANClusterName) | New-AdvancedSetting -Name "das.ignoreRedundantNetWarning" -Type ClusterHA -Value $true -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
    }

    if($addESXiHostsToVC -eq 1) {
        $NestedESXiHostnameToIPs.GetEnumerator() | Sort-Object -Property Value | Foreach-Object {
            $VMName = $_.Key
            $VMIPAddress = $_.Value

            $targetVMHost = $VMIPAddress
            if($addHostByDnsName -eq 1) {
                $targetVMHost = $VMName
            }
            My-Logger "Adding ESXi host $targetVMHost to Cluster ..."
            Add-VMHost -Server $vc -Location (Get-Cluster -Name $NewVCVSANClusterName) -User "root" -Password $VMPassword -Name $targetVMHost -Force | Out-File -Append -LiteralPath $verboseLogFile
        }
    }

    if($configureVSANDiskGroup -eq 1) {
        My-Logger "Enabling VSAN & disabling VSAN Health Check ..."
        Get-VsanClusterConfiguration -Server $vc -Cluster $NewVCVSANClusterName | Set-VsanClusterConfiguration -HealthCheckIntervalMinutes 0 | Out-File -Append -LiteralPath $verboseLogFile

        foreach ($vmhost in Get-Cluster -Server $vc | Get-VMHost) {
            $luns = $vmhost | Get-ScsiLun | select CanonicalName, CapacityGB

            My-Logger "Querying ESXi host disks to create VSAN Diskgroups ..."
            foreach ($lun in $luns) {
                if(([int]($lun.CapacityGB)).toString() -eq "$NestedESXiCachingvDisk") {
                    $vsanCacheDisk = $lun.CanonicalName
                }
                if(([int]($lun.CapacityGB)).toString() -eq "$NestedESXiCapacityvDisk") {
                    $vsanCapacityDisk = $lun.CanonicalName
                }
            }
            My-Logger "Creating VSAN DiskGroup for $vmhost ..."
            New-VsanDiskGroup -Server $vc -VMHost $vmhost -SsdCanonicalName $vsanCacheDisk -DataDiskCanonicalName $vsanCapacityDisk | Out-File -Append -LiteralPath $verboseLogFile
        }
    } else {
        foreach ($vmhost in Get-Cluster -Server $vc | Get-VMHost) {
            $localDS = ($vmhost | Get-Datastore) | where {$_.type -eq "VMFS"}
            $localDS | Set-Datastore -Server $vc -Name "not-supported-datastore" | Out-File -Append -LiteralPath $verboseLogFile
        }
    }

    if($configureVDS -eq 1) {
        $vds = New-VDSwitch -Server $vc  -Name $NewVCVDSName -Location (Get-Datacenter -Name $NewVCDatacenterName) -Mtu 1600

        New-VDPortgroup -Server $vc -Name $NewVCDVPGName -Vds $vds | Out-File -Append -LiteralPath $verboseLogFile

        foreach ($vmhost in Get-Cluster -Server $vc | Get-VMHost) {
            My-Logger "Adding $vmhost to $NewVCVDSName"
            $vds | Add-VDSwitchVMHost -VMHost $vmhost | Out-Null

            $vmhostNetworkAdapter = Get-VMHost $vmhost | Get-VMHostNetworkAdapter -Physical -Name vmnic1
            $vds | Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $vmhostNetworkAdapter -Confirm:$false
        }
    }

    if($clearVSANHealthCheckAlarm -eq 1) {
        My-Logger "Clearing default VSAN Health Check Alarms, not applicable in Nested ESXi env ..."
        $alarmMgr = Get-View AlarmManager -Server $vc
        Get-Cluster -Server $vc | where {$_.ExtensionData.TriggeredAlarmState} | %{
            $cluster = $_
            $Cluster.ExtensionData.TriggeredAlarmState | %{
                $alarmMgr.AcknowledgeAlarm($_.Alarm,$cluster.ExtensionData.MoRef)
            }
        }
        $alarmSpec = New-Object VMware.Vim.AlarmFilterSpec
        $alarmMgr.ClearTriggeredAlarms($alarmSpec)
    }

    # Final configure and then exit maintanence mode in case patching was done earlier
    foreach ($vmhost in Get-Cluster -Server $vc | Get-VMHost) {
        # Disable Core Dump Warning
        Get-AdvancedSetting -Entity $vmhost -Name UserVars.SuppressCoredumpWarning | Set-AdvancedSetting -Value 1 -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile

        # Enable vMotion traffic
        $vmhost | Get-VMHostNetworkAdapter -VMKernel | Set-VMHostNetworkAdapter -VMotionEnabled $true -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile

        if($vmhost.ConnectionState -eq "Maintenance") {
            Set-VMHost -VMhost $vmhost -State Connected -RunAsync -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
        }
    }

    if($setupPacificStoragePolicy) {
        if($configureVSANDiskGroup -eq 1) {
            $datastoreName = $NewDatastore
        } else {
            $datastoreName = ((Get-Cluster -Server $vc | Get-VMHost | Select -First 1 | Get-Datastore) | where {$_.type -eq "VMFS"}).name
        }
        My-Logger "Creating Project Pacific Storage Policies and attaching to $datastoreName ..."
        New-TagCategory -Server $vc -Name $StoragePolicyTagCategory -Cardinality single -EntityType Datastore | Out-File -Append -LiteralPath $verboseLogFile
        New-Tag -Server $vc -Name $StoragePolicyTagName -Category $StoragePolicyTagCategory | Out-File -Append -LiteralPath $verboseLogFile
        Get-Datastore -Server $vc -Name $datastoreName | New-TagAssignment -Server $vc -Tag $StoragePolicyTagName | Out-File -Append -LiteralPath $verboseLogFile
        New-SpbmStoragePolicy -Server $vc -Name $StoragePolicyName -AnyOfRuleSets (New-SpbmRuleSet -Name "pacific-ruleset" -AllOfRules (New-SpbmRule -AnyOfTags (Get-Tag $StoragePolicyTagName))) | Out-File -Append -LiteralPath $verboseLogFile
    }
}

if ($postDeployNSXConfig -eq 1 -or $tagVictimVM -eq 1) {
    My-Logger "Connecting to NSX-T Manager for post-deployment configuration ..."
    if(!(Connect-NsxtServer -Server $NSXTMgrHostname -Username $NSXAdminUsername -Password $NSXAdminPassword -WarningAction SilentlyContinue)) {
        Write-Host -ForegroundColor Red "Unable to connect to NSX-T Manager, please check the deployment"
        exit
    } else {
        My-Logger "Successfully logged into NSX-T Manager $NSXTMgrHostname  ..."
    }
}

if($postDeployNSXConfig -eq 1) {
    $runHealth = 1
    $runCEIP = 1
    $runAddVC = 1
    $runIPPool = 1
    $runTransportZone = 1
    $runUplinkProfile = 1
    $runTransportNodeProfile = 1
    $runAddEsxiTransportNode = 1
    $runAddEdgeTransportNode = 1
    $runAddEdgeCluster = 1
    $runNetworkSegment = 1
    $createDHCPProfile = 1
    $runT0Gateway = 1
    $runT0StaticRoute = 1
    $registervCenterOIDC = 1
    $createSegments = 1
    $configureNAT = 1

    if($runHealth -eq 1) {
        My-Logger "Verifying health of all NSX Manager/Controller Nodes ..."
        $clusterNodeService = Get-NsxtService -Name "com.vmware.nsx.cluster.nodes"
        $clusterNodeStatusService = Get-NsxtService -Name "com.vmware.nsx.cluster.nodes.status"
        $nodes = $clusterNodeService.list().results
        $mgmtNodes = $nodes | where { $_.controller_role -eq $null }
        $controllerNodes = $nodes | where { $_.manager_role -eq $null }

        foreach ($mgmtNode in $mgmtNodes) {
            $mgmtNodeId = $mgmtNode.id
            $mgmtNodeName = $mgmtNode.appliance_mgmt_listen_addr

            if($debug) { My-Logger "Check health status of Mgmt Node $mgmtNodeName ..." }
            while ( $clusterNodeStatusService.get($mgmtNodeId).mgmt_cluster_status.mgmt_cluster_status -ne "CONNECTED") {
                if($debug) { My-Logger "$mgmtNodeName is not ready, sleeping 20 seconds ..." }
                Start-Sleep 20
            }
        }

        foreach ($controllerNode in $controllerNodes) {
            $controllerNodeId = $controllerNode.id
            $controllerNodeName = $controllerNode.controller_role.control_plane_listen_addr.ip_address

            if($debug) { My-Logger "Checking health of Ctrl Node $controllerNodeName ..." }
            while ( $clusterNodeStatusService.get($controllerNodeId).control_cluster_status.control_cluster_status -ne "CONNECTED") {
                if($debug) { My-Logger "$controllerNodeName is not ready, sleeping 20 seconds ..." }
                Start-Sleep 20
            }
        }
    }

    if($runCEIP -eq 1) {
        My-Logger "Accepting CEIP Agreement ..."
        $ceipAgreementService = Get-NsxtService -Name "com.vmware.nsx.telemetry.agreement"
        $ceipAgreementSpec = $ceipAgreementService.get()
        $ceipAgreementSpec.telemetry_agreement_displayed = $true
        $agreementResult = $ceipAgreementService.update($ceipAgreementSpec)
    }

    if($runAddVC -eq 1) {
        My-Logger "Adding vCenter Server Compute Manager ..."
        $computeManagerSerivce = Get-NsxtService -Name "com.vmware.nsx.fabric.compute_managers"
        $computeManagerStatusService = Get-NsxtService -Name "com.vmware.nsx.fabric.compute_managers.status"

        $computeManagerSpec = $computeManagerSerivce.help.create.compute_manager.Create()
        $credentialSpec = $computeManagerSerivce.help.create.compute_manager.credential.username_password_login_credential.Create()
        $VCUsername = "administrator@$VCSASSODomainName"
        $VCURL = "https://" + $VCSAHostname + ":443"
        $VCThumbprint = Get-SSLThumbprint256 -URL $VCURL
        $credentialSpec.username = $VCUsername
        $credentialSpec.password = $VCSASSOPassword
        $credentialSpec.thumbprint = $VCThumbprint
        $computeManagerSpec.server = $VCSAHostname
        $computeManagerSpec.origin_type = "vCenter"
        $computeManagerSpec.display_name = $VCSAHostname
        $computeManagerSpec.credential = $credentialSpec
        $computeManagerResult = $computeManagerSerivce.create($computeManagerSpec)

        if($debug) { My-Logger "Waiting for VC registration to complete ..." }
            while ( $computeManagerStatusService.get($computeManagerResult.id).registration_status -ne "REGISTERED") {
                if($debug) { My-Logger "$VCSAHostname is not ready, sleeping 30 seconds ..." }
                Start-Sleep 30
        }
    }

    if($runIPPool -eq 1) {
        My-Logger "Creating Tunnel Endpoint IP Pool ..."
        $ipPoolService = Get-NsxtService -Name "com.vmware.nsx.pools.ip_pools"
        $ipPoolSpec = $ipPoolService.help.create.ip_pool.Create()
        $subNetSpec = $ipPoolService.help.create.ip_pool.subnets.Element.Create()
        $allocationRangeSpec = $ipPoolService.help.create.ip_pool.subnets.Element.allocation_ranges.Element.Create()

        $allocationRangeSpec.start = $TunnelEndpointIPRangeStart
        $allocationRangeSpec.end = $TunnelEndpointIPRangeEnd
        $addResult = $subNetSpec.allocation_ranges.Add($allocationRangeSpec)
        $subNetSpec.cidr = $TunnelEndpointCIDR
        $subNetSpec.gateway_ip = $TunnelEndpointGateway
        $ipPoolSpec.display_name = $TunnelEndpointName
        $ipPoolSpec.description = $TunnelEndpointDescription
        $addResult = $ipPoolSpec.subnets.Add($subNetSpec)
        $ipPool = $ipPoolService.create($ipPoolSpec)
    }

    if($runTransportZone -eq 1) {
        My-Logger "Creating Overlay & VLAN Transport Zones ..."

        $transportZoneService = Get-NsxtService -Name "com.vmware.nsx.transport_zones"
        $overlayTZSpec = $transportZoneService.help.create.transport_zone.Create()
        $overlayTZSpec.display_name = $OverlayTransportZoneName
        $overlayTZSpec.host_switch_name = $OverlayTransportZoneHostSwitchName
        $overlayTZSpec.transport_type = "OVERLAY"
        $overlayTZ = $transportZoneService.create($overlayTZSpec)

        $vlanTZSpec = $transportZoneService.help.create.transport_zone.Create()
        $vlanTZSpec.display_name = $VLANTransportZoneName
        $vlanTZSpec.host_switch_name = $VlanTransportZoneNameHostSwitchName
        $vlanTZSpec.transport_type = "VLAN"
        $vlanTZ = $transportZoneService.create($vlanTZSpec)
    }

    if($runUplinkProfile -eq 1) {
        $hostSwitchProfileService = Get-NsxtService -Name "com.vmware.nsx.host_switch_profiles"

        My-Logger "Creating ESXi Uplink Profile ..."
        $ESXiUplinkProfileSpec = $hostSwitchProfileService.help.create.base_host_switch_profile.uplink_host_switch_profile.Create()
        $activeUplinkSpec = $hostSwitchProfileService.help.create.base_host_switch_profile.uplink_host_switch_profile.teaming.active_list.Element.Create()
        $activeUplinkSpec.uplink_name = $ESXiUplinkName
        $activeUplinkSpec.uplink_type = "PNIC"
        $ESXiUplinkProfileSpec.display_name = $ESXiUplinkProfileName
        $ESXiUplinkProfileSpec.transport_vlan = $ESXiUplinkProfileTransportVLAN
        $addActiveUplink = $ESXiUplinkProfileSpec.teaming.active_list.Add($activeUplinkSpec)
        $ESXiUplinkProfileSpec.teaming.policy = $ESXiUplinkProfilePolicy
        $ESXiUplinkProfile = $hostSwitchProfileService.create($ESXiUplinkProfileSpec)

        My-Logger "Creating Edge Uplink Profile ..."
        $EdgeUplinkProfileSpec = $hostSwitchProfileService.help.create.base_host_switch_profile.uplink_host_switch_profile.Create()
        $activeUplinkSpec = $hostSwitchProfileService.help.create.base_host_switch_profile.uplink_host_switch_profile.teaming.active_list.Element.Create()
        $activeUplinkSpec.uplink_name = $EdgeUplinkName
        $activeUplinkSpec.uplink_type = "PNIC"
        $EdgeUplinkProfileSpec.display_name = $EdgeUplinkProfileName
        $EdgeUplinkProfileSpec.mtu = $EdgeUplinkProfileMTU
        $EdgeUplinkProfileSpec.transport_vlan = $EdgeUplinkProfileTransportVLAN
        $addActiveUplink = $EdgeUplinkProfileSpec.teaming.active_list.Add($activeUplinkSpec)
        $EdgeUplinkProfileSpec.teaming.policy = $EdgeUplinkProfilePolicy
        $EdgeUplinkProfile = $hostSwitchProfileService.create($EdgeUplinkProfileSpec)
    }

    if($runTransportNodeProfile -eq 1) {
        $vc = Connect-VIServer $VCSAIPAddress -User "administrator@$VCSASSODomainName" -Password $VCSASSOPassword -WarningAction SilentlyContinue

        # Retrieve VDS UUID from vCenter Server
        $VDS = (Get-VDSwitch -Server $vc -Name $NewVCVDSName).ExtensionData
        $VDSUuid = $VDS.Uuid
        Disconnect-VIServer $vc -Confirm:$false

        $hostswitchProfileSerivce = Get-NsxtService -Name "com.vmware.nsx.host_switch_profiles"

        $ipPool = (Get-NsxtService -Name "com.vmware.nsx.pools.ip_pools").list().results | where { $_.display_name -eq $TunnelEndpointName }
        $OverlayTZ = (Get-NsxtService -Name "com.vmware.nsx.transport_zones").list().results | where { $_.display_name -eq $OverlayTransportZoneName }
        $ESXiUplinkProfile = $hostswitchProfileSerivce.list().results | where { $_.display_name -eq $ESXiUplinkProfileName }

        $esxiIpAssignmentSpec = [pscustomobject] @{
            "resource_type" = "StaticIpPoolSpec";
            "ip_pool_id" = $ipPool.id;
        }

        $edgeIpAssignmentSpec = [pscustomobject] @{
            "resource_type" = "AssignedByDhcp";
        }

        $hostTransportZoneEndpoints = @(@{"transport_zone_id"=$OverlayTZ.id})

        $esxiHostswitchSpec = [pscustomobject] @{
            "host_switch_name" = $OverlayTransportZoneHostSwitchName;
            "host_switch_mode" = "STANDARD";
            "host_switch_type" = "VDS";
            "host_switch_id" = $VDSUuid;
            "uplinks" = @(@{"uplink_name"=$ESXiUplinkName;"vds_uplink_name"=$ESXiUplinkName})
            "ip_assignment_spec" = $esxiIpAssignmentSpec;
            "host_switch_profile_ids" = @(@{"key"="UplinkHostSwitchProfile";"value"=$ESXiUplinkProfile.id})
            "transport_zone_endpoints" = $hostTransportZoneEndpoints;
        }

        $json = [pscustomobject] @{
            "resource_type" = "TransportNode";
            "display_name" = $TransportNodeProfileName;
            "host_switch_spec" = [pscustomobject] @{
                "host_switches" = @($esxiHostswitchSpec)
                "resource_type" = "StandardHostSwitchSpec";
            }
        }

        $body = $json | ConvertTo-Json -Depth 10

        $pair = "${NSXAdminUsername}:${NSXAdminPassword}"
        $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
        $base64 = [System.Convert]::ToBase64String($bytes)

        $headers = @{
            "Authorization"="basic $base64"
            "Content-Type"="application/json"
            "Accept"="application/json"
        }

        $transportNodeUrl = "https://$NSXTMgrHostname/api/v1/transport-node-profiles"

        if($debug) {
            "URL: $transportNodeUrl" | Out-File -Append -LiteralPath $verboseLogFile
            "Headers: $($headers | Out-String)" | Out-File -Append -LiteralPath $verboseLogFile
            "Body: $body" | Out-File -Append -LiteralPath $verboseLogFile
        }

        try {
            My-Logger "Creating Transport Node Profile $TransportNodeProfileName ..."
            if($PSVersionTable.PSEdition -eq "Core") {
                $requests = Invoke-WebRequest -Uri $transportNodeUrl -Body $body -Method POST -Headers $headers -SkipCertificateCheck
            } else {
                $requests = Invoke-WebRequest -Uri $transportNodeUrl -Body $body -Method POST -Headers $headers
            }
        } catch {
            Write-Error "Error in creating NSX-T Transport Node Profile"
            Write-Error "`n($_.Exception.Message)`n"
            break
        }

        if($requests.StatusCode -eq 201) {
            My-Logger "Successfully Created Transport Node Profile"
        } else {
            My-Logger "Unknown State: $requests"
        }
    }

    if($runAddEsxiTransportNode -eq 1) {
        $transportNodeCollectionService = Get-NsxtService -Name "com.vmware.nsx.transport_node_collections"
        $transportNodeCollectionStateService = Get-NsxtService -Name "com.vmware.nsx.transport_node_collections.state"
        $computeCollectionService = Get-NsxtService -Name "com.vmware.nsx.fabric.compute_collections"
        $transportNodeProfileService = Get-NsxtService -Name "com.vmware.nsx.transport_node_profiles"

        $computeCollectionId = ($computeCollectionService.list().results | where {$_.display_name -eq $NewVCVSANClusterName}).external_id
        $transportNodeProfileId = ($transportNodeProfileService.list().results | where {$_.display_name -eq $TransportNodeProfileName}).id

        $transportNodeCollectionSpec = $transportNodeCollectionService.help.create.transport_node_collection.Create()
        $transportNodeCollectionSpec.display_name = "ESXi Transport Node Collection"
        $transportNodeCollectionSpec.compute_collection_id = $computeCollectionId
        $transportNodeCollectionSpec.transport_node_profile_id = $transportNodeProfileId
        My-Logger "Applying Transport Node Profile to ESXi Transport Nodes ..."
        $transportNodeCollection = $transportNodeCollectionService.create($transportNodeCollectionSpec)

        My-Logger "Waiting for ESXi transport node configurations to complete ..."
        while ( $transportNodeCollectionStateService.get(${transportNodeCollection}.id).state -ne "SUCCESS") {
            $percent = $transportNodeCollectionStateService.get(${transportNodeCollection}.id).aggregate_progress_percentage
            if($debug) { My-Logger "ESXi transport node is still being configured (${percent}% Completed), sleeping for 30 seconds ..." }
            Start-Sleep 30
        }
    }

    if($runAddEdgeTransportNode -eq 1) {
        $transportNodeService = Get-NsxtService -Name "com.vmware.nsx.transport_nodes"
        $hostswitchProfileSerivce = Get-NsxtService -Name "com.vmware.nsx.host_switch_profiles"
        $transportNodeStateService = Get-NsxtService -Name "com.vmware.nsx.transport_nodes.state"

        # Retrieve all Edge Host Nodes
        $edgeNodes = $transportNodeService.list().results | where {$_.node_deployment_info.resource_type -eq "EdgeNode"}
        $ipPool = (Get-NsxtService -Name "com.vmware.nsx.pools.ip_pools").list().results | where { $_.display_name -eq $TunnelEndpointName }
        $OverlayTZ = (Get-NsxtService -Name "com.vmware.nsx.transport_zones").list().results | where { $_.display_name -eq $OverlayTransportZoneName }
        $VlanTZ = (Get-NsxtService -Name "com.vmware.nsx.transport_zones").list().results | where { $_.display_name -eq $VlanTransportZoneName }
        $ESXiUplinkProfile = $hostswitchProfileSerivce.list().results | where { $_.display_name -eq $ESXiUplinkProfileName }
        $EdgeUplinkProfile = $hostswitchProfileSerivce.list().results | where { $_.display_name -eq $EdgeUplinkProfileName }
        $NIOCProfile = $hostswitchProfileSerivce.list($null,"VIRTUAL_MACHINE","NiocProfile",$true,$null,$null,$null).results | where {$_.display_name -eq "nsx-default-nioc-hostswitch-profile"}
        $LLDPProfile = $hostswitchProfileSerivce.list($null,"VIRTUAL_MACHINE","LldpHostSwitchProfile",$true,$null,$null,$null).results | where {$_.display_name -eq "LLDP [Send Packet Enabled]"}

        foreach ($edgeNode in $edgeNodes) {
            $overlayIpAssignmentSpec = [pscustomobject] @{
                "resource_type" = "StaticIpPoolSpec";
                "ip_pool_id" = $ipPool.id;
            }

            $edgeIpAssignmentSpec = [pscustomobject] @{
                "resource_type" = "AssignedByDhcp";
            }

            $OverlayTransportZoneEndpoints = @(@{"transport_zone_id"=$OverlayTZ.id})
            $EdgeTransportZoneEndpoints = @(@{"transport_zone_id"=$VlanTZ.id})

            $overlayHostswitchSpec = [pscustomobject]  @{
                "host_switch_name" = $OverlayTransportZoneHostSwitchName;
                "host_switch_mode" = "STANDARD";
                "ip_assignment_spec" = $overlayIpAssignmentSpec
                "pnics" = @(@{"device_name"=$EdgeOverlayUplinkProfileActivepNIC;"uplink_name"=$EdgeOverlayUplinkName;})
                "host_switch_profile_ids" = @(@{"key"="UplinkHostSwitchProfile";"value"=$ESXiUplinkProfile.id})
                "transport_zone_endpoints" = $OverlayTransportZoneEndpoints;
            }

            $edgeHostswitchSpec = [pscustomobject]  @{
                "host_switch_name" = $VlanTransportZoneNameHostSwitchName;
                "host_switch_mode" = "STANDARD";
                "pnics" = @(@{"device_name"=$EdgeUplinkProfileActivepNIC;"uplink_name"=$EdgeUplinkName;})
                "ip_assignment_spec" = $edgeIpAssignmentSpec
                "host_switch_profile_ids" = @(@{"key"="UplinkHostSwitchProfile";"value"=$EdgeUplinkProfile.id})
                "transport_zone_endpoints" = $EdgeTransportZoneEndpoints;
            }

            $json = [pscustomobject] @{
                "resource_type" = "TransportNode";
                "node_id" = $edgeNode.node_id;
                "display_name" = $edgeNode.display_name;
                "host_switch_spec" = [pscustomobject] @{
                    "host_switches" = @($overlayHostswitchSpec,$edgeHostswitchSpec)
                    "resource_type" = "StandardHostSwitchSpec";
                };
            }

            $body = $json | ConvertTo-Json -Depth 10

            $pair = "${NSXAdminUsername}:${NSXAdminPassword}"
            $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
            $base64 = [System.Convert]::ToBase64String($bytes)

            $headers = @{
                "Authorization"="basic $base64"
                "Content-Type"="application/json"
                "Accept"="application/json"
            }

            $transportNodeUrl = "https://$NSXTMgrHostname/api/v1/transport-nodes"

            if($debug) {
                "URL: $transportNodeUrl" | Out-File -Append -LiteralPath $verboseLogFile
                "Headers: $($headers | Out-String)" | Out-File -Append -LiteralPath $verboseLogFile
                "Body: $body" | Out-File -Append -LiteralPath $verboseLogFile
            }

            try {
                My-Logger "Creating NSX-T Edge Transport Node for $($edgeNode.display_name) ..."
                if($PSVersionTable.PSEdition -eq "Core") {
                    $requests = Invoke-WebRequest -Uri $transportNodeUrl -Body $body -Method POST -Headers $headers -SkipCertificateCheck
                } else {
                    $requests = Invoke-WebRequest -Uri $transportNodeUrl -Body $body -Method POST -Headers $headers
                }
            } catch {
                Write-Error "Error in creating NSX-T Edge Transport Node"
                Write-Error "`n($_.Exception.Message)`n"
                break
            }

            if($requests.StatusCode -eq 201) {
                My-Logger "Successfully Created NSX-T Edge Transport Node "
                $edgeTransPortNodeId = ($requests.Content | ConvertFrom-Json).node_id
            } else {
                My-Logger "Unknown State: $requests"
                break
            }

            My-Logger "Waiting for Edge transport node configurations to complete ..."
            while ($transportNodeStateService.get($edgeTransPortNodeId).state -ne "success") {
                if($debug) { My-Logger "Edge transport node is still being configured, sleeping for 30 seconds ..." }
                Start-Sleep 30
            }
        }
    }

    if($runAddEdgeCluster -eq 1) {
        $edgeNodes = (Get-NsxtService -Name "com.vmware.nsx.fabric.nodes").list().results | where { $_.resource_type -eq "EdgeNode" }
        $edgeClusterService = Get-NsxtService -Name "com.vmware.nsx.edge_clusters"
        $edgeClusterStateService = Get-NsxtService -Name "com.vmware.nsx.edge_clusters.state"
        $edgeNodeMembersSpec = $edgeClusterService.help.create.edge_cluster.members.Create()

        My-Logger "Creating Edge Cluster $EdgeClusterName and adding Edge Hosts ..."

        foreach ($edgeNode in $edgeNodes) {
            $edgeNodeMemberSpec = $edgeClusterService.help.create.edge_cluster.members.Element.Create()
            $edgeNodeMemberSpec.transport_node_id = $edgeNode.id
            $edgeNodeMemberAddResult = $edgeNodeMembersSpec.Add($edgeNodeMemberSpec)
        }

        $edgeClusterSpec = $edgeClusterService.help.create.edge_cluster.Create()
        $edgeClusterSpec.display_name = $EdgeClusterName
        $edgeClusterSpec.members = $edgeNodeMembersSpec
        $edgeCluster = $edgeClusterService.Create($edgeClusterSpec)

        $edgeState = $edgeClusterStateService.get($edgeCluster.id)
        $maxCount=5
        $count=0
        while($edgeState.state -ne "in_sync") {
            My-Logger "Edge Cluster has not been realized, sleeping for 10 seconds ..."
            Start-Sleep -Seconds 10
            $edgeState = $edgeClusterStateService.get($edgeCluster.id)

            if($count -eq $maxCount) {
                Write-Host "Edge Cluster has not been realized! exiting ..."
                break
            } else {
                $count++
            }
        }
        # Need to force Policy API sync to ensure Edge Cluster details are available for later use
        $reloadOp = (Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.sites.enforcement_points").reload("default","default")
        My-Logger "Edge Cluster has been realized"
    }

    if($runNetworkSegment -eq 1) {
        My-Logger "Creating Network Segment $NetworkSegmentName ..."

        $transportZonePolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.sites.enforcement_points.transport_zones"
        $segmentPolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.segments"

        $tzPath = ($transportZonePolicyService.list("default","default").results | where {$_.display_name -eq $VlanTransportZoneName}).path

        $segmentSpec = $segmentPolicyService.help.update.segment.Create()
        $segmentSpec.transport_zone_path = $tzPath
        $segmentSpec.display_name = $NetworkSegmentName
        $segmentSpec.vlan_ids = @($NetworkSegmentVlan)

        $segment = $segmentPolicyService.update($NetworkSegmentName,$segmentSpec)
    }

    if ($createDHCPProfile -eq 1) {
        $edgeClusters = Get-NsxtPolicyService -name "com.vmware.nsx_policy.infra.sites.enforcement_points.edge_clusters"
        $edgeCluster = ($edgeClusters.list($siteID, $enforcementpointID).results | where { $_.display_name -eq $EdgeClusterName})

        $edges = Get-NsxtPolicyService -name "com.vmware.nsx_policy.infra.sites.enforcement_points.edge_clusters.edge_nodes"
        $edgeName = $NSXTEdgeName + '.' + $VMDomain
        $edge = ($edges.list($siteID, $enforcementpointID, $edgeCluster.id).results | where { $_.display_name -eq $edgeName})

        My-Logger "Creating DHCP Profile ..."
        $dhcpprofiledata = Get-NsxtPolicyService -name "com.vmware.nsx_policy.infra.dhcp_server_configs"
        $dhcpprofileSpec = $dhcpprofiledata.help.patch.dhcp_server_config.Create()
        $dhcpprofileSpec.id = $DHCPServerName
        $dhcpprofileSpec.display_name = $DHCPServerName
        $dhcpprofileSpec.edge_cluster_path = $edgeCluster.path
        $dhcpprofileSpec.preferred_edge_paths = @($edge.path)
        $dhcpprofiledata.patch($DHCPServerName, $dhcpprofileSpec)
    }


    if($runT0Gateway -eq 1) {
        My-Logger "Creating T0 Gateway $T0GatewayName ..."

        $dhcpdata = Get-NsxtPolicyService -name "com.vmware.nsx_policy.infra.dhcp_server_configs"
        $dhcpServer = ($dhcpdata.list().results | where { $_.display_name -eq $DHCPServerName })

        $t0GatewayPolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier0s"
        $t0GatewayLocalePolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier_0s.locale_services"
        $t0GatewayInterfacePolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier_0s.locale_services.interfaces"
        $edgeClusterPolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.sites.enforcement_points.edge_clusters"
        $edgeClusterService = Get-NsxtService -Name "com.vmware.nsx.edge_clusters"

        $edgeCluster = ($edgeClusterService.list().results | where {$_.display_name -eq $EdgeClusterName})
        $edgeClusterMember = ($edgeClusterService.get($edgeCluster.id)).members.transport_node_id
        if($debug) { "EdgeClusterMember: ${edgeClusterMember}" | Out-File -Append -LiteralPath $verboseLogFile }

        $policyEdgeCluster = ($edgeClusterPolicyService.list("default","default").results | where {$_.display_name -eq $EdgeClusterName})
        $policyEdgeClusterPath = $policyEdgeCluster.path
        if($debug) { "EdgeClusterPath: $policyEdgeClusterPath" | Out-File -Append -LiteralPath $verboseLogFile }

        $edgeClusterNodePath = $policyEdgeClusterPath + "/edge-nodes/" + $edgeClusterMember
        if($debug) { "EdgeClusterNodePath: $edgeClusterNodePath" | Out-File -Append -LiteralPath $verboseLogFile }

        $t0GatewaySpec = $t0GatewayPolicyService.help.patch.tier0.Create()
        $t0GatewaySpec.id = $T0GatewayName
        $t0GatewaySpec.display_name = $T0GatewayName
        $t0GatewaySpec.ha_mode = "ACTIVE_STANDBY"
        $t0GatewaySpec.failover_mode = "NON_PREEMPTIVE"
        $t0GatewaySpec.dhcp_config_paths = @($dhcpServer.path)
        $t0Gateway = $t0GatewayPolicyService.patch($T0GatewayName,$t0GatewaySpec)

        $localeServiceSpec = $t0GatewayLocalePolicyService.help.patch.locale_services.create()
        $localeServiceSpec.display_name = "default"
        $localeServiceSpec.edge_cluster_path = $policyEdgeClusterPath
        $localeService = $t0GatewayLocalePolicyService.patch($T0GatewayName,"default",$localeServiceSpec)

        My-Logger "Creating External T0 Gateway Interface ..."
        
        $t0GatewayInterfaceSpec = $t0GatewayInterfacePolicyService.help.update.tier0_interface.Create()
        $t0GatewayInterfaceId = $T0GatewayInterface
        $subnetSpec = $t0GatewayInterfacePolicyService.help.update.tier0_interface.subnets.Element.Create()
        $subnetSpec.ip_addresses = @($T0GatewayInterfaceAddress)
        $subnetSpec.prefix_len = $T0GatewayInterfacePrefix
        $t0GatewayInterfaceSpec.segment_path = "/infra/segments/$NetworkSegmentName"
        $t0GatewayInterfaceAddResult = $t0GatewayInterfaceSpec.subnets.Add($subnetSpec)
        $t0GatewayInterfaceSpec.type = "EXTERNAL"
        $t0GatewayInterfaceSpec.edge_path = $edgeClusterNodePath
        $t0GatewayInterfaceSpec.resource_type = "Tier0Interface"
        $t0GatewayInterface = $t0GatewayInterfacePolicyService.patch($T0GatewayName,"default",$t0GatewayInterfaceId,$t0GatewayInterfaceSpec)
    }

    if($runT0StaticRoute -eq 1) {
        My-Logger "Adding Static Route on T0 Gateway Interface from $T0GatewayInterfaceStaticRouteNetwork to $T0GatewayInterfaceStaticRouteAddress ..."

        $staticRoutePolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier_0s.static_routes"
        $t0GatewayInterfacePolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier_0s.locale_services.interfaces"

        $scopePath = ($t0GatewayInterfacePolicyService.list($T0GatewayName,"default").results | where {$_.resource_type -eq "Tier0Interface"} | Select -First 1).path

        $nextHopSpec = $staticRoutePolicyService.help.patch.static_routes.next_hops.Element.Create()
        $nextHopSpec.admin_distance = "1"
        $nextHopSpec.ip_address = $T0GatewayInterfaceStaticRouteAddress
        $nextHopSpec.scope = @($scopePath)

        $staticRouteSpec = $staticRoutePolicyService.help.patch.static_routes.Create()
        $staticRouteSpec.display_name = $T0GatewayInterfaceStaticRouteName
        $staticRouteSpec.network = $T0GatewayInterfaceStaticRouteNetwork
        $nextHopeAddResult = $staticRouteSpec.next_hops.Add($nextHopSpec)

        $staticRoute = $staticRoutePolicyService.patch($T0GatewayName,$T0GatewayInterfaceStaticRouteName,$staticRouteSpec)
    }

    if($registervCenterOIDC -eq 1) {
        My-Logger "Registering vCenter Server OIDC Endpoint with NSX-T Manager ..."

        $oidcService = Get-NsxtService -Name "com.vmware.nsx.trust_management.oidc_uris"

        $vcThumbprint = (Get-SSLThumbprint256 -URL https://${VCSAHostname}) -replace ":",""

        $oidcSpec = $oidcService.help.create.oidc_end_point.Create()
        $oidcSpec.oidc_uri = "https://${VCSAHostname}/openidconnect/${VCSASSODomainName}/.well-known/openid-configuration"
        $oidcSpec.thumbprint = $vcThumbprint
        $oidcSpec.oidc_type = "vcenter"
        $oidcCreate = $oidcService.create($oidcSpec)
    }

    if ($createSegments -eq 1) {
        $tier0s = Get-NsxtPolicyService -name "com.vmware.nsx_policy.infra.tier0s"
        $t0 = $tier0s.get($T0GatewayName)

        $tzs = Get-NsxtPolicyService -name "com.vmware.nsx_policy.infra.sites.enforcement_points.transport_zones"
        $tz = ($tzs.list($siteID, $enforcementpointID).results | where { $_.display_name -eq $OverlayTransportZoneName})
        foreach ($seg in $DMZSegment, $InternalSegment) {
            $name = $seg.Name
            $gateway = $seg.Gateway
            $subnet = $seg.Subnet
            $dhcppool = $seg.DHCPPool
            My-Logger "Creating Segment $name ..."

            $segmentdata = Get-NsxtPolicyService -name "com.vmware.nsx_policy.infra.segments"
            $segmentSpec = $segmentdata.help.patch.segment.Create()
            $segmentSpec.id = $name
            $segmentSpec.display_name = $name
            $segmentSpec.transport_zone_path = $tz.path
            $segmentSpec.connectivity_path = $t0.path
            $segmentSpec.advanced_config.connectivity = "ON"
            # Add Subnets
            $subnetSpec = $segmentdata.help.patch.segment.subnets.Element.Create()
            $subnetSpec.gateway_address = $gateway
            $subnetSpec.dhcp_ranges = @($dhcppool)
            $segmentSpec.subnets.Add($subnetSpec) | Out-Null
            # Create Segment
            $segmentdata.patch($name, $segmentSpec)
        }
    }

    if ($configureNAT -eq 1) {
        $nat_id = "USER"
        $interfaces = Get-NsxtPolicyService -name "com.vmware.nsx_policy.infra.tier_0s.locale_services.interfaces"
        $interface = $interfaces.get($T0GatewayName, 'default',  't0_interface_01')
        $natrules = Get-NsxtPolicyService -name "com.vmware.nsx_policy.infra.tier_0s.nat.nat_rules"
        $natruleSpec = $natrules.help.patch.policy_nat_rule.Create()
        $natruleSpec.display_name = $NATName
        $natruleSpec.id = $NATName
        $natruleSpec.action = "SNAT"
        $natruleSpec.source_network = $NATSourceNetwork
        $natruleSpec.translated_network = $NATTranslatedNetwork
        $natruleSpec.scope = @($interface.path)
        My-Logger "Creating SNAT Rule $NATName ..."
        $natrules.patch($T0GatewayName, $nat_id, $NATName, $natruleSpec)
    }
}

if ($deployVictimVM -eq 1) {
    $victimVMOvfConfig = Get-OvfConfiguration -Server $vc $VictimVMOVA
    $datastore = Get-Datastore -Server $vc -Name $NewDatastore
    $cluster = Get-Cluster -Server $vc -Name $NewVCVSANClusterName
    $datacenter = $cluster | Get-Datacenter
    $hosts = $cluster | Get-VMHost

    foreach ($victim_vm in $App1WebVM, $App2WebVM, $App1AppVM, $App2AppVM) {
        # Deploy VM
        $victim_name = $victim_vm.Name
        $network = $victim_vm.Network
        $vm = Get-VM -Server $vc -Name $victim_name -ErrorAction SilentlyContinue
        if ($vm) {
            $vmhost = $vm | Get-VMHost
            My-Logger "VM $victim_name already exists on $vmhost. Skipping deployment ..."
        } else {
            $vmhost = $hosts[$victim_vm.HostIndex]
            My-Logger "Deploying Victim $victim_name ... on $vmhost"
            $vm = Import-VApp -Server $vc -Source $VictimVMOVA -OvfConfiguration $victimVMOvfConfig -Name $victim_vm.Name -Location $cluster -Datastore $datastore -VMHost $vmhost -DiskStorageFormat thin
        }
        My-Logger "Reconfiguring Network on VM $victim_name to $network  ..."
        $vm | Get-NetworkAdapter -Server $vc | Set-NetworkAdapter -Portgroup $network -Confirm:$false | Out-Null

        My-Logger "Powering on $victim_name ..."
        $vm | Start-Vm -RunAsync | Out-Null
    }
}

if ($tagVictimVM -eq 1) {
    My-Logger "Tagging VMs ..."

    Set-VMTags -VMName $App1AppVM.Name -Tags $AppTierTag, $App1Tag, $ProductionTag
    Set-VMTags -VMName $App2AppVM.Name -Tags $AppTierTag, $App2Tag, $DevelopmentTag
    Set-VMTags -VMName $App1WebVM.Name -Tags $ProductionTag, $WebTierTag, $App1Tag
    Set-VMTags -VMName $App2WebVM.Name -Tags $App2Tag, $WebTierTag, $DevelopmentTag

}

if ($setupNewVC -eq 1 -or $deployVictimVM -eq 1) {
    My-Logger "Disconnecting from new VCSA ..."
    Disconnect-VIServer $vc -Confirm:$false
}

if ($postDeployNSXConfig -eq 1 -or $tagVictimVM -eq 1) {
    My-Logger "Disconnecting from NSX-T Manager ..."
    Disconnect-NsxtServer -Confirm:$false
}

$EndTime = Get-Date
$duration = [math]::Round((New-TimeSpan -Start $StartTime -End $EndTime).TotalMinutes,2)

My-Logger "NSX-T Distributed IDS/IPS Proof of Concept Lab Deployment Complete!"
My-Logger "StartTime: $StartTime"
My-Logger "  EndTime: $EndTime"
My-Logger " Duration: $duration minutes"
