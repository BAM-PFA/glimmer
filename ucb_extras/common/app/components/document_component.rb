# frozen_string_literal: true

##
# A component for rendering a single document
#
# @note when subclassing this component, if you override the initializer,
#    you must explicitly specify the counter variable `document_counter` even if you don't use it.
#    Otherwise view_component will not provide the count value when calling the component.
#
# @see https://viewcomponent.org/guide/collections.html#collection-counter
#
# @example
#  class MyDocumentComponent < Blacklight::DocumentComponent
#    def initialize(document_counter: nil, **kwargs)
#      super
#      ... custom code ...
#    end
#  end
class DocumentComponent < Blacklight::DocumentComponent

  # @param document [Blacklight::DocumentPresenter]
  # @param presenter [Blacklight::DocumentPresenter] alias for document
  # @param partials [Array, nil] view partial names that should be used to provide content for the `partials` slot
  # @param id [String] HTML id for the root element
  # @param classes [Array, String] additional HTML classes for the root element
  # @param component [Symbol, String] HTML tag type to use for the root element
  # @param title_component [Symbol, String] HTML tag type to use for the title element
  # @param counter [Number, nil] a pre-computed counter for the position of this document in a search result set
  # @param document_counter [Number, nil] provided by ViewComponent collection iteration
  # @param counter_offset [Number] the offset of the start of the collection counter parameter for the component to the overall result set
  # @param show [Boolean] are we showing only a single document (vs a list of search results); used for backwards-compatibility
  def initialize(
      document: nil,
      presenter: nil,
      partials: nil,
      id: nil,
      classes: [],
      component: :article,
      title_component: nil,
      counter: nil,
      document_counter: nil,
      counter_offset: 0,
      show: false,
      **args
    )
    super
  end

end
