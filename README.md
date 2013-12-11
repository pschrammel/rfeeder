rfeeder
=======

WIP (should be a feed reader with multiple user support, tags, search , ...)

== Install ==

 bundle install
 bundle exec rake db:migrate
 bunlde exec rake db:enums:load

after creating a feed

 bundle exec rake rfeeder:import

