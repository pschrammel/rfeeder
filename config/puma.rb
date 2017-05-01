threads_count = ENV.fetch("RAILS_MAX_THREADS") { 16 }.to_i
threads threads_count, threads_count
port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }

workers 1
#plugin :tmp_restart
