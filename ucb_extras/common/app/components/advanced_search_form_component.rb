# frozen_string_literal: true

class AdvancedSearchFormComponent < Blacklight::AdvancedSearchFormComponent

  def default_operator_menu
    options_with_labels = [:must, :should].index_by { |op| t(op, scope: 'blacklight.advanced_search.op') }
    label_tag(
      :op,
      t('blacklight.advanced_search.op.label'),
      class: 'sr-only visually-hidden'
    ) + select_tag(
      :op,
      options_for_select(options_with_labels, params[:op]),
      aria: {label: 'search operator'},
      autocomplete: 'on',
      class: 'input-small'
    )
  end

  private

  def initialize_search_field_controls
    search_fields.values.each.with_index do |field, i|
      with_search_field_control do
        fields_for('clause[]', i, include_id: false) do |f|
          content_tag(:div, class: 'form-group advanced-search-field') do
            f.label(:query, field.display_label('search'), class: 'col-12') +
              content_tag(:div, class: 'col-lg-9') do
                f.hidden_field(:field, value: field.key) +
                  f.text_field(:query, value: query_for_search_clause(field.key), class: 'form-control')
              end
          end
        end
      end
    end
  end

  def initialize_constraints
    params = helpers.search_state.params_for_search.except(
      :page,
      :f_inclusive,
      :q,
      :search_field,
      :op,
      :index,
      :sort
    )

    adv_search_context = helpers.search_state.reset(params)
    constraints_text = render(ConstraintsComponent.for_advanced_search(search_state: adv_search_context))
    return if constraints_text.blank?

    with_constraint do
      constraints_text
    end
  end
end
