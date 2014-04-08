docker-etcd
===========

Tiny etcd configurations are tiny.

Build
=====

`docker build -t etcd .`

Run
===

To run a cluster:

`export IP=10.0.2.15`

`docker run -d -p 7001:7001 -p 4001:4001 -p 2211:22 -e "ETCD_PARAMETERS=-peer-addr ${IP}:7001 -addr ${IP}:4001 -name etcd-node1" etcd`
`docker run -d -p 7002:7002 -p 4002:4002 -p 2212:22 -e "ETCD_PARAMETERS=-peer-addr ${IP}:7002 -addr ${IP}:4002 -name etcd-node2 -peers ${IP}:7001,${IP}:7002,${IP}:7003" etcd`
`docker run -d -p 7003:7003 -p 4003:4003 -p 2213:22 -e "ETCD_PARAMETERS=-peer-addr ${IP}:7003 -addr ${IP}:4003 -name etcd-node3 -peers ${IP}:7001,${IP}:7002,${IP}:7003" etcd`

Test
====

`curl http://$IP:4001/v2/stats/leader`

Profit.

TODO
====

Unsure if parameters passed to supervisord [program:x] directives is the
sweetest way possible, but works.
