# Upgrade Postgres major version

## backup

- shell into running posgres-auth pod
```
export PGPASSWORD="<postgres_password from secret>"
cd /bitnami/posgresql
pg_dumpall -U postgres > backup
```

- store backup off-site
```
kubectl cp keycloak/kubezero-auth-postgresql-0:/bitnami/postgresql/backup postgres-backup
```

## upgrade

- upgrade auth chart
- set replica of the keycloak statefulSet to 0
- set replica of the postgres-auth statefulSet to 0
- delete postgres-auth PVC and POD to flush old DB

## restore

- restore replica of postgres-auth statefulSet
- copy backup to new PVC
```
kubectl cp postgres-backup keycloak/kubezero-auth-postgresql-0:/bitnami/postgresql/backup
```

- log into psql as admin ( shell on running pod )
```
psql -U postgres
```

- drop database `keycloak` in case the keycloak instances connected early
```
DROP database keycloak
```

- actual restore
```
psql -U postgres -d postgres -f backup
```

- reset replia of keycloak statefulSet or force ArgoCD sync

success.
