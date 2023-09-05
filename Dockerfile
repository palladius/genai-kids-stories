# [ricc] copied from https://fly.io/ruby-dispatch/rails-on-docker/
# [ricc] Added from https://github.com/nickjj/docker-rails-example/blob/main/Dockerfile once IO installed bootstrap
# [ricc] Added netcat to support Witse crazy idea of listening to port 8080 to let Cloud Run work also for bkg jobs where no 
#        port is spun up so the system appears dead to the CR pinging job :)
# Make sure it matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.0
FROM --platform=linux/amd64 ruby:$RUBY_VERSION

WORKDIR /rails

# if it fails it fails FIRST :)
# Note this is USELESS since the var is not passed. It would be better NOT to pass and have entrypoint create it :)
# Needs to be EMPTY for entrypoint to catch up
#RUN echo "$DANGEROUS_SA_JSON_VALUE" > /sa.json
RUN bash -c 'echo -en "$DANGEROUS_SA_JSON_VALUE" > /sa.json'
#RUN echo -en "$DANGEROUS_SA_JSON_VALUE" > /sa.json
# for debug
RUN ls -la /sa.json

# Install libvips for Active Storage preview support
# TODO ricc: test `google-cloud-cli` https://cloud.google.com/sdk/docs/install?hl=it#deb

# Added node.js and yarn on 8jul23 https://github.com/nickjj/docker-rails-example/blob/main/Dockerfile
RUN bash -c "set -o pipefail && apt-get update \
  && apt-get update -qq  \
  && apt-get install -y build-essential libvips direnv postgresql-client libvips-tools curl libpq-dev && \
  curl -sSL https://deb.nodesource.com/setup_18.x | bash - \
  && curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y --no-install-recommends nodejs yarn netcat \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man"

# Rails app lives here
#WORKDIR /app

# Set production environment
#RAILS_ENV="production"

ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_ENV="production" \
    BUNDLE_WITHOUT="development"

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY package.json *yarn* ./
RUN yarn install

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile --gemfile app/ lib/

#######################################################
# Installing gcloud (added by ric) from
# https://stackoverflow.com/questions/28372328/how-to-install-the-google-cloud-sdk-in-a-docker-image
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz
# Installing the package
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh
# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin
#######################################################

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
#
#RUN PROJECT_ID='useless-here' SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Service Account to make gcloud work (security issue!)
# Note this will fail unless you set up a SA appropriately

# works locally but not in the cloud
#RUN cp private/sa.json /sa.json

# Uses a dangerous ENV until i find a better way..
#RUN cp private-sa-autogenerated.json /sa.json
# This is useful locally, but in CRun is useless as I have sth better :)
# Probably this should stay in the docker run :)
#ENV APPLICATION_DEFAULT_CREDENTIALS=/sa.json
# Start the server by default, this can be overwritten at runtime
EXPOSE 8080

CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "8080"]
