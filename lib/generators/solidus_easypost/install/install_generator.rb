# frozen_string_literal: true

module SolidusEasypost
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      class_option :auto_run_migrations, type: :boolean, default: false
      class_option :frontend, type: :string, default: 'starter'

      def copy_initializer
        template 'initializer.rb', 'config/initializers/solidus_easypost.rb'
      end

      def add_migrations
        run 'bin/rails railties:install:migrations FROM=solidus_easypost'
      end

      def add_javascripts
        empty_directory 'app/assets/javascripts'
        template 'po_number_toggle.js', 'app/assets/javascripts/po_number_toggle.js'
        append_file 'app/assets/javascripts/solidus_starter_frontend.js', "//= require po_number_toggle\n"
      end

      def add_shipping_info
        return if options[:frontend] != 'starter'

        insert_into_file "app/views/orders/_order_shipments.html.erb",
          "  <%= render 'orders/shared/shipping_label', order: order%> \n      ",
          before: '</li>'
        insert_into_file "app/views/cart_line_items/_product_submit.html.erb",
          "  <%= render 'products/serial_number_label', product: product %> \n      ",
          after: "<%= render 'cart_line_items/product_availability', product: product %>\n"
        insert_into_file "app/views/checkouts/steps/delivery_step/_shipping_methods.html.erb",
          "\n<%= render 'checkouts/steps/delivery_step/pickup_fields', form: form %>",
          after: "</ul>"
        insert_into_file "app/views/checkouts/steps/address_step/_address_inputs.html.erb",
          "\n    <%= render 'checkouts/steps/address_step/order_metadata_field', form: form %>",
          after: "organization\" %>\n    </div>"
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y',
                                                           'Y'].include?(ask('Would you like to run the migrations now? [Y/n]'))
        if run_migrations
          run 'bin/rails db:migrate'
        else
          puts 'Skipping bin/rails db:migrate, don\'t forget to run it!' # rubocop:disable Rails/Output
        end
      end
    end
  end
end
