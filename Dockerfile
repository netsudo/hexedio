#Dockerfile
FROM elixir:1.7.2
ENV DEBIAN_FRONTEND=noninteractive

# Install hex
RUN mix local.hex --force

# Install rebar
RUN mix local.rebar --force

# Install the Phoenix framework itself
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# Install NodeJS 10.x and the NPM:
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y -q nodejs

# set build ENV
ENV MIX_ENV=prod

# Set /app as workdir
RUN mkdir /app
ADD . /app
WORKDIR /app

# Install mix dependencies
COPY mix.exs mix.lock ./
COPY config ./
RUN mix deps.get --only prod
RUN mix deps.compile

COPY assets assets
RUN cd assets && yes | npm install
RUN cd assets && ./node_modules/.bin/brunch build --production
RUN mix phx.digest

#Set env variables
CMD ["env.sh"]
