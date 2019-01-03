# frozen_string_literal: true

threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
threads threads_count, threads_count

port        ENV.fetch('PORT') { 5000 }

environment ENV.fetch('RAILS_ENV') { 'development' }

preload_app!

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
