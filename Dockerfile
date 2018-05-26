FROM elixir:1.6.5
ARG DEBIAN_FRONTEND=noninteractive

# Install hex
RUN mix local.hex --force

# Install rebar
RUN mix local.rebar --force

# Install the Phoenix framework itself
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# Install NodeJS 10.x and the NPM. Also inotify-tools for live reload:
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y -q nodejs inotify-tools

# Set /app as workdir
RUN mkdir /app
ADD . /app
WORKDIR /app
