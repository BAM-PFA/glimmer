# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Blacklight::FacetFieldListComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(facet_field: facet_field))
  end

  before do
    allow(facet_field).to receive(:display_facet).and_return(display_facet)
    allow(facet_field).to receive(:in_advanced_search?).and_return(is_advanced_search)
  end

  let(:facet_field) do
    instance_double(
      Blacklight::FacetFieldPresenter,
      paginator: paginator,
      facet_field: facet_config,
      display_facet: display_facet,
      key: 'field',
      label: 'Field',
      active?: false,
      collapsed?: false,
      modal_path: nil,
      values: []
    )
  end

  let(:display_facet) do
    instance_double(Blacklight::Solr::Response::Facets::FacetField, items: [], sort: :index, offset: 0, prefix: nil)
  end

  let(:facet_config) { Blacklight::Configuration::NullField.new(key: 'field', item_component: Blacklight::FacetItemComponent, item_presenter: Blacklight::FacetItemPresenter) }

  let(:paginator) do
    instance_double(Blacklight::FacetPaginator, items: [
                      double(label: 'x', hits: 10),
                      double(label: 'y', hits: 33)
                    ])
  end

  let(:is_advanced_search) { false }

  it 'renders a collapsible card' do
    expect(rendered).to have_css '.card'
    expect(rendered).to have_button 'Field'
    expect(rendered).to have_css 'button[data-bs-target="#facet-field"]'
    expect(rendered).to have_css '#facet-field.collapse.show'
  end

  it 'renders the facet items' do
    expect(rendered).to have_css 'ul.facet-values'
    expect(rendered).to have_css 'li', count: 2
  end

  context 'with an active facet' do
    let(:facet_field) do
      instance_double(
        Blacklight::FacetFieldPresenter,
        paginator: paginator,
        facet_field: facet_config,
        key: 'field',
        label: 'Field',
        active?: true,
        collapsed?: false,
        modal_path: nil,
        values: []
      )
    end

    it 'adds the facet-limit-active class' do
      expect(rendered).to have_css 'div.facet-limit-active'
    end
  end

  context 'with a collapsed facet' do
    let(:facet_field) do
      instance_double(
        Blacklight::FacetFieldPresenter,
        paginator: paginator,
        facet_field: facet_config,
        key: 'field',
        label: 'Field',
        active?: false,
        collapsed?: true,
        modal_path: nil,
        values: []
      )
    end

    it 'renders a collapsed facet' do
      expect(rendered).to have_css '.facet-content.collapse'
      expect(rendered).to have_no_css '.facet-content.collapse.show'
    end

    it 'renders the toggle button in the collapsed state' do
      expect(rendered).to have_css '.btn.collapsed'
      expect(rendered).to have_css '.btn[aria-expanded="false"]'
    end
  end

  context 'with a modal_path' do
    let(:facet_field) do
      instance_double(
        Blacklight::FacetFieldPresenter,
        paginator: paginator,
        facet_field: facet_config,
        key: 'field',
        label: 'Field',
        active?: false,
        collapsed?: false,
        modal_path: '/catalog/facet/modal',
        values: []
      )
    end

    it 'renders a link to the modal' do
      expect(rendered).to have_link 'more Field', href: '/catalog/facet/modal'
    end

    context 'on the advanced search page' do
      let(:is_advanced_search) { true }

      it 'overrides Blacklight::FacetFieldComponent to suppress the link to the modal (see HMP-449)' do
      expect(rendered).not_to have_link 'more Field', href: '/catalog/facet/modal'
    end
    end
  end

  context 'with inclusive facets' do
    let(:facet_field) do
      instance_double(
        Blacklight::FacetFieldPresenter,
        paginator: paginator,
        facet_field: facet_config,
        key: 'field',
        label: 'Field',
        active?: false,
        collapsed?: false,
        modal_path: nil,
        values: [%w[a b c]],
        search_state: search_state
      )
    end

    let(:blacklight_config) do
      Blacklight::Configuration.new.configure do |config|
        config.add_facet_field :field
      end
    end
    let(:search_state) { Blacklight::SearchState.new(params.with_indifferent_access, blacklight_config) }
    let(:params) { { f_inclusive: { field: %w[a b c] } } }

    it 'displays the constraint above the list, overriding Blacklight to add sr_alert and focus_targets to the remove link URL' do
      expect(rendered).to have_css '.inclusive_or .facet-label', text: 'a'
      expect(rendered).to have_link href: 'http://test.host/catalog?f_inclusive%5Bfield%5D%5B%5D=b&f_inclusive%5Bfield%5D%5B%5D=c&sr_alert=Removed%2520%253A%2520%2522a%2522%2520from%2520search%2520constraints&focus_target=%255B%2522%2523add-facet-a-a%2522%252C%2520%2522%2523facet-a-toggle-btn%2522%252C%2520%2522%2523facet-panel-collapse-toggle-btn%2522%255D'
      expect(rendered).to have_css '.inclusive_or .facet-label', text: 'b'
      expect(rendered).to have_link href: 'http://test.host/catalog?f_inclusive%5Bfield%5D%5B%5D=a&f_inclusive%5Bfield%5D%5B%5D=c&sr_alert=Removed%2520%253A%2520%2522b%2522%2520from%2520search%2520constraints&focus_target=%255B%2522%2523add-facet-b-b%2522%252C%2520%2522%2523facet-b-toggle-btn%2522%252C%2520%2522%2523facet-panel-collapse-toggle-btn%2522%255D'
      expect(rendered).to have_css '.inclusive_or .facet-label', text: 'c'
      expect(rendered).to have_link href: 'http://test.host/catalog?f_inclusive%5Bfield%5D%5B%5D=a&f_inclusive%5Bfield%5D%5B%5D=b&sr_alert=Removed%2520%253A%2520%2522c%2522%2520from%2520search%2520constraints&focus_target=%255B%2522%2523add-facet-c-c%2522%252C%2520%2522%2523facet-c-toggle-btn%2522%252C%2520%2522%2523facet-panel-collapse-toggle-btn%2522%255D'
    end
  end
end
