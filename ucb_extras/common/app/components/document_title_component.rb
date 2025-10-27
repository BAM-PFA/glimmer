# frozen_string_literal: true

class DocumentTitleComponent < Blacklight::DocumentTitleComponent

  def initialize(
      title = nil,
      document: nil,
      presenter: nil,
      as: :h3,
      counter: nil,
      classes: 'index_title document-title-heading col',
      link_to_document: true,
      document_component: nil,
      actions: true
    )
    super
  end

  # Content for the document title area; should be an inline element
  def title
    if @link_to_document
      helpers.link_to_document(
        presenter.document,
        @title.presence || content.presence,
        counter: @counter,
        itemprop: 'name',
        aria: {
          label: helpers.search_result_unique_label(presenter.document, @counter)
        }
      )
    else
      content_tag('span', @title.presence || content.presence || presenter.heading, itemprop: 'name')
    end
  end

  # Content for the document actions area
  def actions
    return [] unless @actions || ['show', 'index'].include?(action_name)

    if block_given?
      @has_actions_slot = true
      return super
    end

    (@has_actions_slot && get_slot(:actions)) ||
      ([@document_component&.actions] if @document_component&.actions.present?) ||
      [helpers.render_doc_actions(
        presenter.document,
        wrapping_class: 'index-document-functions col-sm-3 col-lg-2',
        counter: @counter
      )]
  end

  def counter
    return unless @counter

    content_tag :span, aria: {hidden: true}, class: 'document-counter' do
      t('blacklight.search.documents.counter', counter: @counter)
    end
  end
end
