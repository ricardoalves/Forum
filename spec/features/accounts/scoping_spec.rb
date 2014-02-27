require "spec_helper" 

feature "Accountscoping" do
	Subscribem::Account.delete_all
	Thing.delete_all
	let!(:account_a) { FactoryGirl.create(:account) } 
 	let!(:account_b) { FactoryGirl.create(:account) } 

 	before do
		Thing.scoped_to( account_a ).create(name: "Account A's Thing")
		Thing.scoped_to( account_b ).create(name: "Account B's Thing")
	end
	
	scenario "displays only account A's records" do 
		sign_in_as(user: account_a.owner, account: account_a) 
		visit main_app.things_url(subdomain: account_a.subdomain)
		page.should have_content("Account A's Thing") 
		page.should_not have_content("Account B's Thing")
	end

	scenario "displays only account B's records" do
    sign_in_as(user: account_b.owner, account: account_b)
    visit main_app.things_url(subdomain: account_b.subdomain)
    page.should have_content("Account B's Thing")
    page.should_not have_content("Account A's Thing")
	end

end
