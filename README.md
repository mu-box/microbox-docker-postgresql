# PostgreSQL [![Build Status Image](https://github.com/mu-box/microbox-docker-postgresql/actions/workflows/ci.yaml/badge.svg)](https://github.com/mu-box/microbox-docker-postgresql/actions)

This is an PostgreSQL Docker image used to launch a PostgreSQL service on Microbox. To use this image, add a data component to your `boxfile.yml` with the `mubox/postgresql` image specified:

```yaml
data.db:
  image: mubox/postgresql
```

## PostgreSQL Configuration Options
PostgreSQL components are configured in your `boxfile.yml`. All available configuration options are outlined below.

### Version
When configuring a PostgreSQL service in your boxfile.yml, you can specify which version to load into your database service. The following version(s) are available:

- 9.3
- 9.4
- 9.5
- 9.6
- 10

**Note:** PostgreSQL versions cannot be changed after the service is created. To use a different version, you'll have to create a new PostgreSQL service.

#### version
```yaml
# default setting
data.db:
  image: mubox/postgresql
  config:
    version: 10
```

### Custom Users/Permissions/Databases
You can create custom users with custom permissions as well as additional databases.

```yaml
data.postgresql:
  image: mubox/postgresql:10
  config:
    users:
    - username: customuser
      meta:
        privileges:
        - privilege: ALL PRIVILEGES
          type: DATABASE
          'on': gomicro
          grant: true
        - privilege: ALL PRIVILEGES
          type: DATABASE
          'on': customdb
          grant: true
        roles:
        - SUPERUSER
```

For each custom user specified, Microbox will generate an environment variable for the user's password using the following pattern:

```yaml
# Pattern
COMPONENT_ID_USERNAME_PASS

# Examples

## Custom user config 1
data.postgres:
  config:
    users:
      - username: customuser

## Generated password evar 1
DATA_POSTGRES_CUSTOMUSER_PASS

## Custom user config 2
data.db:
  config:
    users:
      - username: dbuser

## Generated password evar 2
DATA_DB_DBUSER_PASS
```

## Request PostgreSQL Boxfile Configs
One of the many benefits of using PostgreSQL is that it doesn't require much configuration. The project itself is finely tuned. However we know there are settings that users may want to tweak. If there's a setting you'd like to modify that is typically handled in the postresql.conf, please let us know by creating a [new issue on this project](https://github.com/mu-box/microbox-docker-postgresql/issues/new).

## Help & Support
This is a PostgreSQL Docker image provided by [Microbox](http://microbox.cloud). If you need help with this image, you can reach out to us in the [Microbox Discord](https://discord.gg/MCDdHfy). If you are running into an issue with the image, feel free to [create a new issue on this project](https://github.com/mu-box/microbox-docker-postgresql/issues/new).

## License
This project is released under [The MIT License](http://opensource.org/licenses/MIT).
