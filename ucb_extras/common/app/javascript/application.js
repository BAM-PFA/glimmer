// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import '@hotwired/turbo-rails'
import '@hotwired/stimulus'
import '@hotwired/stimulus-loading'
import 'controllers'
import 'jquery'
import 'openseadragon'
import githubAutoCompleteElement from '@github/auto-complete-element'
import Blacklight from 'blacklight'
import 'blacklight-gallery'
import * as bootstrap from 'bootstrap'
import BlacklightRangeLimit from 'blacklight-range-limit'
import 'ga'
import FocusManagement from 'focus'
import ModalAccessibility from  'modal'
import SlideshowModalAccessibility from 'slideshow-modal'

Blacklight.onLoad(function() {
  // Initialize blacklight-gallery
  $('.documents-masonry').BlacklightMasonry()
  $('.documents-slideshow').slideshow()

  // Initialize blacklight_range_limit
  BlacklightRangeLimit.init({onLoadHandler: Blacklight.onLoad})

  // Initialize our custom JS
  FocusManagement()
  ModalAccessibility()
  SlideshowModalAccessibility()
});
