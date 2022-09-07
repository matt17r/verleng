# Verleng

Data quality dashboards and integration toolkit for K-12 schools.

## About

This is the open source repository for Verleng. If you want to install and manage Verleng yourself (or contribute to its development) you're in the right place.

If you just want to try it out, head to [Verleng](https://verleng.com) and add yourself to the contact list to stay up to date with developments on hosted Verleng.

## Development

See `Gemfile` (in the root of this repository) for the version of Ruby and Rails Verleng uses. Once you have any prerequisites installed run `bin/setup`.

To start the app, run `bin/dev`. This will use Foreman to start up the services specified in `Procfile.dev`.

Once it starts up, access the service locally on http://localhost:3000.

### To update Ruby

- Install latest stable version of Ruby
  ```sh
  brew upgrade rbenv ruby-build
  rbenv install -l # List latest stable versions
  rbenv install <stable version>
  rbenv local <stable version> # Updates value in /.ruby-version
  ```  
- Update Ruby version in Gemfile
- Install gems into new version of Ruby  
  `bundle install`
- If you get a warning about using an older version of bundler
  `bundle update --bundler`
