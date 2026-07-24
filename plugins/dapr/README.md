# Dapr CLI

The [Dapr CLI](https://docs.dapr.io/getting-started/install-dapr-cli/) is the main tool you’ll be using for various Dapr related tasks. You can use it to run an application with a Dapr sidecar, as well as review sidecar logs, list running services, and run the Dapr dashboard. The Dapr CLI works with both self-hosted and Kubernetes environments.

To use it, add `dapr` to the plugins array of your zshrc file:

```sh
plugins=(... dapr)
```
