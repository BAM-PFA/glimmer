# frozen_string_literal: true

module UrlHelper
  include Blacklight::UrlHelperBehavior

  # Adds a query parameter containing a message to be provided to screen readers after navigating to the href.
  # Optionally, adds a query parameter containing an ID or list of IDs of elements that could receive focus after navigation.
  def with_screen_reader_alert(href, msg, focus_target = nil)
    uri = URI.parse(href)
    query = if uri.query then CGI.parse(uri.query) else {} end
    query[:sr_alert] = msg
    unless focus_target.blank?
      query['focus_target[]'] = Array(focus_target)
    end
    uri.query = URI.encode_www_form(query)
    uri.to_s
  end

  # Search History and Saved Searches display
  def link_to_previous_search(params, accessible_label = '')
    search_state = controller.search_state_class.new(params, blacklight_config, self)
    link_to(
      tag.span(accessible_label, class: 'sr-only') + render(ConstraintsComponent.for_search_history(search_state: search_state)),
      search_action_path(params),
      class: 'd-block'
    )
  end
end
