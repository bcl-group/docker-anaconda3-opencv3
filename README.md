# ubuntu-anaconda3-opencv3

An environment of anaconda3+opencv3

## About

You cannot view movies by opencv3 on Linux, if you install opencv3 by
`conda install -c menpo opencv3`.
In this Docker image, we avoided this problem by rebuilding opencv3 after installing ffmpeg.

## Includes

- opencv3
- scikit-learn
- Japanese environment

## miscs...

- Default user name on Docker: jupyter (UCI=1000,GID=1000)
- A script `docker-run.sh` to start the docker image is prepared.
