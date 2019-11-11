# clone oracle grid home

## create zip file of source grid home
```
tar -czvf  <target-folder>/<filename>.tgz <source-folder>
```
## unzip
```
node1: tar -xzvf <filename.tgz>
node2: tar -xzvf <filename.tgz>
```

## cleanup
```
# cd /<grid-home>
# rm -rf log/<old-hostname>
# rm -rf gpnp/<old-hostname>
# find gpnp -type f -exec rm -f {} \;
# rm -rf cfgtoollogs/*
# rm -rf crs/init/*
# rm -rf cdata/*
# rm -rf crf/*
# rm -rf network/admin/*.ora
# rm -rf crs/install/crsconfig_params
# find . -name '*.ouibak' -exec rm {} \;
# find . -name '*.ouibak.1' -exec rm {} \;
# rm -rf root.sh*
# rm -rf rdbms/audit/*
# rm -rf rdbms/log/*
# rm -rf inventory/backup/*
```

## pre-check
```
./runcluvfy.sh stage -pre crsinst -n <node1>,<node2> -fixup -verbose
```

## clone (as grid user)
```

# first node
perl clone.pl -silent \
    ORACLE_HOME=<oracle-home> \
    ORACLE_HOME_NAME=OraHome1Grid \
    ORACLE_BASE=<oracle-base>" \
    'CLUSTER_NODES={node1,node2}'" \
    "'LOCAL_NODE=node1'" \
    INVENTORY_LOCATION=<inventory>/oraInventory \
    CRS=TRUE

You will be prompted to run orainstRoot.sh and root.sh,
run only orainstRoot.sh on local node, don't run root.sh

# second node
perl clone.pl -silent \
    ORACLE_HOME=<oracle-home> \
    ORACLE_HOME_NAME=OraHome1Grid \
    ORACLE_BASE=<oracle-base>" \
    'CLUSTER_NODES={node1,node2}'" \
    "'LOCAL_NODE=node1'" \
    INVENTORY_LOCATION=<inventory>/oraInventory \
    CRS=TRUE

You will be prompted to run orainstRoot.sh and root.sh,
run only orainstRoot.sh on local node, don't run root.sh
```

## configure
```
<grid-home>/crs/config/config.sh -silent -ignoreprereq -responseFile /home/grid/<response-file>.rsp
```

## check status
```
<grid-home>/bin/crsctl stat res -t
```
