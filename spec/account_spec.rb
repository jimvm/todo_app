require_relative "../app/persistence"

def slug
  Account.create_slug
end

RSpec.describe Account do
  after(:each) do
    db = Sequel.postgres "todo_test"

    db[:activities].delete
    db[:accounts].delete
  end

  describe ".verify" do
    before(:each) do
      Account.create name: "someone",
                     password_hash: Account.create_password_hash("test"),
                     url_slug: Account.create_slug
    end

    context "unauthorized" do
      context "when account does not exist" do
        it "returns false" do
          response = Account.verify username: "someone_else", password: "test"

          expect(response).to be false
        end
      end

      context "when password does not match" do
        it "returns false" do
          response = Account.verify username: "someone", password: "testing"

          expect(response).to be false
        end
      end
    end

    context "authorized" do
      it "returns true" do
        response = Account.verify username: "someone", password: "test"

        expect(response).to be true
      end
    end
  end

  describe "#name" do
    context "database constraint" do
      it "ensures it is unique" do
        Account.create name: "myname", url_slug: slug, password_hash: "test"

        duplicate_name = Account.new name: "myname", url_slug: slug, password_hash: "test"

        expect{duplicate_name.save(validate: false)}.to raise_error \
        Sequel::UniqueConstraintViolation
      end

      it "ensures it is at least 4 characters" do
        name = Account.new name: "jim", url_slug: slug, password_hash: "test"

        expect{name.save(validate: false)}.to raise_error \
        Sequel::CheckConstraintViolation
      end

      it "ensures it is less than 25 characters" do
        name = Account.new name: "some_really_really_long_name", url_slug: slug, password_hash: "test"

        expect{name.save(validate: false)}.to raise_error \
        Sequel::CheckConstraintViolation
      end
    end

    context "model validation" do
      it "ensures it is unique" do
        Account.create name: "myname", url_slug: slug, password_hash: "test"

        expect{Account.create name: "myname", url_slug: slug}.to raise_error \
        Sequel::ValidationFailed, "name is already taken"
      end

      it "ensures it can not be shorter than 4 characters" do
        expect{Account.create name: "jim", url_slug: slug}.to raise_error \
        Sequel::ValidationFailed, "name is shorter than 4 characters"
      end

      it "ensures it can not be longer than 24 characters" do
        expect{Account.create name: "some_really_really_long_name", url_slug: slug}.to raise_error \
        Sequel::ValidationFailed, "name is longer than 24 characters"
      end
    end
  end

  describe "#url_slug" do
    let!(:account) do
      Account.create url_slug: "duplicate_00", name: "some_name", password_hash: "test"
    end

    context "database constraints" do
      it "ensures it is unique" do
        duplicate_slug = Account.new url_slug: "duplicate_00", name: "myname", password_hash: "test"

        expect{duplicate_slug.save(validate: false)}.to raise_error \
        Sequel::UniqueConstraintViolation
      end

      it "ensures it is exactly 12 characters" do
        short_slug = Account.new url_slug: "something", name: "myname", password_hash: "test"

        expect{short_slug.save(validate: false)}.to raise_error \
        Sequel::CheckConstraintViolation
      end
    end

    context "model validations" do
      it "ensures it is unique" do
        expect do
          Account.create name: "myname", url_slug: "duplicate_00"
        end.to raise_error Sequel::ValidationFailed, "url_slug is already taken"
      end

      it "ensures it is exactly 12 characters" do
        expect do
          Account.create name: "myname", url_slug: "just_eleven"
        end.to raise_error Sequel::ValidationFailed, "url_slug is not 12 characters"
      end
    end
  end
end

RSpec.context "Accounts with Activities" do
  after(:each) do
    db = Sequel.postgres "todo_test"

    db[:activities].delete
    db[:accounts].delete
  end

  let(:account)           { Account.create name: "somename", url_slug: slug, password_hash: "test" }
  let(:different_account) { Account.create name: "othername", url_slug: slug, password_hash: "test" }

  before do
    account.add_activity Activity.new description: "somedescription", url_slug: slug
    account.save
  end

  context "database constraint" do
    it "ensures accounts can not have activities with the same description" do
      db = Sequel.postgres "todo_test"

      expect do
        db[:activities].insert description: "somedescription", account_id: account.id, url_slug: slug
      end.to raise_error Sequel::UniqueConstraintViolation
    end

    it "ensures different accounts can have an activity with the same description" do
      expect do
        different_account.add_activity Activity.new description: "somedescription", url_slug: slug
        different_account.save
      end.not_to raise_error
    end
  end

  context "model validation" do
    it "ensures accounts can not have activities with the same description" do
      expect do
        account.add_activity Activity.new description: "somedescription", url_slug: slug
        account.save
      end.to raise_error Sequel::ValidationFailed,
        "description and account_id is already taken"
    end
  end
end
