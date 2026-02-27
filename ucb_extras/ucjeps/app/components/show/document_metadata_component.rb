# frozen_string_literal: true

module Show
  class DocumentMetadataComponent < Blacklight::DocumentMetadataComponent

    # @param fields [Enumerable<Blacklight::FieldPresenter>] Document field presenters
    # rubocop:disable Metrics/ParameterLists
    def initialize(
        fields: [],
        tag: 'div',
        classes: 'document-metadata dl-invert row pl-2',
        show: false,
        view_type: nil,
        field_layout: nil,
        **component_args
      )
      @fields = fields
      @tag = tag
      @classes = classes
      @show = show
      @view_type = view_type
      @field_layout = field_layout
      @component_args = component_args
      @document = @fields.peek.document
    end
    # rubocop:enable Metrics/ParameterLists

    def before_render
      return unless fields

      @doc_presenter = helpers.document_presenter(@document)
      @fields.each do |field|
        with_field(component: field.component, field: field, show: @show, view_type: @view_type, layout: @field_layout)
      end
    end

    def render?
      true
    end
  end
end
