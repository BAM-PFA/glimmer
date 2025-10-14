# frozen_string_literal: true

class FacetFieldPaginationComponent < Blacklight::FacetFieldPaginationComponent
  def initialize(facet_field:, button_classes: %w[btn btn-outline-secondary], html_id: 'facet-pagination')
    @facet_field = facet_field
    @button_classes = button_classes.join(' ')
    @html_id = html_id
  end

  def sort_facet_url(sort)
    @facet_field.paginator.params_for_resort_url(sort, @facet_field.search_state.to_h)
  end

  def param_name
    @facet_field.paginator.class.request_keys[:page]
  end

  def render?
    @facet_field.paginator
  end
end
