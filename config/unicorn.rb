# -*- encoding : utf-8 -*-
# unicorn_rails -c /data/github/current/config/unicorn.rb -E production -D

rails_env = ENV['RAILS_ENV'] || 'production'

# 16 workers and 1 master
worker_processes Integer(ENV["UNICORN_CONCURRENCY"] || 2)

# Load rails+github.git into the master before forking workers
# for super-fast worker spawn times
preload_app true

# Restart any workers that haven't responded in 30 seconds
timeout 30

# Listen on a Unix data socket
#listen '/tmp/sockets/unicorn.sock' # , :backlog => 2048
listen ENV['PORT'] || 4000

# user `whoami`.strip

##
# REE

# http://www.rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end


before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = Rails.root.join('/tmp/pids/unicorn.pid.oldbin')
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end


after_fork do |server, worker|

  # http://www.stopdropandrew.com/2010/06/01/where-unicorns-go-to-die-watching-unicorn-workers-with-monit.html
  # might be a solution to monitor unicorn workers
  # ----
  # child_pid = server.config[:pid].sub('.pid', "_worker.#{worker.nr}.pid")
  # File.open(child_pid, "wb") {|f| f << Process.pid }
  # ----
  # there will be an own pid file for any worker in tmp/pids (unicorn_worker.0.pid, ...)
  # which could then be monitored by monit  (/etc/monit/monitrc)
  # ---
  # check process unicorn_worker_0
  # with pidfile /usr/experteer/www/roots/job_catalog/current/tmp/pids/unicorn_worker.0.pid
  # start program = "/bin/cat /dev/null"
  # stop program = "/etc/init.d/unicorn kill_worker 0"
  # if mem is greater than 300.0 MB for 1 cycles then stop
  # if cpu is greater than 80% for 3 cycles then stop
  # ---

  ##
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection

  ActiveRecord::Base.establish_connection
#  CHIMNEY.client.connect_to_server
  # Redis and Memcached would go here but their connections are established
  # on demand, so the master never opens a socket


  ##
  # Unicorn master is started as root, which is fine, but let's
  # drop the workers to git:git

#  begin
#    uid, gid = Process.euid, Process.egid
#    user, group = 'experteer', 'experteer'
#    target_uid = Etc.getpwnam(user).uid
#    target_gid = Etc.getgrnam(group).gid
#    worker.tmp.chown(target_uid, target_gid)
#    if uid != target_uid || gid != target_gid
#      Process.initgroups(user, target_gid)
#      Process::GID.change_privilege(target_gid)
#      Process::UID.change_privilege(target_uid)
#    end
#  rescue => e
#    if RAILS_ENV == 'development'
#      STDERR.puts "couldn't change user, oh well"
#    else
#      raise e
#    end
#  end
end
