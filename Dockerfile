FROM elixir:1.13.3-alpine

RUN apk add --no-cache build-base npm git python3 inotify-tools bash

ENV FOOD_ORDER_PATH=/var/www/food_order
WORKDIR $FOOD_ORDER_PATH

RUN mix local.hex --force && \
    mix local.rebar --force
COPY mix.* ./
RUN mix do deps.get, deps.compile

COPY . $FOOD_ORDER_PATH

EXPOSE 4000
