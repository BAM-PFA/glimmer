# Pin npm packages by running ./bin/importmap

# Enable integrity calculation globally
# enable_integrity!

pin "application", preload: true
pin "ga", to: "google_analytics.js"
pin "slideshow-modal", to: "slideshow_modal.js"
pin "modal", to: "modal.js"
pin "focus", to: "focus.js"
# pin_all_from File.expand_path("../app/assets/javascripts"), under: "javascripts", to: "src"
pin_all_from File.expand_path('../vendor/assets/javascripts', __dir__)
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@github/auto-complete-element", to: "https://cdn.skypack.dev/@github/auto-complete-element"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.6/dist/umd/popper.min.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.3/dist/js/bootstrap.js"
pin "jquery", to: "https://code.jquery.com/jquery-3.7.1.min.js"
pin "openseadragon", to: "openseadragon.js"

pin "blacklight", to: "blacklight/blacklight.js", preload: true
pin "blacklight-gallery", to: "blacklight_gallery/blacklight-gallery.js"

# chart.js is dependency of blacklight-range-limit, currently is not working
# as vendored importmaps, but instead must be pinned to CDN. You may want to update
# versions perioidically.
pin "chart.js", to: "https://ga.jspm.io/npm:chart.js@4.2.0/dist/chart.js"
# chart.js dependency
pin "@kurkle/color", to: "https://ga.jspm.io/npm:@kurkle/color@0.3.2/dist/color.esm.js"
