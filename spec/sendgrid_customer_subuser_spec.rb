require 'webmock/rspec'
require 'sendgrid_api'

describe SendgridAPI::CustomerSubuser do
  let(:credentials) {{api_user: "john", api_key: "1234"}}
  let(:success) {"{\"message\": \"success\"}"}
  let(:success_json) { JSON.parse success }
  let(:error) {"{\"message\": \"error\",\"errors\": [\"...error messages...\"]}"}
  let(:error_json) { JSON.parse error }
  let(:user) { SendgridAPI::CustomerSubuser.new("mailee-john") }
  before do
    SendgridAPI::Base.api_user = credentials[:api_user]
    SendgridAPI::Base.api_key = credentials[:api_key]
  end

  describe ".create" do
    let(:params) {{username: "adam" , password: "102030", password_confirmation: "102030", email: "adam@gmail.com", first_name: "Adam", last_name: "Something", address: "1 Infinite Loop", city: "Cupertino", state: "CA", zip: "95014", country: "USA", phone: "+1 2313212312", website: "adam.com", company: "Adam Co"}}
    let(:address) { "https://api.sendgrid.com/apiv2/customer.add.json" }
    context "with everything allright" do
      before do
        stub_request(:post, address).with(body: params.merge(credentials)).to_return(body: success)
      end
      it "should have success" do
        expect(SendgridAPI::CustomerSubuser.create params).to eql(success_json)
      end
    end
    context "with a missing parameter" do
      let(:new_params) { params.merge(credentials) }
      before do
        new_params.delete(:username)
        stub_request(:post, address).with(body: new_params).to_return(body: error)
      end
      it "should raise error" do
        expect {SendgridAPI::CustomerSubuser.create new_params}.to raise_error(RuntimeError)
      end
    end
    context "could not resolve domain name" do
      let(:socket_error) { SocketError.new "getaddrinfo: nodename nor servname provided, or not known" }
      before do
        stub_request(:post, address).with(body: params.merge(credentials)).to_raise(socket_error)
      end
      it "should raise error" do
        expect {SendgridAPI::CustomerSubuser.create params}.to raise_error(socket_error)
      end
    end
    context "connection refused" do
      let(:connection_refused) { Errno::ECONNREFUSED.new "connect(2)" }
      before do
        stub_request(:post, address).with(body: params.merge(credentials)).to_raise(connection_refused)
      end
      it "should raise error" do
        expect {SendgridAPI::CustomerSubuser.create params}.to raise_error(connection_refused)
      end
    end
    context "timeout error" do
      let(:timeout_error) { Timeout::Error.new "something" }
      before do
        stub_request(:post, address).with(body: params.merge(credentials)).to_raise(timeout_error)
      end
      it "should raise error" do
        expect {SendgridAPI::CustomerSubuser.create params}.to raise_error
      end
    end
  end

  describe ".new" do
    it "should record its username" do
      expect(SendgridAPI::CustomerSubuser.new("mailee-john").username).to eql("mailee-john")
    end
  end

  context "instance methods" do
    let(:params) { {user: "mailee-john"}.merge(credentials) }

    describe "#update" do
      let(:params) {{email: "adam@adamco.com", task: "set"}.merge(credentials)}
      let(:address) { "https://api.sendgrid.com/apiv2/customer.profile.json" }
      context "with everything allright" do
        before do
          stub_request(:post, address).with(body: params.merge(user: 'mailee-john')).to_return(body: success)
        end
        it "should have success" do
          expect(user.update params).to eql(success_json)
        end
      end
    end

    describe "#enable" do
      let(:address) { "https://api.sendgrid.com/apiv2/customer.enable.json" }
      before { stub_request(:post, address).with(body: params).to_return(body: success)}
      it "should enable the account" do
        expect(user.enable).to eql(success_json)
      end
    end

    describe "#disable" do
      let(:address) { "https://api.sendgrid.com/apiv2/customer.disable.json" }
      before { stub_request(:post, address).with(body: params).to_return(body: success)}
      it "should disable the account" do
        expect(user.disable).to eql(success_json)
      end
    end

    describe "#enable_website_access" do
      let(:address) { "https://api.sendgrid.com/apiv2/customer.website_enable.json" }
      before { stub_request(:post, address).with(body: params).to_return(body: success)}
      it "should enable website access for the account" do
        expect(user.enable_website_access).to eql(success_json)
      end
    end

    describe "#disable_website_access" do
      let(:address) { "https://api.sendgrid.com/apiv2/customer.website_disable.json" }
      before { stub_request(:post, address).with(body: params).to_return(body: success)}
      it "should disable access for the account" do
        expect(user.disable_website_access).to eql(success_json)
      end
    end

    describe "#assign_ips" do
      let(:address) { "https://api.sendgrid.com/apiv2/customer.sendip.json" }
      before { stub_request(:post, address).with(body: params.merge({task: 'append', set:'specify', ip: ['1.1.1.1']})).to_return(body: success)}
      it "should enable the account" do
        expect(user.assign_ips(['1.1.1.1'])).to eql(success_json)
      end
    end

    describe "#activate_app" do
      let(:address) { "https://api.sendgrid.com/apiv2/customer.apps.json" }
      before { stub_request(:post, address).with(body: params.merge({task: 'activate', name: 'eventnotify'})).to_return(body: success)}
      it "should enable the app" do
        expect(user.activate_app('eventnotify')).to eql(success_json)
      end
    end

    describe "#deactivate_app" do
      let(:address) { "https://api.sendgrid.com/apiv2/customer.apps.json" }
      before { stub_request(:post, address).with(body: params.merge({task: 'deactivate', name: 'eventnotify'})).to_return(body: success)}
      it "should enable the app" do
        expect(user.deactivate_app('eventnotify')).to eql(success_json)
      end
    end

    describe "#customize_app" do
      let(:address) { "https://api.sendgrid.com/apiv2/customer.apps.json" }
      let(:custom_info) {{dropped: "1", bounce: "1", spamreport: "1", url: "https://event-api.herokuapp.com", batch: "1", version: "3" }}
      before {stub_request(:post, "https://sendgrid.com/apiv2/customer.apps.json").with(:body => {"api_key"=>"1234", "api_user"=>"john", "batch"=>"1", "bounce"=>"1", "dropped"=>"1", "name"=>"eventnotify", "spamreport"=>"1", "task"=>"setup", "url"=>"https://event-api.herokuapp.com", "user"=>"mailee-john", "version"=>"3"}).to_return(body: success)}
      it "should enable the app" do
        expect(user.customize_app('eventnotify', custom_info)).to eql(success_json)
      end
    end
  end

end
