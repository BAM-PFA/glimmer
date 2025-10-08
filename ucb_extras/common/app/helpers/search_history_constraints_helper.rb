# frozen_string_literal: true

module SearchHistoryConstraintsHelper
  # include Blacklight::SearchHistoryConstraintsHelperBehavior
  # include BlacklightAdvancedSearch::RenderConstraintsOverride

  # In the development environment, our database can become polluted with other tenants' search history.
  # Facet constraints from such searches can't be properly displayed because they aren't configured in
  # the currently installed tenant's blacklight_config.facet_fields.
  def search_has_invalid_constraints?(search_state, params)
    if query_has_facet_constraints?(params)
      return search_state.filters.blank?
    elsif query_has_clause_constraints(params)
      return clause_constraints(search_state).blank?
    end
  end

  def query_has_facet_constraints?(params)
    (
      params.has_key?(:f) ||
      params.has_key?(:f_inclusive) ||
      params.has_key?(:range)
    )
  end

  def is_advanced_search?(params)
    params[:search_field] == "advanced_search"
  end

  def query_has_clause_constraints(params)
    params.has_key?(:clause)
  end

  def clause_constraints(search_state)
    search_state.clause_params.map do |key, clause|
      blacklight_config.search_fields[clause[:field]] unless clause[:query].blank?
    end.compact
  end
end
