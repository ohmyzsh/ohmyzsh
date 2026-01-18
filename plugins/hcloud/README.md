# hcloud plugin

This plugin adds completion for the [Hetzner Cloud CLI](https://github.com/hetznercloud/cli),
as well as some aliases for common hcloud commands.

To use it, add `hcloud` to the plugins array in your zshrc file:

```zsh
plugins=(... hcloud)
```

## Aliases

| Alias      | Command                                   | Description                                                   |
| :--------- | :---------------------------------------- | :------------------------------------------------------------ |
| hc         | `hcloud`                                  | The hcloud command                                            |
|            |                                           | **Context Management**                                        |
| hcctx      | `hcloud context`                          | Manage contexts                                               |
| hcctxls    | `hcloud context list`                     | List all contexts                                             |
| hcctxu     | `hcloud context use`                      | Use a context                                                 |
| hcctxc     | `hcloud context create`                   | Create a new context                                          |
| hcctxd     | `hcloud context delete`                   | Delete a context                                              |
| hcctxa     | `hcloud context active`                   | Show active context                                           |
|            |                                           | **Server Management**                                         |
| hcs        | `hcloud server`                           | Manage servers                                                |
| hcsl       | `hcloud server list`                      | List all servers                                              |
| hcsc       | `hcloud server create`                    | Create a server                                               |
| hcsd       | `hcloud server delete`                    | Delete a server                                               |
| hcsdesc    | `hcloud server describe`                  | Describe a server                                             |
| hcspoff    | `hcloud server poweroff`                  | Power off a server                                            |
| hcspon     | `hcloud server poweron`                   | Power on a server                                             |
| hcsr       | `hcloud server reboot`                    | Reboot a server                                               |
| hcsreset   | `hcloud server reset`                     | Reset a server                                                |
| hcssh      | `hcloud server ssh`                       | SSH into a server                                             |
| hcse       | `hcloud server enable-rescue`             | Enable rescue mode for a server                               |
| hcsdr      | `hcloud server disable-rescue`            | Disable rescue mode for a server                              |
| hcsip      | `hcloud server ip`                        | Manage server IPs                                             |
| hcsa       | `hcloud server attach-iso`                | Attach an ISO to a server                                     |
| hcsda      | `hcloud server detach-iso`                | Detach an ISO from a server                                   |
| hcscip     | `hcloud server change-type`               | Change server type                                            |
|            |                                           | **Volume Management**                                         |
| hcv        | `hcloud volume`                           | Manage volumes                                                |
| hcvl       | `hcloud volume list`                      | List all volumes                                              |
| hcvc       | `hcloud volume create`                    | Create a volume                                               |
| hcvd       | `hcloud volume delete`                    | Delete a volume                                               |
| hcvdesc    | `hcloud volume describe`                  | Describe a volume                                             |
| hcva       | `hcloud volume attach`                    | Attach a volume to a server                                   |
| hcvda      | `hcloud volume detach`                    | Detach a volume from a server                                 |
| hcvr       | `hcloud volume resize`                    | Resize a volume                                               |
|            |                                           | **Network Management**                                        |
| hcn        | `hcloud network`                          | Manage networks                                               |
| hcnl       | `hcloud network list`                     | List all networks                                             |
| hcnc       | `hcloud network create`                   | Create a network                                              |
| hcnd       | `hcloud network delete`                   | Delete a network                                              |
| hcndesc    | `hcloud network describe`                 | Describe a network                                            |
| hcnas      | `hcloud network add-subnet`               | Add a subnet to a network                                     |
| hcnds      | `hcloud network delete-subnet`            | Delete a subnet from a network                                |
| hcnar      | `hcloud network add-route`                | Add a route to a network                                      |
| hcndr      | `hcloud network delete-route`             | Delete a route from a network                                 |
|            |                                           | **Floating IP Management**                                    |
| hcfip      | `hcloud floating-ip`                      | Manage floating IPs                                           |
| hcfipl     | `hcloud floating-ip list`                 | List all floating IPs                                         |
| hcfipc     | `hcloud floating-ip create`               | Create a floating IP                                          |
| hcfipd     | `hcloud floating-ip delete`               | Delete a floating IP                                          |
| hcfipdesc  | `hcloud floating-ip describe`             | Describe a floating IP                                        |
| hcfipa     | `hcloud floating-ip assign`               | Assign a floating IP to a server                              |
| hcfipua    | `hcloud floating-ip unassign`             | Unassign a floating IP from a server                          |
|            |                                           | **SSH Key Management**                                        |
| hcsk       | `hcloud ssh-key`                          | Manage SSH keys                                               |
| hcskl      | `hcloud ssh-key list`                     | List all SSH keys                                             |
| hcskc      | `hcloud ssh-key create`                   | Create an SSH key                                             |
| hcskd      | `hcloud ssh-key delete`                   | Delete an SSH key                                             |
| hcskdesc   | `hcloud ssh-key describe`                 | Describe an SSH key                                           |
| hcsku      | `hcloud ssh-key update`                   | Update an SSH key                                             |
|            |                                           | **Image Management**                                          |
| hci        | `hcloud image`                            | Manage images                                                 |
| hcil       | `hcloud image list`                       | List all images                                               |
| hcid       | `hcloud image delete`                     | Delete an image                                               |
| hcidesc    | `hcloud image describe`                   | Describe an image                                             |
| hciu       | `hcloud image update`                     | Update an image                                               |
|            |                                           | **Firewall Management**                                       |
| hcfw       | `hcloud firewall`                         | Manage firewalls                                              |
| hcfwl      | `hcloud firewall list`                    | List all firewalls                                            |
| hcfwc      | `hcloud firewall create`                  | Create a firewall                                             |
| hcfwd      | `hcloud firewall delete`                  | Delete a firewall                                             |
| hcfwdesc   | `hcloud firewall describe`                | Describe a firewall                                           |
| hcfwar     | `hcloud firewall add-rule`                | Add a rule to a firewall                                      |
| hcfwdr     | `hcloud firewall delete-rule`             | Delete a rule from a firewall                                 |
| hcfwas     | `hcloud firewall apply-to-resource`       | Apply a firewall to a resource                                |
| hcfwrs     | `hcloud firewall remove-from-resource`    | Remove a firewall from a resource                             |
|            |                                           | **Load Balancer Management**                                  |
| hclb       | `hcloud load-balancer`                    | Manage load balancers                                         |
| hclbl      | `hcloud load-balancer list`               | List all load balancers                                       |
| hclbc      | `hcloud load-balancer create`             | Create a load balancer                                        |
| hclbd      | `hcloud load-balancer delete`             | Delete a load balancer                                        |
| hclbdesc   | `hcloud load-balancer describe`           | Describe a load balancer                                      |
| hclbu      | `hcloud load-balancer update`             | Update a load balancer                                        |
| hclbas     | `hcloud load-balancer add-service`        | Add a service to a load balancer                              |
| hclbds     | `hcloud load-balancer delete-service`     | Delete a service from a load balancer                         |
| hclbat     | `hcloud load-balancer add-target`         | Add a target to a load balancer                               |
| hclbdt     | `hcloud load-balancer delete-target`      | Delete a target from a load balancer                          |
|            |                                           | **Certificate Management**                                    |
| hccert     | `hcloud certificate`                      | Manage certificates                                           |
| hccertl    | `hcloud certificate list`                 | List all certificates                                         |
| hccertc    | `hcloud certificate create`               | Create a certificate                                          |
| hccertd    | `hcloud certificate delete`               | Delete a certificate                                          |
| hccertdesc | `hcloud certificate describe`             | Describe a certificate                                        |
| hccertu    | `hcloud certificate update`               | Update a certificate                                          |
|            |                                           | **Datacenter and Location Info**                              |
| hcdc       | `hcloud datacenter list`                  | List all datacenters                                          |
| hcloc      | `hcloud location list`                    | List all locations                                            |
| hcst       | `hcloud server-type list`                 | List all server types                                         |
| hcit       | `hcloud image list --type system`         | List all system images                                        |

## Requirements

This plugin requires the [Hetzner Cloud CLI](https://github.com/hetznercloud/cli) to be installed.

### Installation

Install the Hetzner Cloud CLI using one of the following methods:

**macOS (Homebrew):**
```bash
brew install hcloud
```

**Linux (from source):**
```bash
go install github.com/hetznercloud/cli/cmd/hcloud@latest
```

**Or download a prebuilt binary from the [releases page](https://github.com/hetznercloud/cli/releases).**

### Setup

After installation, create a context and authenticate:

```bash
hcloud context create my-project
```

You'll be prompted to enter your Hetzner Cloud API token, which you can generate in the [Hetzner Cloud Console](https://console.hetzner.cloud/).
