# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchHistoryConstraintsHelper, type: :helper do

  before(:all) do
    @config = Blacklight::Configuration.new do |config|
      config.add_search_field 'default_search_field', label: 'Default'

      config.add_facet_field 'one_facet', label: 'One'
      config.add_facet_field 'two_facet', label: 'Two'
      config.add_facet_field 'red_facet', label: 'Red'
      config.add_facet_field 'blue_facet', label: 'Blue'
    end
  end

  before do
    allow(helper).to receive(:blacklight_config).and_return(@config)
  end

  describe "#search_has_invalid_constraints?" do
    subject { helper.search_has_invalid_constraints?(search_state, params) }

    let(:search_state) { Blacklight::SearchState.new(params.with_indifferent_access, @config) }

    shared_examples 'the search has invalid constraints' do
      it "returns true" do
        expect(subject).to be true
      end
    end
    shared_examples 'the search constraints are valid' do
      it "returns false" do
        expect(subject).to be_falsey
      end
    end

    context "when search params contain neither factets nor clauses" do
      let(:params) {
        {}
      }
      it_behaves_like('the search constraints are valid')
    end
    context "when search params include facets not defined in blacklight config" do
      let(:params) {
        {
          f: {
            unknown_facet: 'facet value'
          }
        }
      }
      it_behaves_like('the search has invalid constraints')
    end
    context "when search params contain only facets defined in blacklight config" do
      let(:params) {
        {
          f: {
            two_facet: 'facet value',
            red_facet: 'facet value'
          }
        }
      }
      it_behaves_like('the search constraints are valid')
    end
    context "when search params include clauses not defined in blacklight config" do
      let(:params) {
        {
          :clause=>{
            "0"=>{
              :field=>"text",
              :query=>""
            },
            "1"=>{
              :field=>"unknown_search_field",
              :query=>"facet value"
            }
          }
        }
      }
      it_behaves_like('the search has invalid constraints')
    end
    context "when search params contain only clauses defined in blacklight config" do
      let(:params) {
        {
          "clause"=>{
            "0"=>{
              "field"=>"text",
              "query"=>""
            },
            "1"=>{
              "field"=>"default_search_field",
              "query"=>"facet value"
            }
          }
        }
      }
      it_behaves_like('the search constraints are valid')
    end
  end
end
