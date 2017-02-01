## AppUp

**Maintainers:** [mdeboer](https://github.com/mdeboer)

This plugins adds `start`, `stop`, `up` and `down` commands when it detects a docker-compose or Vagrant file in the current directory (e.g. your application). Just run `up` and get coding!

### Docker

Aside from simply running `up`, you can also extend your configuration by running `up <name>`, which will run `docker-compose` with both `docker-compose.yml` and extend it with `docker-compose.<name>.yml`. For more on extending please see the official docker documentation: https://docs.docker.com/compose/extends. Additional arguments will be directly supplied to the docker-compose.

### Vagrant

Vagrant doesn't have a `down`, `start` or `stop` commands natively but don't worry, that's been taken care of and running those commands will actually run vagrant's equivalent commands. Additional arguments will be directly supplied to vagrant.