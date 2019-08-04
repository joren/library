require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "auth_token created" do
    user = User.create!(name: "foo", email: "foo@bar.be")
    assert_not_equal user.auth_token, nil
    assert_not_equal user.auth_token, ""
  end

  test "auth token expires" do
    user = User.create!(name: "foo", email: "foo@bar.be")
    assert_not_equal user.auth_token_expires_at, nil
    assert user.auth_token_expires_at < 25.hours.from_now
  end

  test "default can't invite users" do
    assert_equal User.new.can_invite_users, false
  end
end
