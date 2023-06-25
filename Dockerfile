# [ricc] copied from https://fly.io/ruby-dispatch/rails-on-docker/

# Make sure it matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.0
FROM ruby:$RUBY_VERSION

# if it fails it fails FIRST :)
#RUN bin/prep-dockerfile.sh
RUN echo "$DANGEROUS_SA_JSON_VALUE" > private-sa-autogenerated.json
RUN ls -la private-sa-autogenerated.json

# Install libvips for Active Storage preview support
RUN apt-get update -qq && \
    apt-get install -y build-essential libvips direnv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# Rails app lives here
WORKDIR /rails
#WORKDIR /app

# Set production environment
#RAILS_ENV="production"

ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_ENV="dev-on-gcp" \
    BUNDLE_WITHOUT="development"

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

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
RUN cp private-sa-autogenerated.json /sa.json
# This is useful locally, but in CRun is useless as I have sth better :)
# Probably this should stay in the docker run :)
#ENV APPLICATION_DEFAULT_CREDENTIALS=/sa.json
# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
