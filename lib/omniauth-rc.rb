require "omniauth-oauth2"

# Inspired by
#  * https://github.com/sursh/blaggregator/blob/master/home/oauth.py
#  * https://github.com/Shopify/omniauth-shopify-oauth2/blob/master/lib/omniauth/strategies/shopify.rb
module OmniAuth
  module Strategies
    class RecurseCenter < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "recurse_center"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        :site => "https://www.recurse.com",
        :authorize_url => "/oauth/authorize",
        :token_url => "/oauth/token",
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ raw_info["id"] }

      info do
        {
          name: "#{raw_info["first_name"]} #{raw_info["last_name"]}",
          email: raw_info["email"],
          image: raw_info["image"],
          batch: raw_info["batch"],
        }
      end

      extra do
        {
          "raw_info" => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get("/api/v1/people/me").parsed
      end

      def users
        []
      end

      def batches
        access_token.get("/api/v1/batches").parsed
      end
    end
  end
end
