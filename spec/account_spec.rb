require_relative "../app/persistence"

RSpec.describe Account do
  describe ".verify" do
    before(:all) do
      Account.create name: "someone", password_hash: Account.create_password_hash("test")
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
end
