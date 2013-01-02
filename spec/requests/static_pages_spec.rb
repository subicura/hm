require 'spec_helper'

describe "StaticPages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'HealthMonster' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }
  end
    
  it "should have the right links on the layout" do
    visit root_path
    click_link "Register as a Parent"
    page.should have_content('Sign up')
    click_link "Home"
    page.should_not have_selector 'title', text: full_title('Sign up')
    click_link "Register as a Parent"
    click_link "HealthMonsterLogo"
    page.should_not have_selector 'title', text: full_title('Sign up')
  end

  describe "parent layout links" do
    it "should have the correct links" do
      parent = FactoryGirl.create(:parent)
      visit signin_path 
      valid_signin(parent)

      should have_link('Account')
      should have_link('Profile',  href: parent_path(parent))
      should have_link('Settings', href: '#')
      should have_link('Sign out', href: signout_path)
      should have_link('Challenges')
      should have_link('Create',   href: new_challenge_path)
      should have_link('Your',     href: '#')
      should have_link('Browse',   href: challenges_path)
    end
  end

  describe "child layout links" do
    #it "should have the correct links" do
    #end
  end
end
