# Pin npm packages by running ./bin/importmap

# Enable integrity calculation globally
# enable_integrity!

pin "application"
pin "slideshow-modal", to: "slideshow_modal.js"
pin "modal", to: "modal.js"
pin "focus", to: "focus.js"
pin_all_from File.expand_path('../vendor/assets/javascripts', __dir__)
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.1.3-4/app/assets/javascripts/rails-ujs.esm.js"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "jquery", to: "jquery.min.js", preload: true
pin "openseadragon", to: "openseadragon.js", preload: true

# To use autocomplete, configure a solr.SuggestComponent in solrconfig.xml and set blacklight_config.autocomplete_enabled = true.
# pin "@github/auto-complete-element", to: "https://cdn.skypack.dev/@github/auto-complete-element"

pin "blacklight", to: "blacklight/blacklight.js"
pin "blacklight-gallery", to: "blacklight_gallery/blacklight-gallery.js"

# chart.js is dependency of blacklight-range-limit, currently is not working
# as vendored importmaps, but instead must be pinned to CDN. You may want to update
# versions perioidically.
pin "chart.js", to: "https://ga.jspm.io/npm:chart.js@4.2.0/dist/chart.js"
# chart.js dependency
pin "@kurkle/color", to: "https://ga.jspm.io/npm:@kurkle/color@0.3.2/dist/color.esm.js"

pin "@fortawesome/fontawesome-free", to: "https://ga.jspm.io/npm:@fortawesome/fontawesome-free@7.1.0/js/fontawesome.js"
pin "@fortawesome/fontawesome-svg-core", to: "https://ga.jspm.io/npm:@fortawesome/fontawesome-svg-core@7.1.0/index.mjs"
pin "@fortawesome/free-brands-svg-icons", to: "https://ga.jspm.io/npm:@fortawesome/free-brands-svg-icons@7.1.0/index.mjs"
pin "@fortawesome/free-regular-svg-icons", to: "https://ga.jspm.io/npm:@fortawesome/free-regular-svg-icons@7.1.0/index.mjs"
pin "@fortawesome/free-solid-svg-icons", to: "https://ga.jspm.io/npm:@fortawesome/free-solid-svg-icons@7.1.0/index.mjs"
