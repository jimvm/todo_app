require "rspec"
require_relative "../app/persistence"

RSpec.describe "Persistence Layer" do
  after(:each) do
    db = Sequel.postgres "todo_test"

    db[:activities].delete
    db[:accounts].delete
  end

  describe "Activities" do
    context "description" do
      let(:empty_description)     { "" }
      let(:long_description) do
        "This is a very long description of a task with way too many
         information about what I want to do."
      end

      describe "database constraint" do
        it "ensures it can not be empty" do
          activity = Activity.new description: empty_description

          expect{activity.save(validate: false)}.to raise_error \
          Sequel::CheckConstraintViolation
        end

        it "ensures it can not be longer than 80 characters" do
          activity = Activity.new description: long_description

          expect{activity.save(validate: false)}.to raise_error \
          Sequel::CheckConstraintViolation
        end
      end

      describe "model validation" do
        it "ensures it can not be empty" do
          expect{Activity.create description: empty_description}.to raise_error \
          Sequel::ValidationFailed, "description is shorter than 1 characters"
        end

        it "ensures it can not be longer than 80 characters" do
          expect{Activity.create description: long_description}.to raise_error \
          Sequel::ValidationFailed, "description is longer than 80 characters"
        end
      end
    end

    describe "url_slug" do
      context "database constraint" do
        it "ensures it is unique" do
          Activity.create url_slug: "fake_slug", description: "some description"

          duplicate_slug = Activity.new url_slug: "fake_slug", description: "something"

          expect{duplicate_slug.save(validate: false)}.to raise_error \
          Sequel::UniqueConstraintViolation
        end
      end
    end
  end

  describe "Accounts" do
    describe "name" do
      context "database constraint" do
        it "ensures it is unique" do
          Account.create name: "myname"

          duplicate_name = Account.new name: "myname"

          expect{duplicate_name.save(validate: false)}.to raise_error \
          Sequel::UniqueConstraintViolation
        end

        it "ensures it is at least 4 characters" do
          name = Account.new name: "jim"

          expect{name.save(validate: false)}.to raise_error \
          Sequel::CheckConstraintViolation
        end

        it "ensures it is less than 25 characters" do
          name = Account.new name: "some_really_really_long_name"

          expect{name.save(validate: false)}.to raise_error \
          Sequel::CheckConstraintViolation
        end
      end

      context "model validation" do
        it "ensures it is unique" do
          Account.create name: "myname"

          expect{Account.create name: "myname"}.to raise_error \
          Sequel::ValidationFailed, "name is already taken"
        end

        it "ensures it can not be shorter than 4 characters" do
          expect{Account.create name: "jim"}.to raise_error \
          Sequel::ValidationFailed, "name is shorter than 4 characters"
        end

        it "ensures it can not be longer than 24 characters" do
          expect{Account.create name: "some_really_really_long_name"}.to raise_error \
          Sequel::ValidationFailed, "name is longer than 24 characters"
        end
      end
    end
  end

  describe "Accounts with Activities" do
    let(:account)           { Account.create name: "somename" }
    let(:different_account) { Account.create name: "othername" }

    before do
      account.add_activity Activity.create description: "somedescription"
    end

    context "database constraint" do
      it "ensures accounts can not have activities with the same description" do
        db = Sequel.postgres "todo_test"

        expect do
          db[:activities].insert description: "somedescription", account_id: account.id
        end.to raise_error Sequel::UniqueConstraintViolation
      end

      it "ensures different accounts can have an activity with the same description" do
        expect do
          different_account.add_activity Activity.create description: "somedescription"
        end.not_to raise_error
      end
    end

    context "model validation" do
      it "ensures accounts can not have activities with the same description" do
        expect do
          account.add_activity Activity.create description: "somedescription"
        end.to raise_error Sequel::ValidationFailed,
          "description and account_id is already taken"
      end
    end
  end
end
