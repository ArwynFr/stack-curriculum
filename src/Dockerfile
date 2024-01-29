FROM asciidoctor/docker-asciidoctor:1.62.0@sha256:8f2a9563f13970c6ab01406acca52697128da4edc9a03267fd06661c3612a647 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc ; asciidoctor-pdf curriculum.adoc

FROM debian:12.4-slim@sha256:f4a83aa865a2b4a064ff142aa91c713180df9fcb86ce676b5de2981029379c37 AS minifier
WORKDIR /src/curriculum
RUN apt-get update --yes
RUN apt-get install --yes --no-install-recommends minify=2.12.4-2
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \; -printf "gzip -9c %p > %p.gz\n" | sh; done

FROM nginxinc/nginx-unprivileged:1.25.3-alpine-slim@sha256:5758611372e1b389025e349987fb63aebb54ff35c15f92384b8ae184693827c3 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./