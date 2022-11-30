# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, "verleng"
set :branch, "main"
set :deploy_to, "/home/matthew/#{fetch :application}"
set :keep_releases, 5
set :repo_url, "git@github.com:matt17r/verleng.git"

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", ".bundle", "public/system", "public/uploads"
