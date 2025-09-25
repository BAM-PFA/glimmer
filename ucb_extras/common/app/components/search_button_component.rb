# frozen_string_literal: true

class SearchButtonComponent < Blacklight::SearchButtonComponent

  def call
    tag.button(class: 'btn btn-primary search-btn', type: 'submit', id: @id) do
      tag.span(@text, class: "visually-hidden-sm me-sm-1 submit-search-text") +
        render(Blacklight::Icons::SearchComponent.new aria_hidden: true)
    end
  end
end
