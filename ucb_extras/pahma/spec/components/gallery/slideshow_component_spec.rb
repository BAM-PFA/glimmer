# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gallery::SlideshowComponent, type: :component do
  subject(:component) do
    described_class.new(document: presenter, **attr)
  end

  let(:attr) { {} }
  let(:view_context) { vc_test_controller.view_context }
  let(:render) do
    component.render_in(view_context)
  end

  let(:rendered) do
    Capybara::Node::Simple.new(render)
  end

  let(:document) do
    SolrDocument.new(
      id: 'x',
    )
  end

  let(:presenter) { Blacklight::IndexPresenter.new(document, view_context, blacklight_config) }

  before do
    allow(view_context).to receive(:current_search_session).and_return(nil)
    allow(view_context).to receive(:search_session).and_return({})
    allow(view_context).to receive(:blacklight_config).and_return(blacklight_config)
  end

  describe '#slideshow_tag' do
    subject { rendered }

    context 'with a slideshow method' do
      before do
        allow(view_context).to receive(:respond_to?).with(:xyz).and_return(true)
        allow(view_context).to receive(:respond_to?).with(:session).and_return(true)
      end

      let(:blacklight_config) do
        Blacklight::Configuration.new.tap do |config|
          config.index.slideshow_method = :xyz
          config.track_search_session.storage = false
        end
      end

      it 'calls the provided slideshow method, overriding Blacklight::Gallery::SlideshowComponent with accessible attributes' do
        expect(view_context).to receive_messages(xyz: 'some-slideshow')
        expect(rendered).to have_selector 'div.item[aria-label=" of "][aria-roledescription="slide"][role="group"]'
        expect(rendered).to have_selector 'a[href="/catalog/x"]'
        expect(rendered).to have_text 'some-slideshow'
      end

      it 'does not render an image if the method returns nothing' do
        expect(view_context).to receive_messages(xyz: nil)
        expect(rendered).not_to have_selector 'img'
      end
    end

    context 'with a slideshow field' do
      let(:blacklight_config) do
        Blacklight::Configuration.new.tap do |config|
          config.index.slideshow_field = :xyz
          config.track_search_session.storage = false
        end
      end
      let(:document) { SolrDocument.new({ xyz: 'http://example.com/some.jpg', id: 'x' }) }

      it 'renders an image link, overriding Blacklight::Gallery::SlideshowComponent with accessible attributes' do
        expect(rendered).to have_selector 'div.item[aria-label=" of "][aria-roledescription="slide"][role="group"]'
        expect(rendered).to have_selector 'a[href="/catalog/x"] > img[alt=""][src="http://example.com/some.jpg"]'
      end

      context 'without data in the field' do
        let(:document) { SolrDocument.new({id: 'x'}) }

        it { is_expected.not_to have_selector 'img' }
      end
    end

    context 'with no view_config' do
      let(:blacklight_config) do
        Blacklight::Configuration.new.tap do |config|
          config.track_search_session.storage = false
        end
      end
      it { is_expected.not_to have_selector 'img' }
    end

    context 'falling back to a thumbnail' do
      let(:blacklight_config) do
        Blacklight::Configuration.new.tap do |config|
          config.index.thumbnail_field = :xyz
          config.track_search_session.storage = false
          config.index.thumbnail_presenter = ThumbnailPresenter
        end
      end
      let(:document) { SolrDocument.new({ xyz: 'image_id', id: 'x' }) }
      let(:img_src) { "https://webapps.cspace.berkeley.edu/pahma/imageserver/blobs/image_id/derivatives/Medium/content" }
      let(:img_alt) { "Hearst Museum object no title available, no object museum number available, no description available." }

      it 'renders a thumbnail, overriding Blacklight::Gallery::SlideshowComponent with accessible attributes' do
        expect(rendered).to have_selector 'div.item[aria-label=" of "][aria-roledescription="slide"][role="group"]'
        expect(rendered).to have_selector "a[href=\"/catalog/x\"] > img[alt=\"#{img_alt}\"][src=\"#{img_src}\"]"
      end

      context 'when counter is provided' do
        let(:attr) { { counter: 5 } }

        it 'includes counter in the aria-label' do
          expect(rendered).to have_selector 'div.item[aria-label="5 of "][aria-roledescription="slide"][role="group"]'
        end

        context 'and counter = 1' do
          let(:attr) { { counter: 1 } }

          it "includes 'active' class and counter in the aria-label" do
            expect(rendered).to have_selector 'div.item.active[aria-label="1 of "][aria-roledescription="slide"][role="group"]'
          end
        end

        context 'when count is provided' do
          before do
            allow(document).to receive(:response).and_return(response)
          end
          let(:response) { instance_double(Blacklight::Solr::Response, total: 10) }

          it 'includes count in the aria-label' do
            expect(rendered).to have_selector 'div.item[aria-label="5 of 10"][aria-roledescription="slide"][role="group"]'
          end
        end
      end
    end
  end
end
