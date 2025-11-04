# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlHelper do
  let(:blacklight_config) do
    Blacklight::Configuration.new.configure do |config|
      config.index.title_field = 'title_tsim'
      config.index.display_type_field = 'format'
    end
  end

  let(:parameter_class) { ActionController::Parameters }

  before do
    allow(controller).to receive_messages(
      respond_to?: :search_state_class,
      controller_name: 'test',
      search_state_class: Blacklight::SearchState
    )
    allow(helper).to receive(:search_action_path) do |*args|
      search_catalog_url(*args)
    end

    allow(helper).to receive_messages(blacklight_config: blacklight_config)
    allow(helper).to receive_messages(current_search_session: nil)
    allow(helper).to receive(:search_session).and_return({})
  end

  describe "#with_screen_reader_alert" do
    let(:url) { 'test.berkeley.edu' }

    it "adds query parameter 'sr_alert' to a URL" do
      decorated_url = helper.with_screen_reader_alert(url, 'hello, screen reader')
      expect(decorated_url).to eq 'test.berkeley.edu?sr_alert=hello%2C+screen+reader'
    end

    it "adds query parameters 'sr_alert' and 'focus_target' to a URL" do
      decorated_url = helper.with_screen_reader_alert(url, 'hello, screen reader', '#element-id')
      expect(decorated_url).to eq 'test.berkeley.edu?sr_alert=hello%2C+screen+reader&focus_target=%23element-id'
    end

    it "appends to a URL with existing query parameters" do
      url = 'test.berkeley.edu?foo=bar'

      decorated_url = helper.with_screen_reader_alert(url, 'hello, screen reader', '#element-id')
      expect(decorated_url).to eq 'test.berkeley.edu?foo=bar&sr_alert=hello%2C+screen+reader&focus_target=%23element-id'
    end

    it "handles a list of focus targets" do
      focus_targets = [
        '#element-id',
        '.element-class',
        'a > #complex .element.selector'
      ]
      decorated_url = helper.with_screen_reader_alert(url, 'hello, screen reader', focus_targets)
      expect(decorated_url).to eq 'test.berkeley.edu?sr_alert=hello%2C+screen+reader&focus_target=%23element-id&focus_target=.element-class&focus_target=a+%3E+%23complex+.element.selector'
    end
  end

  describe "#link_to_previous_search" do
    let(:params) { { q: 'search query' } }

    it "overrides Blacklight::UrlHelperBehavior#link_to_previous_search to add class=\"d-block\"" do
      expect(helper.link_to_previous_search(params)).to have_css('a.d-block')
    end

    it "overrides Blacklight::UrlHelperBehavior#link_to_previous_search to add an optional accessible label" do
      accessible_label = 'recent search 1 of 3: '
      expect(helper.link_to_previous_search(params, accessible_label)).to have_text(accessible_label)
    end

    it "links to the given search parameters" do
      expect(helper.link_to_previous_search(params)).to have_link(:href => helper.search_action_path(params)).and(have_text('search query'))
    end
  end
end
