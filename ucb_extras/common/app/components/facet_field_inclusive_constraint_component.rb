# frozen_string_literal: true

class FacetFieldInclusiveConstraintComponent < Blacklight::FacetFieldInclusiveConstraintComponent
  def html_id
    "facet-#{@facet_field.key.parameterize}"
  end
end
