# PrivateRouter Reverse Proxy Docker Container
This repository contains all you need to build the FRP Client container used by [PrivateRouter's Reverse Proxy Server](https://privaterouter.com/reverse-proxy/).

It is possible to use this with any FRP Server should you choose.

## Building
This container builds for multiple architectures so you will need to use Docker Buildx and run this command to configure it: `docker buildx create --name cross_build --use`

The build script handles all of the heavy lifting for you.

```
* ~~ Any of these flags may be combined ~~
* 'build.sh -n' sets no cache so it always pulls latest containers
* 'build.sh -c' sets crossbuilding between all supported Linux platforms
* 'build.sh -l' sets current build as latest
* 'build.sh -p' force pulls latest of every Docker image
* 'build.sh -u' Uploads the image to the registry
* 'build.sh -b' Keeps a copy of the build log
* 'build.sh -r docker-registry' Sets a docker registry
* 'build.sh -s source.sh' sets a script to source variables from
* 'build.sh -i name-of-image' overwrites the pre-set image name used for building
* 'build.sh -a build-archs' overwrites the pre-set archictectures used for building
* 'build.sh -f Dockerfile' OPTIONAL - allows you to point this script to a different Dockerfile
* 'build.sh -v version' OPTIONAL - allows you to manually set a version for this container
```

If you want to build it just for you locally, you can just run (for crossbuilding this as the "latest" tag): 
`./build.sh -c -l` 


If you are wanting to upload it to your own docker repo then you can use: 
`./build.sh -c -r YOUR_DOCKER_USERNAME -i YOUR_CONTAINER_NAME -l`

## TLDR:
1) Clone the repo
2) `docker buildx create --name cross_build --use`
3) `./build.sh -c -l`
