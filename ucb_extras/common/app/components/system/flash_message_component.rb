# frozen_string_literal: true

module System
  class FlashMessageComponent < Blacklight::System::FlashMessageComponent

    def initialize(message: nil, type:)
      @message = message
      @classes = alert_class(type)
      @type = type
    end

    # Bootstrap 4 requires the span, but Bootstrap 5 should not have it.
    # See https://getbootstrap.com/docs/4.6/components/alerts/#dismissing
    #     https://getbootstrap.com/docs/5.1/components/alerts/#dismissing
    def button_contents
      return if helpers.controller.blacklight_config.bootstrap_version == 5

      tag.span '&times;'.html_safe, class: 'blacklight-icons blacklight-icons-remove', aria: { hidden: true }
    end

    def alert_class(type)
      case type.to_s
      when 'success'  then "alert-success"
      when 'notice'   then "alert-info"
      when 'alert'    then "alert-warning"
      when 'error'    then "alert-danger"
      when 'sr_alert' then "sr-only"
      else "alert-#{type}"
      end
    end
  end
end
