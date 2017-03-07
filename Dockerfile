# Base image from Ruby docker hub
FROM ruby:2.3.1

# Install essential linux packages
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Define where the application will live inside the image
ENV RAILS_ROOT /var/www/app

# Create application home. App server will need the pids dir
RUN mkdir -p $RAILS_ROOT/tmp/pids

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# Install bundler
RUN gem install bundler

# Use the Gemfiles as Docker cache markers and run bundle install before
# copy over app src
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

# Finish establishing our Rails enviornment
RUN bundle install --deployment

# Copy the Rails application into the image working directory
COPY . .

# Precompile assets for production environment
RUN RAILS_ENV=production bin/rails assets:precompile

# Run the Rails server in production mode and listen to port 3000
CMD RAILS_ENV=production rails server --port 3000
