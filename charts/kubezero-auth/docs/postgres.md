# Upgrade Postgres major version

## backup

- shell into running posgres-auth pod
```
export PGPASSWORD="<postgres_password from secret>"
cd /bitnami/posgres
pg_dumpall > backup
```

- store backup off-site
```
kubectl cp keycloak/kubezero-auth-postgresql-0:/bitnami/postgresql/backup postgres-backup
```

## upgrade

- upgrade auth chart

- delete postgres-auth PVC and POD to flush old DB

## restore

- copy backup to new PVC
```
kubectl cp postgres-backup keycloak/kubezero-auth-postgresql-0:/bitnami/postgresql/backup
```

- log into psql as admin ( shell on running pod )
```
psql -U postgres
```

- drop database `keycloak`
```
DROP database keycloak
``` 
if keycloak is running and postgres complains about connected users simply kill the keycloak and retry

- actual restore
```
psql -U postgres -d postgres -f backup
```

- restart keycloak once more

success.
