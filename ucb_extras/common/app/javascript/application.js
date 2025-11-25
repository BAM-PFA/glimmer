// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import '@hotwired/turbo-rails'
import '@hotwired/stimulus'
import '@hotwired/stimulus-loading'
import 'controllers'
import 'jquery'
import Rails from '@rails/ujs'
import 'openseadragon'
import Blacklight from 'blacklight'
import 'blacklight-gallery'
import 'bootstrap'
import BlacklightRangeLimit from 'blacklight-range-limit'
import {far} from "@fortawesome/free-regular-svg-icons"
import {fas} from "@fortawesome/free-solid-svg-icons"
import {fab} from "@fortawesome/free-brands-svg-icons"
import {library} from "@fortawesome/fontawesome-svg-core"
import "@fortawesome/fontawesome-free"
import FocusManagement from 'focus'
import ModalAccessibility from 'modal'
import SlideshowModalAccessibility from 'slideshow-modal'

Rails.start()

// Initialize blacklight_range_limit
BlacklightRangeLimit.init({onLoadHandler: Blacklight.onLoad})

Blacklight.onLoad(function() {
  // Initialize blacklight-gallery
  $('.documents-masonry').BlacklightMasonry()
  $('.documents-slideshow').slideshow()

  // x3dom is only available in PAHMA (for rendering 3D objects)
  if (window.x3dom) {
    x3dom.reload()
  }

  library.add(far, fas, fab)

  // Initialize our custom JS
  FocusManagement()
  ModalAccessibility()
  SlideshowModalAccessibility()
});
