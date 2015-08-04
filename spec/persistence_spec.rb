require "rspec"
require_relative "../app/persistence"

RSpec.describe "Persistence Layer" do
  context "Accounts with Activities" do
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
end
