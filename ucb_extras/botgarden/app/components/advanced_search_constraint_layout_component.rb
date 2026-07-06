# frozen_string_literal: true

class AdvancedSearchConstraintLayoutComponent < SearchHistoryConstraintLayoutComponent
  def render?
    @value.present?
  end
end
