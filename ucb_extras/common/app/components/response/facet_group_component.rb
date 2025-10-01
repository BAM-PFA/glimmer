# frozen_string_literal: true

module Response
  # Render a group of facet fields
  class FacetGroupComponent < Blacklight::Response::FacetGroupComponent

    def should_collapse_facets?
      helpers.search_state.filters.blank?
    end
  end
end
