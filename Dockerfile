FROM alpine:3.23

# root certificates, used when the server downloads over https (reverse proxy client)
RUN apk add --no-cache ca-certificates

WORKDIR /tms

# Setup server
COPY ./target/x86_64-unknown-linux-musl/release/tms_server .
COPY ./log_config ./log_config
COPY ./tms_client/build/web ./tms_client/build/web

RUN chmod +x tms_server

EXPOSE 8080

ENTRYPOINT [ "./tms_server" ]