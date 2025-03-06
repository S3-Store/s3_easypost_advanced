# frozen_string_literal: true

require 'spree/core'
require 'solidus_easypost'

module SolidusEasypost
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_easypost'

    # Use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'solidus_easypost.pub_sub' do |app|
      unless SolidusSupport::LegacyEventCompat.using_legacy?
        app.reloader.to_prepare do
          ::Spree::Bus.register(:'solidus_easypost.tracker.updated')
        end
      end
    end
  end
end
