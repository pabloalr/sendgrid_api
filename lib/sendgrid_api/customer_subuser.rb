require 'rest_client'
require 'json'

module SendGridAPI
  class CustomerSubuser
    attr_reader :username

    ### params for creating a new user
    # username , password, password_confirmation, email, first_name, last_name,
    # address, city, state, zip, country, phone, website, company
    # http://sendgrid.com/docs/API_Reference/Customer_Subuser_API/subusers.html
    def self.create params
      post "https://api.sendgrid.com/apiv2/customer.add.json", params
    end

    ### params for updating a user
    # user is mandatory
    # then you can update all the fields of create method
    def update params
      post "https://api.sendgrid.com/apiv2/customer.profile.json", params.merge(task: 'set')
    end

    def initialize username
      @username = username
    end

    def enable
      post "https://api.sendgrid.com/apiv2/customer.enable.json"
    end

    def disable
      post "https://api.sendgrid.com/apiv2/customer.disable.json"
    end

    def enable_website_access
      post "https://api.sendgrid.com/apiv2/customer.website_enable.json"
    end

    def disable_website_access
      post "https://api.sendgrid.com/apiv2/customer.website_disable.json"
    end

    def assign_ips ips
      post "https://api.sendgrid.com/apiv2/customer.sendip.json", task: 'append', set: 'specify', ip: ips.to_a
    end

    def activate_app name
      post "https://api.sendgrid.com/apiv2/customer.apps.json", task: 'activate', name: name
    end

    def deactivate_app name
      post "https://api.sendgrid.com/apiv2/customer.apps.json", task: 'deactivate', name: name
    end

    def customize_app name, params
      post "https://sendgrid.com/apiv2/customer.apps.json", {task: 'setup', name: name}.merge(params)
    end


    protected

    def post address, params={}
      CustomerSubuser.req address, params.merge(user: username), :post, CustomerSubuser.credentials
    end

    def get address, params
    end

    def self.post address, params
      req address, params, :post, credentials
    end

    def self.req address, params, method, credentials
      req = (method == :post ? RestClient.post(address, params.merge(credentials)) : RestClient.get(address, params.merge(credentials)) )
      r = JSON.parse req
      if r["message"] == "success"
        return r
      elsif r["errors"]
        raise r["errors"].inspect
      elsif r["error"]
        raise r["error"].inspect
      end
    end

    def self.credentials
      raise "Please setup SendGridAPI::Base.api_user" unless SendGridAPI::Base.api_user
      raise "Please setup SendGridAPI::Base.api_key" unless SendGridAPI::Base.api_key
      {api_user: SendGridAPI::Base.api_user, api_key: SendGridAPI::Base.api_key}
    end

  end
end
