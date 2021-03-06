require "rails_helper"

feature "Account scoping" do
  let!(:account_a) {FactoryGirl.create(:account)}
  let!(:account_b) {FactoryGirl.create(:account)}

  before do
    #Apartment::Database.switch(account_a.subdomain)
    Thing.scoped_to(account_a).create(name: "Account A's Thing")
    #Apartment::Database.switch(account_b.subdomain)
    Thing.scoped_to(account_b).create(name: "Account B's Thing")
    #Apartment::Database.reset
  end

  scenario "displays only account A's Thing" do
    sign_in_as(user: account_a.owner, account: account_a)
    visit subscribem.root_url(subdomain: account_a.subdomain)
    visit main_app.things_url(subdomain: account_a.subdomain)
    expect(page).to have_content("Account A's Thing")
    expect(page).to_not have_content("Account B's Thing")
  end

  scenario "display only account B's Thing" do
    sign_in_as(user: account_b.owner, account: account_b)
    visit main_app.things_url(subdomain: account_b.subdomain)
    expect(page).to have_content("Account B's Thing")
    expect(page).to_not have_content("Account A's Thing")
  end

end