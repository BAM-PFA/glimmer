## Customizations to Blacklight for UC Berkeley Museums

This repo contains a customized Blacklight application. It is basically a fork of the initial UCB museum [radiance](https://github.com/cspace-deployment/radiance) portals that were customized by John Lowe, upgraded to Blacklight 8 and Rails 7.

Blacklight is a Ruby on Rails application. Refer to the Blacklight project documention for details about how to maintain and deploy applications of this sort:

http://projectblacklight.org/

Blacklight version 8.x

Rails 7.x

Ruby 3.3.x

Note: UCB utilities copied from **radiance** might need to have some filepaths edited to reflect the change in directory structure [?]


#### test install steps

 * `rails new glimmer`
 * add blacklight dependencies and UCB customizations to GEMFILE 
 * copy UCB customization directory tree from radiance repo ("extras") to the `ucb_extras` folder
 * copy all the installer and update tools to the `ucb_utils` folder
