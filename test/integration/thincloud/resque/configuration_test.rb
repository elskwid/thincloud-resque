require "minitest_helper"

module Thincloud
  module Resque

    describe "Configuration" do
      let(:config) { Dummy::Application.config.thincloud.resque }

      # defaults
      it { config.must_be_kind_of Thincloud::Resque::Configuration }
      it { config.redis_url.must_equal "unix:///tmp/redis.sock" }

      if RUBY_ENGINE == "ruby"
        it { config.redis_driver.must_equal "hiredis" }
      else
        it { config.redis_driver.must_equal "ruby" }
      end

      it { config.web_username.must_equal "thincloud-resque" }
      it { config.web_password.must_equal "thincloud-resque" }
      it { config.mailer.must_equal true }
      it { config.mailer_excluded_environments.must_equal [] }

      # changed in dummy app environments/test.rb
      it { config.redis_namespace.must_equal "dummy_app_namespace" }

      describe "with configure block" do
        before do
          Thincloud::Resque.configure do |c|
            c.web_username = "webuser"
            c.mailer = false
          end
        end

        it { config.web_username.must_equal "webuser" }
        it { config.mailer.must_equal false }
      end
    end

  end
end
