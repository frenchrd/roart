require 'mechanize'

module Roart
  module ConnectionAdapters
    class MechanizeAdapter

      def initialize(config)
        @conf = config
      end

      def login(config)
        @conf.merge!(config)
        agent = Mechanize.new
	agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
        page = agent.get(@conf[:server])
        form = page.form('login')
        form.user = @conf[:user]
        form.pass = @conf[:pass]
        page = agent.submit form
	agent.cookie_jar.save_as(cookie_jar_path, :session => true)
        @agent = agent
      end

      def cookie_jar_path
	      ENV['HOME'] + "/.rt_cookies"
      end

      def load_agent_from_cookies
	      puts "Loading Agent From Cookies"
	      agent = Mechanize.new
	      agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
	      agent.cookie_jar.load(cookie_jar_path)
	      agent
      end

      def get(uri)
	puts "GET"
	@agent ||= load_agent_from_cookies
        @agent.get(uri).body
      end

      def post(uri, payload)
	@agent ||= load_agent_from_cookies
        @agent.post(uri, payload).body
      end

    end
  end
end
