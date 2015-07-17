# rsd

A Recurser Social Directory.

## Development

 - Install ruby
 - Install postgress.app
 - `gem install bundler`
 - `bundle install`
 - `rake db:setup`
 -  Run the following and visit http://localhost:9393 (the domain and port are important because recurse.com does matching on the domain requesting authentication).
 
```
env `cat dev_env` rake local
```

## Deployment

We host this app on Heroku. The app name is rsd (and thus hosted at https://rsd.herokuapp.com/).

 - We have autodeployment from the `master` branch setup. If you push to master, it will be deployed.
 - `heroku run rake db:migrate` will update the database on Heroku to the latest version.
 - `heroku logs` will output the most recent logs.
 - @icco and @jdherg currently are the only people with access to the Heroku app. Ping them on Zulip or email if you want a command run or to be added to the Heroku app.
