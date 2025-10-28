require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the LayoutHelper. For example:
#
# describe LayoutHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe LayoutHelper, type: :helper do
  describe '#show_content_classes' do
    it 'overrides Blacklight::LayoutHelperBehavior to force a 12-column layout ' do
      expect(helper.show_content_classes).to be_an String
      expect(helper.show_content_classes).to eq 'col-12 show-document'
    end
  end

  describe '#container_classes' do
    before do
      allow(view).to receive(:blacklight_config).and_return(config)
    end

    context 'when not full-width' do
      let(:config) { Blacklight::Configuration.new }

      it 'overrides Blacklight::LayoutHelperBehavior to make the container fluid at any screen width' do
        expect(helper.container_classes).to be_an String
        expect(helper.container_classes).to eq 'container-fluid'
      end
    end

    context 'when full-width' do
      let(:config) { Blacklight::Configuration.new(full_width_layout: true) }

      it 'makes the container fluid' do
        expect(helper.container_classes).to be_an String
        expect(helper.container_classes).to eq 'container-fluid'
      end
    end
  end

  describe '#html_tag_attributes' do
    before do
      allow(I18n).to receive(:locale).and_return('x')
    end

    it 'returns the current locale as the lang' do
      expect(helper.html_tag_attributes).to include lang: 'x'
    end
  end
end
