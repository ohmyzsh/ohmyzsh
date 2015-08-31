elasticsearch
=======
This plugin makes easy to use Elasticsearch API and it also offering autocomplete for common APIs. 
There are `GET`, `HEAD`, `DELETE`, `PUT` and `POST` commands.

Examples usage:
- `GET _cluster/health`
- `GET _cat`
- `DELETE twitter`


Aliases
-------

- `alias ech='GET _cluster/health'`: Cluster status health
- `alias ecs='GET _cluster/state'`: Allows to get a comprehensive state information of the whole cluster
- `alias ens='GET _nodes/stats'`: Allows to retrieve all of the cluster nodes statistics
- `alias esf='GET _stats/fielddata'`: Field data memory usage on index level
