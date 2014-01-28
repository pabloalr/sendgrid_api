require 'sendgrid'

describe Sendgrid::Base do
  context "setting api_user" do
    before do
      Sendgrid::Base.api_user = "john"
      Sendgrid::Base.api_key = "1234"
    end
    it "should reveal api_user" do
      Sendgrid::Base.api_user.should == "john"
    end
    it "should reveal api_key" do
      Sendgrid::Base.api_key.should == "1234"
    end
  end
end
