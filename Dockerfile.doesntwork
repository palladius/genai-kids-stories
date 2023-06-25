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

# Install `gcloud`
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-435.0.1-linux-x86_64.tar.gz
RUN ls -al *gz
RUN tar -xf google-cloud-cli-435.0.1-linux-x86_64.tar.gz
RUN ./google-cloud-sdk/install.sh --quiet
#root@16c3e0d96ff7:/usr/src/app#
ENV PATH=$PATH:$WORKDIR/google-cloud-sdk/bin/
#RUN export PATH=$PATH:./google-cloud-sdk/bin/
#CMD ["./your-daemon-or-script.rb"]

ENTRYPOINT ["bin/docker-entrypoint"]
