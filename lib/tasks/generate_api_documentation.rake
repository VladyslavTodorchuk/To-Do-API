# lib/tasks/generate_api_documentation.rake
namespace :dox do
  desc 'Generate API documentation markdown'

  task :json, %i[version docs_path host] => :environment do |_, args|
    require 'rspec/core/rake_task'
    version = args[:version] || :v1

    RSpec::Core::RakeTask.new(:api_spec) do |t|
      t.pattern = "spec/controllers/api/#{version}"
      t.rspec_opts =
        "-f Dox::Formatter --tag dox --order defined --out spec/docs/#{version}/schemas/apispec.json"
    end

    Rake::Task['api_spec'].invoke
  end

  task :html, %i[version docs_path host] => :json do |_, args|
    version = args[:version] || :v1
    docs_path = args[:docs_path] || "api/#{version}/docs"

    `redoc-cli bundle -o public/#{docs_path}/documentation.html spec/docs/#{version}/schemas/apispec.json`
  end

  task :open, %i[version docs_path host] => :html do |_, args|
    version = args[:version] || :v1
    docs_path = args[:docs_path] || "api/#{version}/docs"

    `open public/#{docs_path}/documentation.html`
  end
end
