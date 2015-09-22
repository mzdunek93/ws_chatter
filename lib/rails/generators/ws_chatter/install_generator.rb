require 'rails/generators/active_record/migration'

module WsChatter
  class InstallGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration

    source_root File.expand_path("../templates", __FILE__)

    desc "Installs ws_chatter in the rails app"

    class_option :scope, type: :string, default: "user", desc: "Name of the (existing) model for users"
    class_option :status_column, type: :string, default: "online", desc: "Name of the status status_column for the user model"
    class_option :messages, type: :string, default: "message", desc: "Name of the messages model"

    def inject_ws_chatter
      if File.exist?(manifest)
        comment_prefix = File.extname(manifest) == ".coffee" ? "#" : "//"
        require_ws_chatter = "#{comment_prefix}= require ws_chatter\n"

        manifest_contents = File.read(manifest)

        if manifest_contents.include? 'require turbolinks'
          inject_into_file manifest, require_ws_chatter, after: "#{comment_prefix}= require turbolinks\n"
        elsif manifest_contents.include? 'require_tree'
          inject_into_file manifest, require_ws_chatter, before: "#{comment_prefix}= require_tree"
        end
      end
    end

    def copy_initializer
      template "ws_chatter.rb", "config/initializers/ws_chatter.rb"
    end

    def copy_users_migration
      migration_template "users_migration.rb", "db/migrate/add_#{status_column}_to_#{table_name}.rb"
    end

    def copy_messages_migration
      migration_template "messages_migration.rb", "db/migrate/create_#{messages_table}.rb"
    end

    def copy_messages_model
      template "message.rb", "app/models/#{messages}.rb"
    end

    private
      def scope
        @scope ||= options[:scope].underscore
      end

      def table_name
        @table_name ||= scope.pluralize
      end

      def model_name
        @model_name ||= scope.camelize
      end

      def status_column
        @status_column ||= options[:status_column].underscore
      end

      def messages
        @messages ||= options[:messages].underscore
      end

      def messages_table
        @messages_table ||= messages.pluralize
      end

      def messages_model
        @messages_model ||= messages.camelize
      end

      def manifest
        Dir[File.join(destination_root, "app/assets/javascripts/application.*")][0]
      end
  end
end
