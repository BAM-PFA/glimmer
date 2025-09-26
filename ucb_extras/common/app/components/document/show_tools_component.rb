# frozen_string_literal: true

module Document
  # Render the tools that display on the sidebar of the show page
  class ShowToolsComponent < Blacklight::Document::ShowToolsComponent
    # @param [Blacklight::Document] document
    def initialize(document:)
      super
    end
  end
end
