require 'rails_helper'

RSpec.describe ComponentHelper, type: :helper do
  include Devise::Test::ControllerHelpers

  before do
    allow(helper).to receive(:blacklight_config).and_return(blacklight_config)
    allow(controller).to receive(:render_bookmarks_control?).and_return(true)
    allow_any_instance_of(ActionDispatch::TestResponse).to receive(:documents).and_return([document])
    allow(document).to receive(:response).and_return(response)
  end

  let(:document) do
    SolrDocument.new(:id => '123abc', blacklight_config.index.title_field => ["test Title"])
  end
  let(:response) { instance_double(Blacklight::Solr::Response, total: 10) }
  let(:blacklight_config) do
    CatalogController.blacklight_config.deep_copy.tap do |config|
      config.track_search_session.storage = false
    end
  end

  describe "#render_doc_actions" do
    subject { helper.render_doc_actions(document) }

    let(:bookmark_component_selector) { 'form.bookmark-toggle label.toggle-bookmark input.toggle-bookmark[type="checkbox"]' }

    context "in index view" do
      before do
        controller.action_name = "index"
      end

      it 'renders an ActionsComponent wrapping the BookmarkComponent' do
        expect(subject).to have_css(".index-document-functions > #{bookmark_component_selector}")
        expect(subject).to have_text('Bookmark test Title')
      end
    end

    context "in show view" do
      before do
        controller.action_name = "show"
      end

      it 'renders a ShowToolsComponent wrapping the BookmarkComponent' do
        expect(subject).to have_css('.card.show-tools .card-header h2')
        expect(subject).to have_text('Tools')
        expect(subject).to have_css(".card.show-tools #{bookmark_component_selector}")
        expect(subject).to have_text('Bookmark test Title')
      end
    end
  end
end
