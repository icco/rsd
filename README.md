# rcdir

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
