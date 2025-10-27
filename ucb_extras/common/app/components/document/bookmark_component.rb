# frozen_string_literal: true

module Document
  # Render a bookmark widget to bookmark / unbookmark a document
  class BookmarkComponent < Blacklight::Document::BookmarkComponent
    # @param [Blacklight::Document] document
    # @param [Integer] counter the position of this bookmark component
    # @param [Integer] total the number of bookmark components on the page
    # @param [Blacklight::Configuration::ToolConfig] action
    # @param [Boolean] checked
    # @param [Object] bookmark_path the rails route to use for bookmarks
    def initialize(document:, action: nil, options: nil, checked: nil, bookmark_path: nil, **kwargs)
      @document = document
      @checked = checked
      @bookmark_path = bookmark_path
      @counter = options && options[:counter]
      @total = options && options[:total]
    end

    def label
      helpers.search_result_unique_label @document, @counter, @total
    end
  end
end
