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
