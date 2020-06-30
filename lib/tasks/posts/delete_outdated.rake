# frozen_string_literal: true

namespace :posts do
  desc 'Deletes outdated restaurant posts.'
  task delete_outdated: :environment do
    Posts::DeleteOutdatedWorker.perform_async
  end
end
