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

    # hash that defines the fields used in outputting search results to a csv
    config.csv_output_fields = {
      "csid_s" => "Object CSID",
      "objmusno_s"=>"Museum number",
      "objdept_s"=>"objdept_s",
      "objtype_txt"=>"objtype_txt",
      "objname_txt"=>"objname_txt",
      "objaccno_ss"=>"objaccno_ss",
      "anonymousdonor_ss"=>"anonymousdonor_ss",
      "objaccdate_ss"=>"objaccdate_ss",
      "objacqdate_ss"=>"objacqdate_ss",
      "objfcp_s"=>"objfcp_s",
      "objfcpgeoloc_p"=>"objfcpgeoloc_p",
      "objfcptree_ss"=>"objfcptree_ss",
      "status_ss"=>"status_ss",
      "imagetype_ss"=>"imagetype_ss",
      "media_available_ss"=>"media_available_ss",
      "objculturetree_ss"=>"objculturetree_ss",
      "deaccessioned_s"=>"deaccessioned_s",
      "objassoccult_ss"=>"objassoccult_ss",
      "objobjectclasstree_ss"=>"objobjectclasstree_ss",
      "restrictions_ss"=>"restrictions_ss"
      }

      config.mapping_fields = {
        "objmusno_s" => "Museum Number",
        "objname_s"=>"Object Name",
        "objfcp_s"=>"Collection Place",
        "objculturetree_ss"=>"Culture Hierarchy",
        "objfcpgeoloc_p"=>"Lat/Long"
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
