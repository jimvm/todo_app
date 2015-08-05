require_relative "../app/persistence"

RSpec.describe Account do

  def slug
    Account.create_slug
  end

  describe ".verify" do
    before do
      Account.create name: "someone",
                     password_hash: Account.create_password_hash("test"),
                     url_slug: slug
    end

    context "when account does not exist" do
      subject { Account.verify username: "someone_else", password: "test" }

      it { is_expected.to be false }
    end

    context "when password does not match" do
      subject { Account.verify username: "someone", password: "testing" }

      it { is_expected.to be false }
    end

    context "when the account is authorized" do
      subject { Account.verify username: "someone", password: "test" }

      it { is_expected.to be true }
    end
  end

  describe "#name" do
    subject { Account.new name: test_name, url_slug: slug, password_hash: "test" }

    context "when it is not unique" do
      before do
        Account.create name: "myname", url_slug: slug, password_hash: "test"
      end

      let(:test_name) { "myname" }

      specify do
        expect{ subject.save(validate: false) }.to raise_error \
        Sequel::UniqueConstraintViolation
      end

      specify do
        expect{ subject.save }.to raise_error \
        Sequel::ValidationFailed, "name is already taken"
      end
    end

    context "when it is shorter than 4 characters" do
      let(:test_name) { "jim" }

      specify do
        expect{ subject.save(validate: false) }.to raise_error \
        Sequel::CheckConstraintViolation
      end

      specify do
        expect{ subject.save }.to raise_error \
        Sequel::ValidationFailed, "name is shorter than 4 characters"
      end
    end

    context "when it is longer than 24 characters" do
      let(:test_name) { "some_really_really_long_name" }

      specify do
        expect{ subject.save(validate: false) }.to raise_error \
        Sequel::CheckConstraintViolation
      end

      specify do
        expect{ subject.save }.to raise_error \
        Sequel::ValidationFailed, "name is longer than 24 characters"
      end
    end
  end

  describe "#url_slug" do
    before do
      Account.create url_slug: "duplicate_00", name: "some_name", password_hash: "test"
    end

    context "when it is not unique" do
      subject { duplicate_slug = Account.new url_slug: "duplicate_00", name: "myname", password_hash: "test" }

      specify do
        expect{subject.save(validate: false)}.to raise_error \
        Sequel::UniqueConstraintViolation
      end

      specify do
        expect{ subject.save}.to raise_error \
        Sequel::ValidationFailed, "url_slug is already taken"
      end
    end

    context "when it is not exactly 12 characters" do
      subject do
        Account.new url_slug: "something", name: "myname", password_hash: "test"
      end

      specify do
        expect{ subject.save(validate: false)}.to raise_error \
        Sequel::CheckConstraintViolation
      end

      specify do
        expect do
          Account.create name: "myname", url_slug: "just_eleven"
        end.to raise_error Sequel::ValidationFailed, "url_slug is not 12 characters"
      end
    end
  end

  context "with Activities" do
    let(:account)           { Account.create name: "somename", url_slug: slug, password_hash: "test" }
    let(:different_account) { Account.create name: "othername", url_slug: slug, password_hash: "test" }
    let(:description)       { "somedescription" }

    before do
      account.add_activity Activity.new description: description, url_slug: slug
      account.save
    end

    let(:database) do
      db = Sequel.postgres "todo_test"
      db[:activities]
    end

    context "when an account has activities with the same description" do
      subject do
        account.add_activity Activity.new description: description, url_slug: slug
        account
      end

      specify do
        expect do
          database.insert description: description, account_id: account.id, url_slug: slug
        end.to raise_error Sequel::UniqueConstraintViolation
      end

      specify do
        expect{ subject.save }.to raise_error Sequel::ValidationFailed,
          "description and account_id is already taken"
      end
    end

    context "when a different account has an activity with the same description" do
      subject do
        different_account.add_activity Activity.new description: description, url_slug: slug
        different_account
      end

      specify do
        expect do
          database.insert description: description, account_id: different_account.id, url_slug: slug
        end.not_to raise_error
      end

      specify { expect{ subject.save }.not_to raise_error }
    end
  end
end
