require "rails_helper"
feature "Accounts" do
  scenario "creating an account" do
    visit subscribem.root_path
    click_link 'Account Sign Up'
    fill_in "Name", :with => "Test"
    fill_in "Subdomain", :with => "test"
    fill_in "Email", :with => "subscribem@example.com"
    fill_in "Password", :with => 'password', :exact => true
    fill_in "Password confirmation", :with => "password"

    click_button 'Create Account'
    success_message = "Your account has been successfully created."
    expect(page).to have_content(success_message)
    expect(page).to have_content("Signed in as subscribem@example.com")
    expect(page.current_url).to eq("http://test.example.com/")

  end

  scenario "Ensure subdomain uniqueness" do
    Subscribem::Account.create!(:subdomain => "test", :name => "Test")
    visit subscribem.root_path
    click_link "Account Sign Up"
    fill_in "Name", :with => "Test"
    fill_in "Subdomain", :with => "test"
    fill_in "Email", :with => "subscribem@example.com"
    fill_in "Password", :with => 'password', :exact => true
    fill_in "Password confirmation", :with => "password"

    click_button 'Create Account'
    expect(page.current_url).to eq("http://www.example.com/accounts")
    expect(page).to have_content("Sorry, your account could not be created")
    expect(page).to have_content("Subdomain has already been taken")


  end

  scenario "subdomain with restricted name" do
    visit subscribem.root_path
    click_link "Account Sign Up"
    fill_in "Name", :with => "Test"
    fill_in "Subdomain", :with => "admin"
    fill_in "Email", :with => "subscribem@example.com"
    fill_in "Password", :with => 'password', :exact => true
    fill_in "Password confirmation", :with => "password"

    click_button 'Create Account'
    expect(page.current_url).to eq("http://www.example.com/accounts")
    expect(page).to have_content("Sorry, your account could not be created")
    expect(page).to have_content("is not allowed. Please choose another subdomain")
  end

  scenario "subdomain with restricted name - ANY CASE" do
    visit subscribem.root_path
    click_link "Account Sign Up"
    fill_in "Name", :with => "Test"
    fill_in "Subdomain", :with => "ADMIN"
    fill_in "Email", :with => "subscribem@example.com"
    fill_in "Password", :with => 'password', :exact => true
    fill_in "Password confirmation", :with => "password"

    click_button 'Create Account'
    expect(page.current_url).to eq("http://www.example.com/accounts")
    expect(page).to have_content("Sorry, your account could not be created")
    expect(page).to have_content("is not allowed. Please choose another subdomain")
  end

  scenario "subdomain with restricted name - normal characters" do
    visit subscribem.root_path
    click_link "Account Sign Up"
    fill_in "Name", :with => "Test"
    fill_in "Subdomain", :with => "<ADMIN>"
    fill_in "Email", :with => "subscribem@example.com"
    fill_in "Password", :with => 'password', :exact => true
    fill_in "Password confirmation", :with => "password"

    click_button 'Create Account'
    expect(page.current_url).to eq("http://www.example.com/accounts")
    expect(page).to have_content("Sorry, your account could not be created")
    expect(page).to have_content("is not allowed. Please choose another subdomain")
  end
end

feature "User signup" do
  let!(:account) {FactoryGirl.create(:account)}
  let!(:root_url) {"http://#{account.subdomain}.example.com/"}
  scenario "under an account" do
    visit root_url
    page.current_url.should == root_url + "sign_in"
    click_link "New User?"
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"
    page.should have_content("You have signed up successfully.")
    page.current_url.should == root_url
  end
end

