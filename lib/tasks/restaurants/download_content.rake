# frozen_string_literal: true

namespace :restaurants do
  desc 'Downloads latest facebook restaurants posts.'
  task download_content: :environment do
    Restaurants::DownloadPostsWorker.perform_async
  end
end
