#Domain Repication Test


repadmin /syncall dc1

# usage 
#repadmin /removelingeringobjects <lingering_DC_name> <reference_DC_GUID> <dir_partition>



# removing replication object
repadmin /removelingeringobjects dc1 e60d9a5d-9c93-442c-a31e-0e262ac7d85f 'DC=example,DC=com'


uninstall-addsdomaincontroller  


