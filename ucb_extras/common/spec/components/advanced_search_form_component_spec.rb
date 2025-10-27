# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdvancedSearchFormComponent, type: :component do
  subject(:render) do
    component.render_in(view_context)
  end

  let(:component) { described_class.new(url: '/whatever', response: response, params: params) }
  let(:response) do
    Blacklight::Solr::Response.new(
      {
        facet_counts: {
          facet_fields: {
            format: { 'Book' => 10, 'CD' => 5 }
          }
        }
      }.with_indifferent_access, {}
    )
  end
  let(:params) { {} }

  let(:rendered) do
    Capybara::Node::Simple.new(render)
  end

  let(:view_context) { controller.view_context }

  let(:blacklight_config) do
    Blacklight::Configuration.new.configure do |config|
      for field in ['all_fields', 'title', 'author', 'subject', 'format'] do
        config.add_search_field field
        config.add_facet_field(field) do |f|
          f.include_in_advanced_search = true
        end
      end
      config.add_sort_field('title')
      config.add_sort_field('author')
    end
  end

  before do
    allow(view_context).to receive(:respond_to?).with(:facet_limit_for).and_return(true)
    allow(view_context).to receive(:respond_to?).with(:facet_limit_for, false).and_return(true)
    allow(view_context).to receive(:facet_limit_for).and_return(nil)
    allow(view_context).to receive(:blacklight_config).and_return(blacklight_config)
  end

  context 'with additional parameters' do
    let(:params) { { some: :parameter, an_array: [1, 2] } }

    it 'adds additional parameters as hidden fields' do
      expect(rendered).to have_field 'some', with: 'parameter', type: :hidden
      expect(rendered).to have_field 'an_array[]', with: '1', type: :hidden
      expect(rendered).to have_field 'an_array[]', with: '2', type: :hidden
    end
  end

  it 'has text fields for each search field' do
    expect(rendered).to have_css '.advanced-search-field', count: 5
    expect(rendered).to have_field 'clause_0_field', with: 'all_fields', type: :hidden
    expect(rendered).to have_field 'clause_1_field', with: 'title', type: :hidden
    expect(rendered).to have_field 'clause_2_field', with: 'author', type: :hidden
    expect(rendered).to have_field 'clause_3_field', with: 'subject', type: :hidden
    expect(rendered).to have_field 'clause_4_field', with: 'format', type: :hidden
  end

  it 'has filters' do
    expect(rendered).to have_css '.blacklight-format'
    expect(rendered).to have_field 'f_inclusive[format][]', with: 'Book'
    expect(rendered).to have_field 'f_inclusive[format][]', with: 'CD'
  end

  it 'has a sort field' do
    expect(rendered).to have_select 'sort', options: ['Title', 'Author']
  end
end
