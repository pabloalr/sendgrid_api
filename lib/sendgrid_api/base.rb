module SendGridAPI
  class Base
    def self.api_user= value
      @@api_user = value
    end
    def self.api_user
      @@api_user
    end
    def self.api_key= value
      @@api_key = value
    end

    # TODO think if is there some way of making it private for outside of the
    # module
    def self.api_key
      @@api_key
    end
  end
end
