# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gallery::SlideshowPreviewComponent, type: :component do
  subject(:component) do
    described_class.new(document: presenter, document_counter: 5, **attr)
  end

  let(:attr) { {} }
  let(:view_context) { vc_test_controller.view_context }
  let(:render) do
    component.render_in(view_context)
  end

  let(:rendered) do
    Capybara::Node::Simple.new(render)
  end

  let(:presenter) { Blacklight::IndexPresenter.new(document, view_context, blacklight_config) }

  before do
    allow(view_context).to receive(:blacklight_config).and_return(blacklight_config)
    allow(view_context).to receive(:current_search_session).and_return(nil)
    allow(view_context).to receive(:search_session).and_return({})

    # Every call to view_context returns a different object. This ensures it stays stable.
    allow(vc_test_controller).to receive(:view_context).and_return(view_context)
  end

  let(:blacklight_config) do
    Blacklight::Configuration.new.tap do |config|
      config.index.thumbnail_field = 'thumbnail_path_ss'
      config.index.thumbnail_presenter = ThumbnailPresenter
      config.view.slideshow.preview_component = Gallery::SlideshowPreviewComponent
      config.track_search_session.storage = false
    end
  end

  describe 'default thumbnail' do
    let(:document) { SolrDocument.new(id: 'abc', thumbnail_path_ss: 'image_id') }
    let(:img_src) { "https://webapps.cspace.berkeley.edu/pahma/imageserver/blobs/image_id/derivatives/Medium/content" }
    let(:img_alt) { "Hearst Museum object no title available, no object museum number available, no description available." }

    it 'Overrides Blacklight::ThumbnailPresenter to render thumbnail with alt text and a different image src' do
      expect(rendered).to have_selector "a.thumbnail img[src=\"#{img_src}\"][alt=\"#{img_alt}\"]"
    end

    it 'renders the correct slide number' do
      expect(rendered).to have_css '[data-slide-to=\"5\"][data-bs-slide-to=\"5\"]'
    end

    context 'when the presenter returns nothing' do
      let(:document) { SolrDocument.new(id: 'abc') }

      subject { rendered }
      it { is_expected.to have_selector '.thumbnail-placeholder', text: 'Missing' }
    end
  end
end
