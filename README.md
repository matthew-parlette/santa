# Overview

This is a secret santa management website. It will handle:

* Managing user bans (so couples can't be assigned to each other)
* Creating assignments
* Emailing assignments and reminders
* Allow users to propose ideas for other users (that are not visible to the target user)

## Usage

### Docker

#### Build

```
$ docker build -t santa .
```

#### Run

##### Development

```
$ docker run -i -e RAILS_ENV=development -p 3000:3000 --name santa -t santa
```

This will run the container in the foreground. If you would like to run this as a background job, remove the `-i` argument and hit CTRL+C to break out of the container output.

##### Production

Production requires a SECRET_KEY_BASE to be provided as an environment variable. This can be generated with `rails secret`.

```
$ docker run -i -e RAILS_ENV=production -e SECRET_KEY_BASE=whatever -e RAILS_SERVE_STATIC_FILES=true -p 3000:3000 --name santa -t santa
```

In production, there are no users or admins by default, so you will need to create the first admin user:

```
$ docker exec -it santa /bin/bash -c 'rails c'
> AdminUser.create!(email: 'matthew.parlette@gmail.com', password: 'password', password_confirmation: 'password')
```
