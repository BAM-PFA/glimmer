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

    # read the correct URL for requerying solr from portal/config/blacklight.yml
    config.blacklight_solr = config_for(:blacklight)
    
    # hash that defines the fields used in outputting search results to a csv
    config.csv_output_fields = {
      "csid_s" => "Object CSID",
      "objmusno_s"=>"Museum number",
      "objdept_s"=>"Department",
      "objtype_txt"=>"Object type",
      "objname_txt"=>"Object name",
      "objaccno_ss"=>"Accession number",
      "anonymousdonor_ss"=>"Anonymous donor",
      "objcollector_ss"=>"Collector",
      "objaccdate_ss"=>"Accession date",
      "objacqdate_ss"=>"Acquisition date",
      "objfcp_s"=>"Collection place",
      "objfcpgeoloc_p"=>"Collection lat/long",
      "objfcptree_ss"=>"Collection place hierarchy",
      "status_ss"=>"Status",
      "imagetype_ss"=>"Image type",
      "media_available_ss"=>"Media available?",
      # "objculturetree_ss"=>"Associated culture hierarchy",
      "deaccessioned_s"=>"Deaccessioned?",
      "objassoccult_ss"=>"Associated culture",
      # "objobjectclasstree_ss"=>"Object class hierarchy",
      "objobjectclass_ss"=>"Object class",
      "restrictions_ss"=>"Restrictions",
      "objinscrtext_ss"=>"Inscription"
      }

      config.mapping_fields = {
        "objmusno_s" => "Museum number",
        "objname_s"=>"Object name",
        "objfcp_s"=>"Collection place",
        "objculturetree_ss"=>"Culture hierarchy",
        "objfcpgeoloc_p"=>"Lat/long"
    }


    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
