# frozen_string_literal: true

# Override the regular constraint layout to remove any interactive features so this can
# be treated as quasi-plain text
class SearchHistoryConstraintLayoutComponent < ConstraintLayoutComponent
  def call
    label = render_label @label
    value = render_filter_values @value, @label

    safe_join([label, value].compact)
  end

  def render?
    true
  end

  def render_label label
    tag.dt(t('blacklight.search.filters.label', label: @label || 'Any Field'), class: 'filter-name col-6 col-lg-5 col-xl-4')
  end

  def render_filter_values value, key
    tag.dd(render_filter_value(value, key), class: 'filter-values col-6 col-lg-7 col-xl-8 mb-0')
  end

  ##
  # Render the value of the facet
  def render_filter_value value, key = nil
    if value.blank?
      return tag.span('blank', class: 'filter-value sr-only')
    end
    # display_value = if key then facet_display_value(key, value) else value end
    tag.span(h(value), class: 'filter-value')
  end
end
