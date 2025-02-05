#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
bundle install

RAILS_ENV=production bundle exec rake assets:precompile

bundle exec rake assets:clean
# bundle exec rake db:migrate
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:migrate:reset
bundle exec rails db:seed
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
