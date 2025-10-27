# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConstraintsComponent, type: :component do
  let(:render) do
    component.render_in(view_context)
  end

  let(:component) { described_class.new(**params) }

  let(:rendered) { render_inline_to_capybara_node(component) }

  let(:view_context) { controller.view_context }

  let(:params) do
    { search_state: search_state }
  end

  let(:blacklight_config) do
    Blacklight::Configuration.new.configure do |config|
      config.add_facet_field :some_facet
    end
  end

  let(:search_state) { Blacklight::SearchState.new(query_params.with_indifferent_access, blacklight_config) }
  let(:query_params) { {} }

  context 'with no constraints' do
    describe '#render?' do
      it 'is false' do
        expect(component.render?).to be false
      end
    end
  end

  context 'with a query' do
    let(:query_params) { { q: 'some query' } }

    it 'renders a start-over link, overriding Blacklight::StartOverButtonComponent to add an aria label' do
      expected_btn_text = I18n.t('blacklight.search.start_over')
      expect(rendered).to have_link expected_btn_text, href: '/catalog'
      expect(rendered).to have_css("a[aria-label=\"#{expected_btn_text} Search\"]")
    end

    it 'has a header' do
      expect(rendered).to have_css('h2', text: 'Search Constraints')
    end

    it 'wraps the output in a div' do
      expect(rendered).to have_css('div#appliedParams')
    end

    it 'renders the query' do
      expect(rendered).to have_css('.applied-filter.constraint', text: 'some query')
    end
  end

  context 'with a facet' do
    let(:query_params) { { f: { some_facet: ['some value'] } } }

    it 'renders the query' do
      expect(rendered).to have_css('.constraint-value > .filter-name', text: 'Some Facet').and(have_css('.constraint-value > .filter-value', text: 'some value'))
    end

    context 'that is not configured' do
      let(:query_params) { { f: { some_facet: ['some value'], missing: ['another value'] } } }

      it 'renders only the configured constraints' do
        expect(rendered).to have_css('.constraint-value > .filter-name', text: 'Some Facet').and(have_css('.constraint-value > .filter-value', text: 'some value'))
        expect(rendered).to have_no_css('.constraint-value > .filter-name', text: 'Missing')
      end
    end
  end

  describe '.for_search_history' do
    let(:component) { described_class.for_search_history(**params) }

    let(:query_params) { { q: 'some query', f: { some_facet: ['some value'] } } }

    it 'overrides Blacklight::ConstraintsComponent to wrap the output in a definition list' do
      expect(rendered).to have_css('dl[aria-label="Search Constraints"][role="region"]')
      expect(rendered).to have_css('dl > dt.filter-name')
      expect(rendered).to have_css('dl > dd.filter-values')
    end

    it 'renders the search state as lightly-decorated text' do
      expect(rendered).to have_css('dt.filter-name', text: 'Any Field')
      expect(rendered).to have_css('dd.filter-values', text: 'some query')
      expect(rendered).to have_css('dt.filter-name', text: 'Some Facet')
      expect(rendered).to have_css('dd.filter-values', text: 'some value')
    end

    it 'omits the headers' do
      expect(rendered).to have_no_css('h2', text: 'Search Constraints')
    end
  end
end
