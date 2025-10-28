# frozen_string_literal: true

# Methods added to this helper will be available to all templates in the hosting
# application
# A module for useful methods used in layout configuration
module LayoutHelper
  include Blacklight::LayoutHelperBehavior
  ##
  # Classes added to a document's show content div
  # @return [String]
  def show_content_classes
    'col-12 show-document'
  end

  ##
  # Class used for specifying main layout container classes. Can be
  # overwritten to return 'container-fluid' for Bootstrap full-width layout
  # @return [String]
  def container_classes
    'container-fluid'
  end
end
