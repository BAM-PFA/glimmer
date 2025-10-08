# frozen_string_literal: true

module SearchHistoryConstraintsHelper
  # include Blacklight::SearchHistoryConstraintsHelperBehavior
  # include BlacklightAdvancedSearch::RenderConstraintsOverride

  # In the development environment, our database can become polluted with other tenants' search history.
  # Facet constraints from such searches can't be properly displayed because they aren't configured in
  # the currently installed tenant's blacklight_config.facet_fields.
  def search_has_invalid_constraints?(search_state, params)
    query_has_constraints?(params) && !search_state.has_constraints?
  end

  def query_has_constraints?(params)
    if is_advanced_search? params
      true
    else
      (
        params.has_key?(:f) ||
        params.has_key?(:f_inclusive) ||
        params.has_key?(:range)
      )
    end
  end

  def is_advanced_search?(params)
    params[:search_field] == "advanced_search"
  end
end
