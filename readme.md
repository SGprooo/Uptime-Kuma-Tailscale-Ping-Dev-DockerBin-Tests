# Uptime-Kuma with Tailscale Integration Docker Image

This Uptime Kuma Docker image extends `louislam/uptime-kuma:pr-test` by including `Tailscale ping` as a new feature from branch `SGprooo:feature/custom-flags-implementation` image with the Tailscale binary added, currently a preview of the `tailscale ping` monitor type in action.

## Building

```
docker build -t uptime-kuma-dev-modified .
```
## Running 

```
docker run --rm -it -p 3000:3000 -p 3001:3001 --device /dev/net/tun:/dev/net/tun --cap-add=NET_ADMIN -e UPTIME_KUMA_GH_REPO=SGprooo:feature/custom-flags-implementation uptime-kuma-dev-modified
```
### Note: remove "-rm" if you want to keep the container data persistent.

## Authenticating with Tailscale
After starting the Docker container, you need to authenticate with Tailscale manually. Run `tailscale up` inside the Docker container to authenticate.


