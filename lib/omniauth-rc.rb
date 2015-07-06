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
      uid { raw_info["id"] }

      # If you want any data available in the app, it needs to be set here.
      #
      # raw_info contains the following information as of 2015-07-06:
      # #<OmniAuth::AuthHash
      #   batch=#<OmniAuth::AuthHash end_date="2015-07-02" id=18 name="Spring 2, 2015" start_date="2015-03-30">
      #   batch_id=18
      #   bio="I'm originally from San Francisco (and the surrounding area), but I've spent the last year or so living in London. I've previously worked at Google, iFixit, Adode and Punchd. \r\n\r\nBeyond that, I'm a contributor to Fog (a ruby library for managing the cloud), and spend a lot of time thinking about managing distributed systems and deploying code. I like consuming and creating \"Art\" (painting, photography, music, books, old, new, street, whatever) and enjoy a good game of D&D.\r\n\r\nI love a good cup of coffee or pint of beer, and a nice long walk to find either.\r\n\r\nI'm currently unemployed and considering jobs in New York, Seattle and the Bay Area."
      #   email="nat@natwelch.com"
      #   first_name="Nat"
      #   github="icco"
      #   has_photo=true
      #   id=1150
      #   image="https://d29xw0ra2h4o4u.cloudfront.net/assets/people/nat_welch_150-6e067d098ed9324e3627df919f656a89.jpg"
      #   is_faculty=false
      #   is_hacker_schooler=true
      #   job=nil
      #   last_name="Welch"
      #   links=[#<OmniAuth::AuthHash title="natwelch.com" url="http://natwelch.com">]
      #   middle_name=nil
      #   phone_number="+17077998675"
      #   projects=[#<OmniAuth::AuthHash description="My blog for interesting links and daily posts about RC. Hand coded in go. https://github.com/icco/natnatnat" title="Nat? Nat. Nat!" url="https://writing.natwelch.com/">, #<OmniAuth::AuthHash description="Hyperspace is a multiplayer version of Asteroids. https://github.com/kenpratt/hyperspace" title="Hyperspace" url="http://playhyperspace.com/">, #<OmniAuth::AuthHash description="A p2p audio streaming app built entirely in javascript for hosting silent dance parties. https://github.com/pselle/shhparty" title="ShhParty" url="http://shhparty.herokuapp.com/">, #<OmniAuth::AuthHash description="A ruby site for tracking how much I work on personal projects. https://github.com/icco/code.natwelch.com" title="Nat's Code" url="http://code.natwelch.com/">]
      #   skills=["java", "ruby", "Linux", "git", "php", "golang", "distributed systems", "google cloud", "python"]
      #   twitter="icco">
      info do
        {
          name: "#{raw_info["first_name"]} #{raw_info["last_name"]}",
          email: raw_info["email"],
          image: raw_info["image"],
          batch: raw_info["batch"],
          bio: raw_info["bio"],
          skills: raw_info["skills"],
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
