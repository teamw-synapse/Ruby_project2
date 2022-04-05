Skylight Performance Stats:[![View performance data on Skylight](https://badges.skylight.io/status/LOKqW7RcNNsZ.svg?token=sQ3xEyHuyEPxYLULgm8j1SSPaLTWQqdXN8ddCJXQhsc)](https://www.skylight.io/app/applications/LOKqW7RcNNsZ) [![View performance data on Skylight](https://badges.skylight.io/problem/LOKqW7RcNNsZ.svg?token=sQ3xEyHuyEPxYLULgm8j1SSPaLTWQqdXN8ddCJXQhsc)](https://www.skylight.io/app/applications/LOKqW7RcNNsZ) [![View performance data on Skylight](https://badges.skylight.io/typical/LOKqW7RcNNsZ.svg?token=sQ3xEyHuyEPxYLULgm8j1SSPaLTWQqdXN8ddCJXQhsc)](https://www.skylight.io/app/applications/LOKqW7RcNNsZ) [![View performance data on Skylight](https://badges.skylight.io/rpm/LOKqW7RcNNsZ.svg?token=sQ3xEyHuyEPxYLULgm8j1SSPaLTWQqdXN8ddCJXQhsc)](https://www.skylight.io/app/applications/LOKqW7RcNNsZ) 

# The Lobby

This web application help user to navigate different resource of their organization and access them from single platform.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
* Ruby
* PostgreSQL
```

### Installing

A step by step series of examples that tell you how to get a development env running

Say what the step will be

```
$ git clone git@gitlab-ssh-eu.factory.tools:WTG-Dev/the-lobby.git
$ cd the-lobby/
```

### Config Database

Populate following Environment variable in local machine `~/.bash_profile`

```
export THE_LOBBY_DB_USERNAME=<"Database_Name">
export THE_LOBBY_DB_PASSWORD=<"Database_Password">
export THE_LOBBY_OAUTH_APP_ID=<"APP_ID">
export THE_LOBBY_OAUTH_APP_SECRET=<"APP_SECRET">
export GEMS_USERNAME=<"USERNAME">
export GEMS_PASSWORD=<"PASSWORD">
export USERS_AUTOCOMPLETE_TOKEN=<"TOKEN"> value of Base64.strict_encode64("email:password")

```

After initalizing above mention variable in local machine, run

```
$ bundle install
$ bundle exec rake db:setup
```

### Rake Task

To populate Agency to database via calling API, set rails secret credential set `Rails.application.credentials[:ldap_get_agencies_token]` and run

```
bundle exec rake create_agencies_from_api
```

To create default branding, run

```
bundle exec rake create_default_branding
```

#### Running

```
$ bundle exec rails s
```
Now you can visit http://localhost:3000 to play with the The-Lobby site.

## Built With

* [Ruby on Rails](https://rubyonrails.org/) - The web framework used
* [Ruby Version Manager (RVM)](https://rvm.io/) - Ruby Version Manager
