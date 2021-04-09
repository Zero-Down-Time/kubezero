# How to extract or even edit etcd data directly

## Get Auger
https://github.com/jpbetz/auger

## Change a PV object
etcdctl get /registry/persistentvolumes/services-dsny-cache  | auger decode > pv.yaml

vi pv.yaml

cat pv.yaml | auger encode | etcdctl put /registry/persistentvolumes/services-dsny-cache
