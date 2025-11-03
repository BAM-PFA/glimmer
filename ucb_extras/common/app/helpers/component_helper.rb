# frozen_string_literal: true

module ComponentHelper
  include Blacklight::ComponentHelperBehavior

  def render_doc_actions(document, wrapping_class: 'index-document-functions', component: Blacklight::Document::ActionsComponent, counter: nil)
    if action_name == 'show'
      render_show_tools(document)
    elsif action_name == 'index'
      render_index_doc_actions(document, wrapping_class: wrapping_class, component: component, counter: counter)
    end
  end

  def render_show_tools(document)
    blacklight_config.view_config(:show).show_tools_component&.tap do |show_tools_component_class|
      return render show_tools_component_class.new(document: document)
    end
    render Document::ShowToolsComponent document: document
  end

  ##
  # Render "document actions" area for search results view
  # (normally renders next to title in the list view)
  #
  # @param [SolrDocument] document
  # @param [String] wrapping_class ("index-document-functions")
  # @param [Class] component (Blacklight::Document::ActionsComponent)
  # @param [Integer] counter the position of this document in the list of documents
  # @return [String]
  def render_index_doc_actions(document, wrapping_class: "index-document-functions", component: Blacklight::Document::ActionsComponent, counter: nil)
    actions = filter_partials(blacklight_config.view_config(document_index_view_type).document_actions, { document: document }).map { |_k, v| v }
    options = {
      counter: counter || if search_session then search_session['counter'] else nil end,
      total: document.response.total
    }
    render(component.new(document: document, actions: actions, options: options, classes: wrapping_class))
  end
end
