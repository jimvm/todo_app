require_relative "../app/persistence"

RSpec.describe Activity do
  after(:each) do
    db = Sequel.postgres "todo_test"

    db[:activities].delete
    db[:accounts].delete
  end

  def slug
    Activity.create_slug
  end

  let(:account) { Account.create name: "somename", url_slug: slug, password_hash: "test" }

  describe "#description" do
    let(:empty_description)     { "" }
    let(:long_description) do
      "This is a very long description of a task with way too many
       information about what I want to do."
    end

    describe "database constraint" do
      it "ensures it can not be empty" do
        activity = Activity.new description: empty_description, url_slug: slug
        activity.account = account

        expect{activity.save(validate: false)}.to raise_error \
        Sequel::CheckConstraintViolation
      end

      it "ensures it can not be longer than 80 characters" do
        activity = Activity.new description: long_description, url_slug: slug
        activity.account = account

        expect{activity.save(validate: false)}.to raise_error \
        Sequel::CheckConstraintViolation
      end
    end

    describe "model validation" do
      it "ensures it can not be empty" do
        expect{Activity.create description: empty_description, url_slug: slug}.to raise_error \
        Sequel::ValidationFailed, "description is shorter than 1 characters"
      end

      it "ensures it can not be longer than 80 characters" do
        expect{Activity.create description: long_description, url_slug: slug}.to raise_error \
        Sequel::ValidationFailed, "description is longer than 80 characters"
      end
    end
  end

  describe "#url_slug" do
    let!(:activity) do
      activity = Activity.new url_slug: "duplicate_00", description: "some description"
      activity.account = account
      activity.save
    end

    context "database constraint" do
      it "ensures it is unique" do
        duplicate_slug = Activity.new url_slug: "duplicate_00", description: "something"
        duplicate_slug.account = account

        expect{duplicate_slug.save(validate: false)}.to raise_error \
        Sequel::UniqueConstraintViolation
      end

      it "ensures it is exactly 12 characters" do
        empty_slug = Activity.new description: "something", url_slug: "too_short"
        empty_slug.account = account

        expect{empty_slug.save(validate: false)}.to raise_error \
        Sequel::CheckConstraintViolation
      end
    end

    context "model validations" do
      it "ensures it is unique" do
        expect do
          Activity.create description: "test", url_slug: "duplicate_00"
        end.to raise_error Sequel::ValidationFailed, "url_slug is already taken"
      end

      it "ensures it is exactly 12 characters" do
        expect do
          Activity.create description: "test", url_slug: "just_eleven"
        end.to raise_error Sequel::ValidationFailed, "url_slug is not 12 characters"
      end
    end
  end
end
