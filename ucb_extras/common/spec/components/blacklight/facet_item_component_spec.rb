# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Blacklight::FacetItemComponent, type: :component do
  let(:component) { described_class.new(facet_item: facet_item) }
  let(:render) { component.render_in(view_context) }
  let(:view_context) { controller.view_context }
  let(:rendered) { render_inline_to_capybara_node(component) }

  before do
    allow(facet_item).to receive(:value).and_return(facet_item)
  end

  let(:facet_item) do
    instance_double(
      Blacklight::FacetItemPresenter,
      facet_config: Blacklight::Configuration::FacetField.new,
      label: 'x',
      hits: 10,
      href: '/catalog?f=x',
      selected?: false
    )
  end

  it 'links to the facet and shows the number of hits, overriding Blacklight to add sr_alert and focus_target to the URL' do
    expect(rendered).to have_css 'li'
    expect(rendered).to have_link 'x', href: '/catalog?f=x&sr_alert=Added+%3A+%22x%22+to+search+constraints&focus_target%5B%5D=%23remove-facet-x-instancedouble-blacklight-facetitempresenter-anonymous&focus_target%5B%5D=%23facet-x-toggle-btn&focus_target%5B%5D=%23facet-panel-collapse-toggle-btn' do |link|
      link['rel'] == 'nofollow'
    end
    expect(rendered).to have_css '.facet-count', text: '10'
  end

  context 'with a selected facet' do
    let(:facet_item) do
      instance_double(
        Blacklight::FacetItemPresenter,
        facet_config: Blacklight::Configuration::FacetField.new,
        label: 'x',
        hits: 10,
        href: '/catalog',
        selected?: true
      )
    end

    it 'links to the facet and shows the number of hits, overriding Blacklight to add sr_alert and focus_target to the URL and customize the Remove button' do
      expect(rendered).to have_css 'li'
      expect(rendered).to have_css '.selected', text: 'x'
      expect(rendered).to have_link 'Remove constraint : x', href: '/catalog?sr_alert=Removed+%3A+%22x%22+from+search+constraints&focus_target%5B%5D=%23add-facet-x-instancedouble-blacklight-facetitempresenter-anonymous&focus_target%5B%5D=%23facet-x-toggle-btn&focus_target%5B%5D=%23facet-panel-collapse-toggle-btn' do |link|
        link['rel'] == 'nofollow'
      end
      expect(rendered).to have_css '.selected.facet-count', text: '10'
    end
  end
end
