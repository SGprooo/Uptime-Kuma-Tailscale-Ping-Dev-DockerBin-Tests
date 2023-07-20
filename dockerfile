FROM louislam/uptime-kuma:pr-test AS pr-test-custom

ENV UPTIME_KUMA_GH_REPO=uptime-kuma
ENV UPTIME_KUMA_GH_BRANCH=feature/custom-flags-implementation
ENV UPTIME_KUMA_GH_USER=SGprooo

RUN git config --global user.email "no-reply@no-reply.com"
RUN git config --global user.name "PR Tester"
RUN mkdir /tmp/repo && git clone https://github.com/${UPTIME_KUMA_GH_USER}/${UPTIME_KUMA_GH_REPO}.git /tmp/repo

WORKDIR /tmp/repo

RUN git checkout ${UPTIME_KUMA_GH_BRANCH}
RUN npm ci

WORKDIR /app
RUN cp -r /tmp/repo/* /app

USER root

RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

RUN apt-get update && apt-get install -y ca-certificates iptables wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://pkgs.tailscale.com/stable/tailscale_1.44.0_amd64.tgz \
    && tar xzf 'tailscale_1.44.0_amd64.tgz' --strip-components=1

RUN cp /app/tailscale /usr/local/bin/tailscale \
    && cp /app/tailscaled /usr/local/bin/tailscaled

USER root

HEALTHCHECK --interval=60s --timeout=30s --start-period=180s --retries=5 CMD curl --fail http://localhost:3001/healthcheck || exit 1

CMD ["/bin/sh", "-c", "/usr/local/bin/tailscaled --state=/home/node/tailscale/tailscaled.state --socket=/home/node/tailscale/tailscaled.sock & npm run start-pr-test"]
