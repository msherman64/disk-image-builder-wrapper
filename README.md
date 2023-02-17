First, build or pull docker container

```
docker buildx build . -t dib_container
```

Then, invoke as:

```
docker run --rm \
    --privileged \
    --network host \
    -v dib_tmp:/opt/tmp \
    -v dib_output:/opt/image_output \
    dib_container
```
