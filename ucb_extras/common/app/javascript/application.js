// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import 'jquery'
import 'blacklight-gallery'

import "openseadragon"
import "openseadragon-rails"

Blacklight.onLoad(function() {
  $('.documents-masonry').BlacklightMasonry();
  $('.documents-slideshow').slideshow();
});
