require 'sendgrid_api'

describe SendgridAPI::Base do
  context "setting api_user" do
    before do
      SendgridAPI::Base.api_user = "john"
      SendgridAPI::Base.api_key = "1234"
    end
    it "should reveal api_user" do
      SendgridAPI::Base.api_user.should == "john"
    end
    it "should reveal api_key" do
      SendgridAPI::Base.api_key.should == "1234"
    end
  end
end
