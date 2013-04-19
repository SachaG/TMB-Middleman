# Hull::Paywall integration


### Middleman setup 

enter info in `data/hull.yml`
and also in `config.rb`

TODO: config should not be repeated...

### Hull setup

* create an org
* add a 'Gumroad Account' (`New service` button > `Gumroad account`)
* Enter your Gumroad's username and password (sorry about that, it's the only way to authenticate with their api)
* Create a new App
* then edit it to link it to your `Gumroad account` service

### Gumroad Account setup

In `Settings > Developer` setup the `Ping endpoint` to : 

    http://YOUR-ORG-NAMESPACE.alpha.hullapp.io/api/v1/services/gumroad/ping?app_id=xxx&access_token=zzz

Where :

`app_id` : Your Hull App's ID
`access_token` : The same Apps' secret

You can find these infos on your Apps' page in Hull admin

### Adding restricted areas...

Create one product on Gumroad for each retricted area you want to setup

In `config.rb`, configure `hull_config` paths to match the different restricted areas...

### Hack

The code for Hull::Paywall is located here : 

    https://github.com/hull/hull-ruby/blob/master/lib/hull/paywall.rb


### TODO

* We should not have 2 popup windows for persona login
* DSL to list restricted routes instead of hull_config[:paths] ?
* Configure Hull::Paywall middleware in config.ru (to make it work in production)
* Find a way to auto-login users in Gumroad provided callback or URL... ? (Use Gumroad Hooks instead of Pings ?)
* Provide other options that redirect (302) on access denied ?
* ...

