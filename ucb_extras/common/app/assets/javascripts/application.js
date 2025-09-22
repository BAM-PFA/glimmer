//= require jquery3
//= require rails-ujs
//
// Required by Blacklight
//= require popper
// Twitter Typeahead for autocomplete
//= require twitter/typeahead
//= require bootstrap
//= require blacklight/blacklight
//= require blacklight_gallery/blacklight-gallery

Blacklight.onLoad(function() {
  $('.documents-masonry').BlacklightMasonry();
  $('.documents-slideshow').slideshow();
});
