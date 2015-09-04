elasticsearch
=======
This plugin makes easy to use Elasticsearch API and it also offering autocomplete for common APIs. 
There are [`GET`](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-get.html), 
[`HEAD`](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-get.html), 
[`DELETE`](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-delete.html), 
[`PUT`](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-update.html) and 
[`POST`](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-update.html) commands.

Examples usage:
- `GET _cluster/health`
- `GET _nodes/stats`
- `GET _stats/fielddata?fields=*`
- `GET _nodes/stats/indices/fielddata?fields=*`
- `GET _cat`
- `DELETE twitter`

You should install [`json_reformat`](http://dev.man-online.org/package/main/yajl-tools/) to format json output.

Aliases
-------

- `alias ech='GET _cluster/health'`: Cluster status health
- `alias ecs='GET _cluster/state'`: Allows to get a comprehensive state information of the whole cluster
- `alias ens='GET _nodes/stats'`: Allows to retrieve all of the cluster nodes statistics
- `alias esf='GET _stats/fielddata'`: Field data memory usage on index level

Author
-------

Fedele Mantuano (**Twitter**: [@fedelemantuano](https://twitter.com/fedelemantuano))
