module Sendgrid
  class CustomerSubuser
    attr_reader :username

    def self.create username, password, email
    end

    def initialize username
      @username = username
    end

    protected

    def post address, params
    end

    def get address, params
    end

  end
end
