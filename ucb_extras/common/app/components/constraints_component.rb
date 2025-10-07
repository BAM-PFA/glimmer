# frozen_string_literal: true

class ConstraintsComponent < Blacklight::ConstraintsComponent

  def self.for_advanced_search(**kwargs)
    new(tag: :dl,
      render_headers: false,
      id: nil,
      classes: 'query row mx-0',
      query_constraint_component: AdvancedSearchConstraintLayoutComponent,
      facet_constraint_component_options: { layout: AdvancedSearchConstraintLayoutComponent },
      start_over_component: nil,
      **kwargs)
  end

  def self.for_search_history(**kwargs)
    new(tag: :dl,
        render_headers: false,
        id: nil,
        classes: 'query row',
        query_constraint_component: SearchHistoryConstraintLayoutComponent,
        facet_constraint_component_options: { layout: SearchHistoryConstraintLayoutComponent },
        start_over_component: nil,
        **kwargs)
  end

  def initialize(
      search_state:,
      tag: :div,
      render_headers: true,
      id: 'appliedParams',
      classes: 'clearfix constraints-container',
      query_constraint_component: ConstraintLayoutComponent,
      query_constraint_component_options: {},
      facet_constraint_component: ConstraintComponent,
      facet_constraint_component_options: {},
      start_over_component: StartOverButtonComponent
    )
    @index = 0
    super
  end

  def query_constraints
    if @search_state.query_param.present? || (!@search_state.has_constraints? && is_for_search_history?)
      render(
        @query_constraint_component.new(
          search_state: @search_state,
          index: @index,
          value: @search_state.query_param,
          label: label,
          remove_path: remove_path,
          classes: 'query',
          **@query_constraint_component_options
        )
      )
    else
      ''.html_safe
    end + render(@facet_constraint_component.with_collection(clause_presenters.to_a, **{index: @index, **@facet_constraint_component_options}))
  end

  def facet_constraints
    render(@facet_constraint_component.with_collection(facet_item_presenters.to_a, **{index: @index, **@facet_constraint_component_options}))
  end

  def render?
    @search_state.has_constraints? || is_for_search_history?
  end

  private

  def clause_presenters
    return to_enum(:clause_presenters) unless block_given?

    @search_state.clause_params.each do |key, clause|
      field_config = helpers.blacklight_config.search_fields[clause[:field]]
      if clause['query'].present?
        yield Blacklight::ClausePresenter.new(key, clause, field_config, helpers)
      else
        next
      end
    end
  end

  def is_for_search_history?
    @query_constraint_component.name == 'SearchHistoryConstraintLayoutComponent'
  end
end
