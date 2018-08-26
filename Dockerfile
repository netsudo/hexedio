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

# Set build ENV and ENV variables
ENV MIX_ENV=prod RECAPTCHA_PUBLIC_KEY="recaptcha_key" RECAPTCHA_PRIVATE_KEY="recaptcha_priv" SMTP_SERVER="server" SMTP_USERNAME="email_from" SMTP_PASSWORD="email_pass"

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
