## Dockerization from M1

According to https://beebom.com/how-fix-exec-user-process-caused-exec-format-error-linux/ :

`docker buildx build --platform=linux/amd64 -t <image_name>:<version>-amd64 .`

Then update your Docker file’s “FROM” statement using this syntax:

`FROM --platform=linux/amd64 <base_image>:<version>`

Not sure its that easy but.. happy to try someday.