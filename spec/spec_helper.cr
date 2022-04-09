ENV["LUCKY_ENV"] = "test"
ENV["DEV_PORT"] = "3010"
require "spec"
require "spectator"
require "lucky_flow"
require "vcr"
require "../src/app"
require "./support/flows/base_flow"
require "./support/**"
require "../db/migrations/**"

# Add/modify files in spec/setup to start/configure programs or run hooks
#
# By default there are scripts for setting up and cleaning the database,
# configuring LuckyFlow, starting the app server, etc.
require "./setup/**"

include Carbon::Expectations
include Lucky::RequestExpectations
include LuckyFlow::Expectations

Avram::Migrator::Runner.new.ensure_migrated!
Avram::SchemaEnforcer.ensure_correct_column_mappings!
Habitat.raise_if_missing_settings!

app_server = AppServer.new

spawn do
  app_server.listen
end

Spectator.configure do |config|
  config.before_each do
    AppDatabase.truncate
    Carbon::DevAdapter.reset
    LuckyFlow::Server::INSTANCE.reset
  end

  # config.after_suite do
  #   LuckyFlow.shutdown
  #   app_server.close
  # end
end
