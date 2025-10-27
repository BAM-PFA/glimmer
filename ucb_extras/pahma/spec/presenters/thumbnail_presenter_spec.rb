# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ThumbnailPresenter do
  include Capybara::RSpecMatchers
  let(:view_context) { double "View context" }
  let(:config) { Blacklight::Configuration.new.view_config(:index) }
  let(:presenter) { described_class.new(document, view_context, config) }
  let(:document) { SolrDocument.new }

  describe "#exists?" do
    subject { presenter.exists? }

    context "when thumbnail_method is configured" do
      let(:config) do
        Blacklight::OpenStructWithHashAccess.new(thumbnail_method: :xyz)
      end

      it { is_expected.to be true }
    end

    context "when thumbnail_field is configured as a single field" do
      let(:config) do
        Blacklight::OpenStructWithHashAccess.new(thumbnail_field: :xyz)
      end

      context "and the field exists in the document" do
        let(:document) { SolrDocument.new('xyz' => 'image.png') }

        it { is_expected.to be true }
      end

      context "and the field is missing from the document" do
        it { is_expected.to be false }
      end
    end

    context "when thumbnail_field is configured as an array of fields" do
      let(:config) do
        Blacklight::OpenStructWithHashAccess.new(thumbnail_field: [:rst, :uvw, :xyz])
      end

      context "and the field exists in the document" do
        let(:document) { SolrDocument.new('xyz' => 'image.png') }

        it { is_expected.to be true }
      end
    end

    context "when default_thumbnail is configured" do
      let(:config) do
        Blacklight::OpenStructWithHashAccess.new(default_thumbnail: 'image.png')
      end

      context "and the field exists in the document" do
        it { is_expected.to be true }
      end
    end

    context "without any configured options" do
      it { is_expected.to be_falsey }
    end
  end

  describe "#thumbnail_tag" do
    subject { presenter.thumbnail_tag }

    let(:img_src) { "https://webapps.cspace.berkeley.edu/pahma/imageserver/blobs/image_id/derivatives/Medium/content" }
    let(:img_alt) { "Hearst Museum object no title available, no object museum number available, no description available." }
    let(:image) { "<img src=\"#{img_src}\" alt=\"#{img_alt}\">" }

    context "when thumbnail_method is configured" do
      let(:config) do
        Blacklight::OpenStructWithHashAccess.new(thumbnail_method: :xyz)
      end

      context "and the method returns a value" do
        before do
          allow(view_context).to receive_messages(xyz: "some-thumbnail")
        end

        it "calls the provided thumbnail method" do
          allow(view_context).to receive(:link_to_document).with(document, "some-thumbnail", {}).and_return("link")
          expect(subject).to eq "link"
          expect(view_context).to have_received(:xyz)
        end

        context "and url options have :suppress_link" do
          subject { presenter.thumbnail_tag({}, suppress_link: true) }

          it "does not link to the document" do
            expect(subject).to eq "some-thumbnail"
          end
        end
      end

      context "and no value is returned from the thumbnail method" do
        before do
          allow(view_context).to receive_messages(xyz: nil)
        end

        it { is_expected.to be_nil }
      end
    end

    context "when thumbnail_field is configured" do
      before do
        allow(document).to receive(:fetch).with(:xyz, nil).and_return("image_id")
        allow(view_context).to receive(:image_tag).with(img_src, {"alt"=>img_alt}).and_return(image)
        allow(view_context).to receive(:link_to_document)
      end

      let(:config) do
        Blacklight::OpenStructWithHashAccess.new(thumbnail_field: :xyz)
      end

      it "creates an image tag from the given field" do
        subject
        expect(view_context).to have_received(:link_to_document).with(document, image, {})
      end

      it "returns nil if no thumbnail is in the document" do
        expect(subject).to be_nil
      end
    end

    context "when thumbnail_field is configured as an array of fields" do
      before do
        allow(view_context).to receive(:image_tag).with(img_src, {"alt"=>img_alt}).and_return(image)
        allow(view_context).to receive(:link_to_document).and_return('<a><img></a>')
      end

      let(:config) do
        Blacklight::OpenStructWithHashAccess.new(thumbnail_field: [:rst, :uvw, :xyz])
      end

      context "and the field exists in the document" do
        let(:document) { SolrDocument.new(xyz: 'image_id') }

        it "creates an image tag from the given field" do
          expect(presenter.thumbnail_tag).to eq '<a><img></a>'
          expect(view_context).to have_received(:link_to_document).with(document, image, {})
        end
      end
    end

    context "when default_thumbnail is configured" do
      context "and is a string" do
        before do
          allow(view_context).to receive(:image_tag).with("image.png", {}).and_return('<img src="image.jpg">')
        end

        let(:config) do
          Blacklight::OpenStructWithHashAccess.new(default_thumbnail: 'image.png')
        end

        it "creates an image tag for the given asset" do
          expect(presenter.thumbnail_tag({}, suppress_link: true)).to eq '<img src="image.jpg">'
        end
      end

      context "and is a symbol" do
        before do
          allow(view_context).to receive(:get_a_default_thumbnail).with(document, {}).and_return('<img src="image.jpg">')
        end

        let(:config) do
          Blacklight::OpenStructWithHashAccess.new(default_thumbnail: :get_a_default_thumbnail)
        end

        it "calls that helper method" do
          expect(presenter.thumbnail_tag({}, suppress_link: true)).to eq '<img src="image.jpg">'
        end
      end

      context "and is a proc" do
        let(:config) do
          Blacklight::OpenStructWithHashAccess.new(default_thumbnail: ->(_, _) { '<img src="image.jpg">' })
        end

        it "calls that lambda" do
          expect(presenter.thumbnail_tag({}, suppress_link: true)).to eq '<img src="image.jpg">'
        end
      end
    end

    context "when no thumbnail is configured" do
      it { is_expected.to be_nil }
    end
  end

  describe "#render_thumbnail_alt_text" do
    subject { presenter.render_thumbnail_alt_text }

    let(:config) do
      Blacklight::OpenStructWithHashAccess.new(thumbnail_field: :blob_ss)
    end
    let(:document) { SolrDocument.new(
      :blob_ss => 'image_id',
      :card_ss => card_ss,
      :objdescr_txt => description,
      :objname_txt => title,
      :objmusno_txt => museum_number,
      :restrictions_ss => restrictions
    ) }
    let(:card_ss) { [] }
    let(:description) { ['very nice'] }
    let(:title) { ['An Object'] }
    let(:museum_number) { ['123-abc'] }
    let(:restrictions) { ['public'] }

    it "returns a detailed and identifying description of an image" do
      expect(subject).to eq 'Hearst Museum object titled An Object, museum number 123-abc, described as very nice.'
    end

    context "when it's an image of an associated document" do
      let(:card_ss) { ['image_id'] }
      it "includes 'Documentation associated with'" do
        expect(subject).to eq 'Documentation associated with Hearst Museum object titled An Object, museum number 123-abc, described as very nice.'
      end
    end

    context "when the object has no description" do
      let(:description) { nil }

      it "includes 'no description available'" do
        expect(subject).to eq 'Hearst Museum object titled An Object, museum number 123-abc, no description available.'
      end
    end

    context "when the image is restricted" do
      let(:restrictions) { ['notpublic'] }

      it "includes the image restricted notice" do
        expect(subject).to eq 'Hearst Museum object titled An Object, museum number 123-abc, described as very nice. Notice: Image restricted due to its potentially sensitive nature. Contact Museum to request access.'
      end
    end

    context "when the object has no title" do
      let(:title) { nil }

      it "includes 'no title available''" do
        expect(subject).to eq 'Hearst Museum object no title available, museum number 123-abc, described as very nice.'
      end
    end

    context "when the object has no museum number" do
      let(:museum_number) { nil }

      it "includes 'no museum number available''" do
        expect(subject).to eq 'Hearst Museum object titled An Object, no object museum number available, described as very nice.'
      end
    end
  end
end
