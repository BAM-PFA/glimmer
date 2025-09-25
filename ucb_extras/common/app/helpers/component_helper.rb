# frozen_string_literal: true

module ComponentHelper
  include Blacklight::ComponentHelperBehavior
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
      counter: counter,
      total: @response.total_count
    }
    render(component.new(document: document, actions: actions, classes: wrapping_class, options: options))
  end
end
