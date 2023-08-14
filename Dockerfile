# Use an official Ruby runtime as the parent image
FROM ruby:2.6.5

# Set environment variables for bundler
ENV BUNDLE_PATH=/bundle \
    GEM_HOME=/bundle \
    BUNDLE_BIN=/bundle/bin \
    PATH=./bin:/bundle/bin:$PATH

# Update and install base dependencies (add any system dependencies the gem might require)
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Create and set the working directory
WORKDIR /usr/src/app

# Copy Gemfile and Gemfile.lock and install gems
COPY Gemfile* ./
COPY *.gemspec ./

# Copy the main application into the container
COPY . .

RUN bundle install
