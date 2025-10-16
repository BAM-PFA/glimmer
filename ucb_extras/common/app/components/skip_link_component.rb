# frozen_string_literal: true

class SkipLinkComponent < Blacklight::SkipLinkComponent

  def link_classes
    'bg-white rounded-bottom visually-hidden-focusable sr-only sr-only-focusable d-inline-flex py-2 px-3'
  end
end
