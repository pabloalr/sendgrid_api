require 'webmock/rspec'
require 'sendgrid'

describe Sendgrid::CustomerSubuser do
  before do
    Sendgrid::Base.api_user = "john"
    Sendgrid::Base.api_key = "1234"
  end
  context "initializing" do
    let(:user) { Sendgrid::CustomerSubuser.new "john" }
  end
  context ".create" do
    before do
      stub_request(:post, "www.example.com").with(:body => "abc").to_return(status: 404)
      Sendgrid::CustomerSubuser.create "sub1", "102030", "subuser@mailee.me"
    end
    it {true }
  end
end
