# frozen_string_literal: true

class ConstraintComponent < Blacklight::ConstraintComponent

  def initialize(facet_item_presenter:, facet_item_presenter_counter:, index:, classes: 'filter', layout: ConstraintLayoutComponent)
    @facet_item_presenter = facet_item_presenter
    @index = index + facet_item_presenter_counter
    @classes = classes
    @layout = layout
  end

  # In the development environment, if our database is polluted with other tenants' search history then the
  # facet_config/field_config for those searches will be nil. Here we avoid trying to display such searches.
  def render?
    (
      @facet_item_presenter.respond_to?(:facet_config) && @facet_item_presenter.facet_config.present?
    ) || (
      @facet_item_presenter.respond_to?(:field_config) && @facet_item_presenter.field_config.present?
    )
  end
end
