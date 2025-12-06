# OpenShift Install

The OpenShift installer `openshift-install` makes it easy to get a cluster
running on the public cloud or your local infrastructure.

To learn more about installing OpenShift, visit [docs.openshift.com](https://docs.openshift.com)
and select the version of OpenShift you are using.


This project documents a **fully disconnected OpenShift 4.18 deployment** running on  
**VMware Workstation Pro 25H2** hosted on **Windows 11 Home Edition**.  
All required cluster artifacts—RHCOS ISO, release images, and operator catalogs—are mirrored and consumed locally without any external network access.

---

## 📌 Prerequisites

### **Infrastructure Requirements**

| Component        | vCPU | Memory        | Description |
|-----------------|------|----------------|-------------|
| **Bastion Host**  | 4    | 8 GB RAM       | Hosts mirror registry, DNS, DHCP, HAProxy, and CLI tools |
| **Bootstrap Node**| 4    | 16 GB RAM      | Temporary bootstrap node for initializing the control plane |
| **Master Nodes** (x3) | 4 each | 16 GB RAM each | OpenShift control plane nodes |
| **Worker Nodes** (x2 or more) | 4 each | 8–16 GB RAM | Application and workload nodes |

---

## 📌 Software Requirements

- **RHEL CoreOS 4.18 ISO**
- **OpenShift CLI (`oc`)**
- **`oc-mirror` CLI** for disconnected mirroring
- **`openshift-install` binary**
- Local **registry** for hosting mirrored release and operator images

---

## 📌 Architecture Diagram

![Architecture Diagram](./digram/architecture-1.png)

---

## 📌 Components Overview

### **1. Bastion Host (Central Management & Mirror Node)**  
The Bastion host is the backbone of this disconnected environment and provides:

- OpenShift CLI tools: `oc`, `oc-mirror`, Podman  
- Quay / Mirror Registry for hosting all OCP & operator images  
- HAProxy load balancer  
- DNS server for cluster name resolution  
- DHCP server (optional)

**Hardware Specs**
- 4 vCPU  
- 6–8 GB vRAM  
- 150 GB NVMe disk  

**Networking**
- **Network 0: NAT** → Used only to download Red Hat images (optional)  
- **Network 1: Bridge** → Production cluster network  

After mirroring images, NAT can be removed.

---

### **2. Bootstrap Node**  
Temporary node used during cluster bring-up.

**Hardware Specs**
- 4 vCPU  
- 16 GB vRAM  
- 120 GB NVMe  

**Network**
- Bridge (Automatic)

---

### **3. Master Nodes (Control Plane)**  
Nodes hosting API server, etcd, scheduler, controller-manager.

**Hardware Specs (each)**
- 4 vCPU  
- 16 GB vRAM  
- 120 GB NVMe  
- Bridge Network  

Hostnames:
- `master01.kubelabs.com`
- `master02.kubelabs.com`
- `master03.kubelabs.com`

---

### **4. Worker Nodes**  
Run workloads, ingress routers, monitoring stack, application pods.

**Hardware Specs**
- 4 vCPU  
- 8–16 GB vRAM  
- 120 GB NVMe  
- Bridge Network  

Hostnames:
- `worker01.kubelabs.com`
- `worker02.kubelabs.com`

---

## 📌 Network Flow Summary

1. **Bastion Host → Bootstrap Node**  
   Provides ignition configs, registry, DNS, and load balancing.

2. **Bootstrap Node → Master Nodes**  
   Brings up the control plane components.

3. **Master Nodes → Worker Nodes**  
   Workers join using ignition files served by the Bastion.

4. After bootstrap completion, the **Bootstrap Node is removed**.

---

## Part A : Bastion Host Configuration 

### Step 1 : Copy the Git repository to the Linux host, download the required CLI tool packages, extract them using tar xzvf <tarball.tar.gz>, and move the binaries to /usr/bin/ for system-wide access. 
~~~
$ git clone https://github.com/Deepak-Das01/openshift-installation.git
$ cd cli-tools/
$ wget https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/4.18.X/openshift-client-linux-4.18.X.tar.gz 
$ wget https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/4.18.X/openshift-install-linux.tar.gz 
$ wget https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/4.18.X/oc-mirror.rhel9.tar.gz
~~~
### Step 2  : Network Configuration on Virtual machine host use the Networ 1 ( Bridge ) in my case its ens194 on the host machine and change its ipv4 address to the 10.9.8.1/24 , dns 127.0.0.1 , Search domains : kubelabs.com 
1. edit using below command and choose you bridge network
~~~
nmtui-edit con ens192
~~~
![Net1 Diagram](./digram/network-1.png)

2. Change the ipv4 to maunal and edit the details as per the below snip after that click on save 
![Net2 Diagram](./digram/network-2.png)

3. To confirm ip is allocated or not run below commands and verify 
~~~
$ nmcli connection down ens192
$ nmcli connection up ens192
$ ip a
~~~
![Net3 Diagram](./digram/network-3.png)

### Step 3 : Turn Off the Firewall service 
~~~
[root@bastion openshift-installation]# systemctl stop firewalld
[root@bastion openshift-installation]# systemctl disable firewalld
~~~
