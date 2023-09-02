require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "visiting the index" do
    visit users_url
    assert_selector "h1", text: "Users"
  end

  test "should create user" do
    visit users_url
    click_on "New user"

    fill_in "Name", with: 'New User'
    fill_in "Password", with: "UserPassword149#"
    fill_in "Confirm", with: "UserPassword149#"
    click_on "Create User"

    assert_text "User was successfully created"
  end

  test "should fail to create user with the wrong password confirmation" do
    visit users_url
    click_on "New user"

    fill_in "Name", with: 'New User'
    fill_in "Password", with: "UserPassword149#"
    fill_in "Confirm", with: "UserPassword148#"
    click_on "Create User"

    assert_text "Password confirmation doesn't match Password"
  end

  test "should fail to create user with unreliable password" do
    visit users_url
    click_on "New user"

    fill_in "Name", with: 'New User'
    fill_in "Password", with: "UserPassword149"
    fill_in "Confirm", with: "UserPassword149"
    click_on "Create User"

    assert_text "Password complexity requirement not met"

    fill_in "Name", with: 'New User'
    fill_in "Password", with: "UserPassword#"
    fill_in "Confirm", with: "UserPassword#"
    click_on "Create User"

    assert_text "Password complexity requirement not met"

    fill_in "Name", with: 'New User'
    fill_in "Password", with: "UserPass"
    fill_in "Confirm", with: "UserPasss"
    click_on "Create User"

    assert_text "Password complexity requirement not met"
  end

  test "should update User password" do
    visit user_url(@user)
    click_on "Edit this user", match: :first

    fill_in "Name", with: @user.name
    fill_in "Password", with: "NewSecret149#13"
    fill_in "Confirm", with: "NewSecret149#13"
    fill_in "Old Password", with: "Secret149#13"
    click_on "Update User"

    assert_text "User #{@user.reload.name} was successfully updated"
  end

  test "should faile to update User password without old password" do
    visit user_url(@user)
    click_on "Edit this user", match: :first

    fill_in "Name", with: @user.name
    fill_in "Password", with: "NewSecret149#13"
    fill_in "Confirm", with: "NewSecret149#13"
    click_on "Update User"

    assert_text "Old password is incorrect"
  end

  test "should destroy User" do
    user_for_delete = users(:two)
    visit user_url(user_for_delete)
    click_on "Destroy this user", match: :first
    assert_text "User #{user_for_delete.name} deleteted"
  end

  test "cant destroy last User" do
    user_for_delete = users(:two)
    visit user_url(user_for_delete)
    click_on "Destroy this user", match: :first
    assert_text "User #{user_for_delete.name} deleteted"

    visit user_url(@user)
    click_on "Destroy this user", match: :first
    assert_text "Cant delete last user"
  end
end
