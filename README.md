# Customizations to Blacklight for UC Berkeley Museums

This repo contains a customized Blacklight application. It is basically a fork of the initial UCB museum [radiance](https://github.com/cspace-deployment/radiance) portals that were customized by John Lowe, upgraded to Blacklight 8 and Rails 7.

Blacklight is a Ruby on Rails application. Refer to the Blacklight project documention for details about how to maintain and deploy applications of this sort:  http://projectblacklight.org/

## Dependencies

* Ruby 3.3.x
* Rails 7.x
* Blacklight version 8.x

* Node v14.x or later (JS minifier gem `terser` requires a JavaScript runtime)

* Python (for running the tenant installer script)

## Local development

### Installing a museum tenant

The `portal` directory is where the application lives. Running the following script will copy shared files from `ucb_extras/common` into `portal`, then copy tenant-specific files from `ucb_extras/<TENANT>` into `portal`.

For example, to install the BAMPFA portal execute this from the `glimmer` directory:

```python ./ucb_utils/tenant_installer.py bampfa```

### Running unit tests

Unit tests are written in rspec. The unit tests for each museum tenant consist of shared specs from `ucb_extras/common` and tenant-specific specs from `ucb_extras/<TENANT>`.

* Install a museum tenant (see above)
* `bundle exec rspec`

### Compiling front-end assets

Most assets are managed using importmaps, but some legacy Javascript/CSS requires the use of Sprockets.

Assets must be compiled after installing a tenant and after making changes to CSS or JavaScript files:

* `cd portal`
* `bin/rails assets:precompile`

### Starting the Rails server

* Install a museum tenant (see above)
* Compile the assets (see above)
* `bin/rails s`
