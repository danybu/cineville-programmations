# frozen_string_literal: true

namespace :lint do
  task run: :environment do
    error = ''
    begin
      sh 'bundle exec rubocop'
    rescue StandardError
      error += "\nThere where issues with ruby files, see the logs above."
    end
    begin
      sh 'bundle exec erblint --lint-all'
    rescue StandardError
      error += "\nThere where issues with erb files, see the logs above."
    end
    begin
      sh 'yarn lint:js --no-fix'
    rescue StandardError
      error += "\nThere where issues with JS files, see the logs above."
    end
    begin
      sh 'yarn lint:css'
    rescue StandardError
      error += "\nThere where issues with SCSS files, see the logs above."
    end
    abort(error) if error.length
  end

  task fix: :environment do
    error = ''
    begin
      sh 'bundle exec rubocop -A'
    rescue StandardError
      error += "\nThere where issues with ruby files, see the logs above."
    end
    begin
      sh 'bundle exec erblint --lint-all -a'
    rescue StandardError
      error += "\nThere where issues with erb files, see the logs above."
    end
    begin
      sh 'yarn lint:js'
    rescue StandardError
      error += "\nThere where issues with JS files, see the logs above."
    end
    begin
      sh 'yarn lint:css --fix'
    rescue StandardError
      error += "\nThere where issues with SCSS files, see the logs above."
    end
    abort(error) if error.length
  end
end
