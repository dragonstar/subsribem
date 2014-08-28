# desc "Explaining what the task does"
# task :subscribem do
#   # Task goes here
# end

require 'subscribem/braintree_plan_fetcher'

namespace :subscribem do
  desc "Import plans from Braintree"
  task :import_plans => :environment do
    BraintreePlanFetcher.store_locally
  end


end

