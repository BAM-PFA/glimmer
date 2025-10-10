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
//= require blacklight_range_limit


// Depended on by modal and slideshow_modal
//= require focus

// Depended on by slideshow_modal
//= require modal

//= require slideshow_modal

//= require x3dom

Blacklight.onLoad(function() {
  $('.documents-masonry').BlacklightMasonry();
  $('.documents-slideshow').slideshow();
  initFocusManagement()
  $('body').on('loaded.blacklight.blacklight-modal', initModal)
  initSlideshowModal()
});
