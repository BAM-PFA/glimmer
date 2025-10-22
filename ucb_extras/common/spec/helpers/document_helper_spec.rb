require 'rails_helper'

RSpec.describe DocumentHelper, type: :helper do
  describe "#bookmarked?" do
    let(:bookmark) { Bookmark.new document: bookmarked_document }
    let(:bookmarked_document) { SolrDocument.new(id: 'a') }

    before do
      allow(helper).to receive(:current_bookmarks).and_return([bookmark])
    end

    it "is bookmarked if the document is in the bookmarks" do
      expect(helper.bookmarked?(bookmarked_document)).to be true
    end

    it "does not be bookmarked if the document is not listed in the bookmarks" do
      expect(helper.bookmarked?(SolrDocument.new(id: 'b'))).to be false
    end
  end
end
