# frozen_string_literal: true

require "rails_helper"

RSpec.describe UpdatePassword do
  let(:user) { create(:user, password: "password123") }

  def run(current_password: "password123", password: "newpassword123",
          password_confirmation: "newpassword123", user: self.user)
    described_class.run(
      user: user,
      current_password: current_password,
      password: password,
      password_confirmation: password_confirmation
    )
  end

  context "with valid inputs" do
    let(:outcome) { run }

    it "is valid" do
      expect(outcome).to be_valid
    end

    it "updates the password" do
      outcome
      expect(user.reload.valid_password?("newpassword123")).to be true
    end
  end

  context "when the current password is wrong" do
    let(:outcome) { run(current_password: "wrongpassword") }

    it "is invalid" do
      expect(outcome).to be_invalid
    end

    it "adds an error on current_password" do
      expect(outcome.errors[:current_password]).to be_present
    end

    it "does not change the password" do
      outcome
      expect(user.reload.valid_password?("password123")).to be true
    end
  end

  context "when password and password_confirmation do not match" do
    let(:outcome) { run(password: "newpassword123", password_confirmation: "somethingelse") }

    it "is invalid" do
      expect(outcome).to be_invalid
    end

    it "adds an error on password_confirmation" do
      expect(outcome.errors[:password_confirmation]).to be_present
    end

    it "does not change the password" do
      outcome
      expect(user.reload.valid_password?("password123")).to be true
    end
  end

  context "when the new password is shorter than the Devise minimum" do
    let(:outcome) { run(password: "short", password_confirmation: "short") }

    it "is invalid" do
      expect(outcome).to be_invalid
    end

    it "adds an error on password" do
      expect(outcome.errors[:password]).to be_present
    end

    it "does not change the password" do
      outcome
      expect(user.reload.valid_password?("password123")).to be true
    end
  end

  context "when no user is given" do
    let(:outcome) { run(user: nil) }

    it "is invalid" do
      expect(outcome).to be_invalid
    end

    it "adds an error on user" do
      expect(outcome.errors[:user]).to be_present
    end
  end
end
