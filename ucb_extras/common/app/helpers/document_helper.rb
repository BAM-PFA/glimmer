# frozen_string_literal: true

# Helper methods for catalog-like controllers that work with documents
module DocumentHelper
  include Blacklight::DocumentHelperBehavior

  ##
  # Check if the document is in the user's bookmarks
  # @param [Blacklight::Document] document
  # @return [Boolean]
  def bookmarked? document
    current_bookmarks.any? { |x| x.document_id == document.id && x.document_type.to_s == document.class.to_s }
  end
end
