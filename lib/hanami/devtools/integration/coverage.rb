# frozen_string_literal: true

module RSpec
  module Support
    # Code coverage support
    #
    # @since 0.2.0
    module Coverage
      def self.configure!
        return unless enabled?

        require "simplecov"
        require "coveralls"

        configure_simplecov!
      end

      def self.cover_as!(suite_name)
        return unless enabled?

        SimpleCov.command_name(suite_name)
      end

      private_class_method

      def self.ci?
        !ENV["TRAVIS"].nil?
      end

      def self.enabled?
        # !ENV['COVERAGE'].nil?
        false
      end

      def self.configure_simplecov!
        SimpleCov.formatter = Coveralls::SimpleCov::Formatter if ci?

        SimpleCov.start do
          add_filter "spec/"
          add_filter "script/"
          add_filter "tmp/"
          add_filter "vendor/"
        end
      end
    end
  end
end

RSpec::Support::Coverage.configure!

RSpec.configure do |config|
  config.before do |example|
    RSpec::Support::Coverage.cover_as!(example.file_path)
  end
end
