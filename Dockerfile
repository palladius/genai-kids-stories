# 1 copied from ruiby official docker version
# 2. consider this: https://medium.com/simform-engineering/dockerize-your-rails-7-app-3223cc851129

ARG RUBY_VERSION=3.2.0
FROM ruby:$RUBY_VERSION

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# True PROD
# ENV RAILS_LOG_TO_STDOUT="1" \
#     RAILS_SERVE_STATIC_FILES="true" \
#     RAILS_ENV="production" \
#     BUNDLE_WITHOUT="development"

# Ricc semi prod (for now)
ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true"

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

#CMD ["./your-daemon-or-script.rb"]

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
