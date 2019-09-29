FROM bitwalker/alpine-elixir-phoenix as builder

ENV MIX_ENV=prod

WORKDIR /app

COPY mix.* ./

RUN mix deps.get && mix deps.compile

COPY . .

RUN mix phx.digest
RUN mix release

# Runtime
FROM alpine:3.9

# We need bash and openssl for Phoenix
RUN apk upgrade --no-cache add git wget && \
    apk add --no-cache bash openssl postgresql-client

ENV MIX_ENV=prod \
    SHELL=/bin/bash

WORKDIR /app

COPY --from=builder /app/_build/prod/rel/student_manager ./

COPY entrypoint.sh .

# Run the Phoenix app
CMD ["./entrypoint.sh"]
