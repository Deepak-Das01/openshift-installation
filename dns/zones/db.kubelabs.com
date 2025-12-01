$TTL    604800
@       IN      SOA     bastion.kubelabs.com. contact.kubelabs.com (
                  1     ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
             604800     ; Minimum
)
        IN      NS      bastion

bastion.kubelabs.com.          IN      A       10.9.8.1
registry.kubelabs.com.          IN      A       10.9.8.1		

; Temp Bootstrap Node
bootstrap.kubelabs.com.        IN      A      10.9.8.10

; Control Plane Nodes
master01.kubelabs.com.         IN      A      10.9.8.11
master02.kubelabs.com.         IN      A      10.9.8.12
master03.kubelabs.com.         IN      A      10.9.8.13

; Worker Nodes
worker01.kubelabs.com.        IN      A      10.9.8.21
worker02.kubelabs.com.        IN      A      10.9.8.22

; Edge Nodes
edge01.kubelabs.com.        IN      A      10.9.8.31
edge02.kubelabs.com.        IN      A      10.9.8.32

; OpenShift Internal - Load balancer
api.kubelab.kubelabs.com.        IN    A    10.9.8.1
api-int.kubelab.kubelabs.com.    IN    A    10.9.8.1
*.apps.kubelab.kubelabs.com.     IN    A    10.9.8.1

; ETCD Cluster
etcd-0.kubelabs.com.    IN    A     10.9.8.15
etcd-1.kubelabs.com.    IN    A     10.9.8.16
etcd-2.kubelabs.com.    IN    A     10.9.8.17

; OpenShift Internal SRV records (cluster name = lab)
_etcd-server-ssl._tcp.kubelabs.com.    86400     IN    SRV     0    10    2380    etcd-0.kubelabs
_etcd-server-ssl._tcp.kubelabs.com.    86400     IN    SRV     0    10    2380    etcd-1.kubelabs
_etcd-server-ssl._tcp.kubelabs.com.    86400     IN    SRV     0    10    2380    etcd-2.kubelabs

oauth-openshift.apps.kubelab.kubelabs.com.     IN     A     10.9.8.1
console-openshift-console.apps.kubelab.kubelabs.com.     IN     A     10.9.8.1
