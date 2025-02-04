# Setting Up High Availability with Patroni, HAProxy, and etcd

## Introduction
This guide will help you set up a highly available PostgreSQL cluster using Patroni, HAProxy, and etcd.

## Prerequisites
- PostgreSQL installed on all nodes
- Python and pip installed on all nodes
- HAProxy installed on the load balancer node
- etcd installed on all nodes

## Step 1: Install Patroni
Install Patroni on all PostgreSQL nodes:
```bash
pip install patroni[etcd]
```

## Step 2: Configure etcd
Create an etcd configuration file (`/etc/etcd/etcd.conf`) on all nodes:
```ini
name: 'etcd-node'
data-dir: '/var/lib/etcd'
initial-cluster-state: 'new'
initial-cluster-token: 'etcd-cluster'
initial-cluster: 'etcd-node=http://<node1-ip>:2380,etcd-node=http://<node2-ip>:2380,etcd-node=http://<node3-ip>:2380'
initial-advertise-peer-urls: 'http://<node-ip>:2380'
advertise-client-urls: 'http://<node-ip>:2379'
listen-peer-urls: 'http://<node-ip>:2380'
listen-client-urls: 'http://<node-ip>:2379'
```
Start etcd:
```bash
systemctl start etcd
systemctl enable etcd
```

## Step 3: Configure Patroni
Create a Patroni configuration file (`/etc/patroni.yml`) on all PostgreSQL nodes:
```yaml
scope: postgres
namespace: /service/
name: postgresql0

restapi:
    listen: 0.0.0.0:8008
    connect_address: <node-ip>:8008

etcd:
    host: <etcd-cluster-ip>:2379

bootstrap:
    dcs:
        ttl: 30
        loop_wait: 10
        retry_timeout: 10
        maximum_lag_on_failover: 1048576
        postgresql:
            use_pg_rewind: true
            parameters:
                max_connections: 100
                max_locks_per_transaction: 64
                max_worker_processes: 8
                wal_level: replica
                hot_standby: "on"
                wal_keep_segments: 8
                max_wal_senders: 5
                max_replication_slots: 5
                synchronous_commit: "local"
    initdb:
    - encoding: UTF8
    - data-checksums

postgresql:
    listen: 0.0.0.0:5432
    connect_address: <node-ip>:5432
    data_dir: /var/lib/postgresql/12/main
    bin_dir: /usr/lib/postgresql/12/bin
    authentication:
        superuser:
            username: postgres
            password: <password>
        replication:
            username: replicator
            password: <password>
    parameters:
        unix_socket_directories: '/var/run/postgresql'
```
Start Patroni:
```bash
patroni /etc/patroni.yml
```

## Step 4: Configure HAProxy
Create an HAProxy configuration file (`/etc/haproxy/haproxy.cfg`) on the load balancer node:
```ini
global
    log /dev/log local0
    log /dev/log local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

defaults
    log global
    mode http
    option httplog
    option dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000

frontend stats
    bind *:7000
    mode http
    stats enable
    stats uri /

frontend postgresql
    bind *:5000
    default_backend postgresql

backend postgresql
    option httpchk
    http-check expect status 200
    server postgresql0 <node1-ip>:8008 maxconn 100 check port 8008
    server postgresql1 <node2-ip>:8008 maxconn 100 check port 8008
    server postgresql2 <node3-ip>:8008 maxconn 100 check port 8008
```
Start HAProxy:
```bash
systemctl start haproxy
systemctl enable haproxy
```


We have successfully set up a highly available PostgreSQL cluster using Patroni, HAProxy, and etcd.