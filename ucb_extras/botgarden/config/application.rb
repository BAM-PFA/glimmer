require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Portal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0
    config.action_view.preload_links_header = false

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets javascript tasks])

    config.active_record.yaml_column_permitted_classes = [
      ActiveSupport::HashWithIndifferentAccess,
      ActiveSupport::TimeWithZone,
      ActiveSupport::TimeZone,
      Date,
      Symbol,
      Time
    ]

    config.sass.quiet_deps = true
    config.sass.silence_deprecations = ['import']

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")


    # hash that defines the fields used in outputting search results to a csv
    config.csv_output_fields = {
      "objcsid_s" => "Object CSID",
      "accessionnumber_s"=>"Accession number",
      "alldeterminations_ss"=>"Determination",
      "commonname_s"=>"Common Name",
      "family_s"=>"Family",
      "gardenlocation_s"=>"Garden Location",
      "deadflag_s"=>"Dead?",
      "provenancetype_s"=>"Provenance Type",
      "materialtype_s"=>"Material Received As",
      "sex_s"=>"Sex",
      "locality_s"=>"Place Name",
      "source_s"=>"Source",
      "collector_s"=>"Collector",
      "collectornumber_s"=>"Collector Number",
      "collectiondate_s"=>"Collection date",
      "rare_s"=>"Rare?",
      "conservecat_ss"=>"Conservation Category",
      "vouchers_s"=>"Has Herbarium Vouchers?",
      "voucherlist_s"=>"Voucher Institution",
      "floweringverbatim_ss"=>"Flowering Months",
      "fruitingverbatim_ss"=>"Fruiting Months"
      }


  end
end
