# frozen_string_literal: true

require "application_system_test_case"

class RegistrationFlowTest < ApplicationSystemTestCase
  test "register user" do
    fake_origin = ENV['WEBAUTHN_ORIGIN']
    fake_client = WebAuthn::FakeClient.new(fake_origin)

    fixed_challenge = SecureRandom.random_bytes(32)
    WebAuthn::CredentialCreationOptions.stub_any_instance :challenge, fixed_challenge do
      fake_credentials = fake_client.create(challenge: fixed_challenge)
      register_user(fake_credentials: fake_credentials)
    end

    assert_current_path '/'
    assert_text 'USB key'
    assert_button 'account_circle'
  end
end