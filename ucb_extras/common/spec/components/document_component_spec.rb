# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DocumentComponent, type: :component do

  subject(:component) { described_class.new(document: document, **attr) }

  let(:attr) { {} }
  let(:view_context) { controller.view_context }

  let(:render) do
    component.render_in(view_context)
  end

  let(:rendered) do
    Capybara::Node::Simple.new(render)
  end

  let(:document) { Blacklight::IndexPresenter.new(presented_document, view_context) }

  let(:presented_document) do
    SolrDocument.new(
      :id => 'x',
      (blacklight_config.index.thumbnail_field).to_sym => ['image_id'],
      (blacklight_config.index.title_field).to_sym =>  ['Title'],
      **doc_fields
    )
  end

  let(:doc_fields) do
    fields_key = blacklight_config[controller.action_name][:document_fields_key] if controller.action_name
    field_config = blacklight_config[:facet_fields].merge(blacklight_config[fields_key || :index_fields])
    field_config.transform_values do |value|
      ["test #{value.label}"]
    end
  end

  let(:blacklight_config) do
    CatalogController.blacklight_config.deep_copy.tap do |config|
      config.track_search_session.storage = false
    end
  end

  before do
    # Every call to view_context returns a different object. This ensures it stays stable.
    # allow(controller).to receive_messages(view_context: view_context, current_or_guest_user: User.new, blacklight_config: blacklight_config)
    allow(controller).to receive_messages(
      view_context: view_context,
      current_or_guest_user: User.new,
      blacklight_config: blacklight_config,
      current_user: nil
    )
    # allow(view_context).to receive_messages(search_session: {}, current_search_session: nil, current_bookmarks: [])
    allow(view_context).to receive_messages(
      respond_to?: :search_session,
      search_session: {},
      current_search_session: nil,
      current_bookmarks: [],
      blacklight_config: blacklight_config,
    )
  end

  it 'has some defined content areas' do
    component.with_title { 'Title' }
    component.with_embed('Embed')
    component.with_metadata('Metadata')
    component.with_thumbnail('Thumbnail')
    component.with_actions { 'Actions' }
    render_inline component

    expect(rendered).to have_content 'Title'
    expect(rendered).to have_content 'Embed'
    expect(rendered).to have_content 'Metadata'
    expect(rendered).to have_content 'Thumbnail'
    expect(rendered).to have_content 'Actions'
  end

  it 'has schema.org properties' do
    component.with_body { '-' }
    render_inline component

    expect(rendered).to have_css 'article[@itemtype="http://schema.org/Thing"]'
    expect(rendered).to have_css 'article[@itemscope]'
  end

  context 'with a provided body' do
    it 'opts-out of normal component content' do
      component.with_body { 'Body content' }
      render_inline component

      expect(rendered).to have_content 'Body content'
      expect(rendered).to have_no_css 'h3'
      expect(rendered).to have_no_css 'dl'
    end
  end

  context 'index view' do
    before do
      controller.action_name = "index"
    end

    let(:attr) { { counter: 5 } }

    it 'has data properties' do
      component.with_body { '-' }
      render_inline component

      expect(rendered).to have_css 'article[@data-document-id="x"]'
      expect(rendered).to have_css 'article[@data-document-counter="5"]'
    end

    it 'renders a linked title' do
      expect(rendered).to have_link 'Title', href: '/catalog/x'
    end

    it 'renders a counter with the title' do
      expect(rendered).to have_css 'h3', text: '5. Title'
    end

    context 'with a document rendered as part of a collection' do
      # ViewComponent 3 changes iteration counters to begin at 0 rather than 1
      let(:document_counter) { ViewComponent::VERSION::MAJOR < 3 ? 11 : 10 }
      let(:attr) { { document_counter: document_counter, counter_offset: 100 } }

      it 'renders a counter with the title' do
        # after ViewComponent 2.5, collection counter params are 1-indexed
        expect(rendered).to have_css 'h3', text: '111. Title'
      end
    end

    it 'renders actions' do
      expect(rendered).to have_css '.index-document-functions'
    end

    it 'renders a thumbnail, overriding Blacklight with a specific link URL and alt text' do
      expect(rendered).to have_css '.document-thumbnail a[href="/catalog/x"] img[alt][src="https://webapps.cspace.berkeley.edu/cinefiles/imageserver/blobs/image_id/derivatives/Medium/content"]'
    end

    context 'with default metadata component' do
      it 'renders metadata' do
        expect(rendered).to have_css 'dl.document-metadata'
        blacklight_config[:index_fields].each do |key, value|
          expect(rendered).to have_css 'dt', text: "#{value.label}:"
          if value.helper_method
            expected = Capybara::Node::Simple.new(view_context.send(value.helper_method, {value: presented_document[key], document: presented_document}))
            unless expected.blank? || expected.native.blank?
              expect(rendered).to have_css 'dd', text: expected.text
            end
          else
            expect(rendered).to have_css 'dd', text: doc_fields[key].first
          end
        end
      end
    end
  end

  context 'show view' do
    let(:attr) { { title_component: :h1, show: true } }

    before do
      controller.action_name = "show"
    end

    it 'renders with an id' do
      component.with_body { '-' }
      render_inline component

      expect(rendered).to have_css 'article#document'
    end

    it 'renders a title' do
      expect(rendered).to have_css 'h1', text: 'Title'
    end

    it 'renders with show-specific metadata' do
      expect(rendered).to have_css 'dl.document-metadata'
      blacklight_config[:show_fields].each do |key, value|
        expect(rendered).to have_css 'dt', text: "#{value.label}:"
        if value.helper_method
          expected = Capybara::Node::Simple.new(view_context.send(value.helper_method, {value: presented_document[key], document: presented_document}))
          unless expected.blank? || expected.native.blank?
            expect(rendered).to have_css 'dd', text: expected.text
          end
        else
          expect(rendered).to have_css 'dd', text: doc_fields[key].first
        end
      end
    end

    it 'renders an embed' do
      stub_const('StubComponent', Class.new(ViewComponent::Base) do
        def initialize(**); end

        def call
          'embed'.html_safe
        end
      end)

      blacklight_config.show.embed_component = StubComponent
      expect(rendered).to have_content 'embed'
    end

    context 'show view with custom translation' do
      let!(:original_translations) { I18n.backend.send(:translations).deep_dup }

      before do
        controller.action_name = "show"
        I18n.backend.store_translations(:en, blacklight: { search: { show: { label: "testing:%{label}" } } })
      end

      after do
        I18n.backend.reload!
        I18n.backend.store_translations(:en, original_translations[:en])
      end

      it 'renders with show-specific metadata with correct translation' do
        expect(rendered).to have_css 'dl.document-metadata'
        expect(rendered).to have_css 'dt', text: 'testing:Images'
        expect(rendered).to have_css 'dd img[alt]'
      end
    end

    context 'with configured metadata component' do
      let(:custom_component_class) do
        Class.new(Blacklight::DocumentMetadataComponent) do
          # Override component rendering with our own value
          def call
            'blah'.html_safe
          end
        end
      end

      before do
        stub_const('MyMetadataComponent', custom_component_class)
        blacklight_config.show.metadata_component = MyMetadataComponent
      end

      it 'renders custom component' do
        expect(rendered).to have_text 'blah'
      end
    end

    context 'with configured title component' do
      let(:custom_component_class) do
        Class.new(Blacklight::DocumentTitleComponent) do
          # Override component rendering with our own value
          def call
            'Titleriffic'.html_safe
          end
        end
      end

      before do
        stub_const('MyTitleComponent', custom_component_class)
        blacklight_config.show.title_component = MyTitleComponent
      end

      it 'renders custom component' do
        expect(rendered).to have_text 'Titleriffic'
      end
    end
  end

  it 'renders partials' do
    component.with_partial { 'Partials' }
    expect(rendered).to have_content 'Partials'
  end

  it 'has no partials by default' do
    component.render_in(view_context)

    expect(component.partials?).to be false
  end

  context 'with before_titles' do
    let(:render) do
      component.render_in(view_context) do
        component.with_title do |c|
          c.with_before_title { 'Prefix!' }
        end
      end
    end

    it 'shows the prefix' do
      expect(rendered).to have_content "Prefix!"
    end
  end
end
