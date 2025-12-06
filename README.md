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

![digram](architecture-1.png)

> **Note:** Replace `architecture.png` with your actual image path or GitHub asset link.

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

## 📌 Notes

- This deployment is intended for **offline / air-gapped lab environments**.
- All required images, ISOs, and operator catalogs are mirrored locally.
- Only the Bastion Node needs temporary internet access.
