require_relative "../app/persistence"

RSpec.describe Activity do

  let(:slug)    { Activity.create_slug }
  let(:account) { Account.create name: "somename", url_slug: slug, password_hash: "test" }

  describe "#description" do
    let(:empty_description)     { "" }
    let(:long_description) do
      "This is a very long description of a task with way too many
       information about what I want to do."
    end

    subject do
      activity = Activity.new url_slug: slug, description: test_description
      activity.account = account
      activity
    end

    context "when it is empty" do
      let(:test_description) { empty_description }

      specify do
        expect{ subject.save(validate: false) }.to raise_error \
        Sequel::CheckConstraintViolation
      end

      specify do
        expect{ subject.save }.to raise_error \
        Sequel::ValidationFailed, "description is shorter than 1 characters"
      end
    end

    context "when it is longer than 80 characters" do
      let(:test_description) { long_description }

      specify do
        expect{subject.save(validate: false)}.to raise_error \
        Sequel::CheckConstraintViolation
      end

      specify do
        expect{ subject.save }.to raise_error \
        Sequel::ValidationFailed, "description is longer than 80 characters"
      end
    end
  end

  describe "#url_slug" do
    before do
      activity = Activity.new url_slug: duplicate, description: "some description"
      activity.account = account
      activity.save
    end

    let(:duplicate) { "duplicate_00" }
    let(:too_short) { "too_short" }

    subject do
      activity = Activity.new url_slug: test_slug, description: "something"
      activity.account = account
      activity
    end

    context "when it is not unique" do
      let(:test_slug) { duplicate }

      specify do
        expect{ subject.save(validate: false) }.to raise_error \
        Sequel::UniqueConstraintViolation
      end

      specify do
        expect{ subject.save }.to raise_error Sequel::ValidationFailed, "url_slug is already taken"
      end
    end

    context "when it is not exactly 12 characters" do
      let(:test_slug) { too_short }

      specify do
        expect{ subject.save(validate: false) }.to raise_error \
        Sequel::CheckConstraintViolation
      end

      specify do
        expect{ subject.save }.to raise_error Sequel::ValidationFailed, "url_slug is not 12 characters"
      end
    end
  end
end
