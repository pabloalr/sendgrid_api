require 'sendgrid_api'

describe SendGridAPI::Base do
  context "setting api_user" do
    before do
      SendGridAPI::Base.api_user = "john"
      SendGridAPI::Base.api_key = "1234"
    end
    it "should reveal api_user" do
      SendGridAPI::Base.api_user.should == "john"
    end
    it "should reveal api_key" do
      SendGridAPI::Base.api_key.should == "1234"
    end
  end
end
