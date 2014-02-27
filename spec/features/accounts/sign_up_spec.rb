require "spec_helper"
feature "Accounts" do
	scenario "Creating an account" do
		Subscribem::User.delete_all
		Subscribem::Account.delete_all
		visit subscribem.root_path
		click_link "Account Sign Up"

		fill_in "Name", 									with: "Test"
		fill_in "Subdomain",							with: "test"
		fill_in "Email", 									with: "subscribem@example.com"
		fill_in "Password",							 	with: "password", exact: true
		fill_in "Password confirmation",	with: "password"

		click_button "Create Account"
		success_message = "Your account has been successfully created."
		
		page.should have_content( success_message )
		page.should have_content( "Signed in as subscribem@example.com" )
		page.current_url.should == "http://test.example.com/"
	end

	scenario "Ensure subdomain uniqueness" do
		Subscribem::User.delete_all
		Subscribem::Account.delete_all
		Subscribem::Account.create!( subdomain: "test", name: "Test" )
		visit subscribem.root_path
		click_link "Account Sign Up"

		fill_in "Name", 									with: "Test"
		fill_in "Subdomain",							with: "test"
		fill_in "Email", 									with: "subscribem@example.com"
		fill_in "Password",							 	with: "password", exact: true
		fill_in "Password confirmation",	with: "password"

		click_button "Create Account"
		page.current_url.should == "http://example.com/accounts"
		page.should have_content( "Sorry, your account could not be created." )
		page.should have_content( "Subdomain has already been taken")
	end

	scenario "Subdomain with restricted name" do
		Subscribem::User.delete_all
		Subscribem::Account.delete_all
		visit subscribem.root_path
		click_link "Account Sign Up"

		fill_in "Name", 									with: "Test"
		fill_in "Subdomain", 							with: "admin"
		fill_in "Email", 									with: "subscribem@example.com"
		fill_in "Password",							 	with: "password", exact: true
		fill_in "Password confirmation",	with: "password"

		click_button "Create Account"
		page.current_url.should == "http://example.com/accounts"
		page.should have_content( "Sorry, your account could not be created." )
		page.should have_content( "Subdomain is not allowed. Please choose another \
															 subdomain.")
	end

	scenario "Subdomain with invalid name" do
		Subscribem::User.delete_all
		Subscribem::Account.delete_all
		visit subscribem.root_path
		click_link "Account Sign Up"

		fill_in "Name", 									with: "Test"
		fill_in "Subdomain",							with: "<admin>"
		fill_in "Email", 									with: "subscribem@example.com"
		fill_in "Password",							 	with: "password", exact: true
		fill_in "Password confirmation",	with: "password"

		click_button "Create Account"
		page.current_url.should == "http://example.com/accounts"
		page.should have_content( "Sorry, your account could not be created." )
		page.should have_content( "Subdomain is not allowed. Please choose another \
															 subdomain.")
	end
end