FROM asciidoctor/docker-asciidoctor:1.65.0@sha256:c68ea3c6906b851ba751c0bde4a94a3c5e716b8772618fb3704c15a6ee919e09 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc ; asciidoctor-pdf curriculum.adoc

FROM debian:12.4-slim@sha256:7802002798b0e351323ed2357ae6dc5a8c4d0a05a57e7f4d8f97136151d3d603 AS minifier
WORKDIR /src/curriculum
RUN apt-get update --yes
RUN apt-get install --yes --no-install-recommends minify=2.12.4-2
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \; -printf "gzip -9c %p > %p.gz\n" | sh; done

FROM nginxinc/nginx-unprivileged:1.25.3-alpine-slim@sha256:1732fb26b6098b17b6cd81e099fe886a19b9e82d59a0773ef69bda785aa26173 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./