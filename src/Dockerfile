FROM asciidoctor/docker-asciidoctor:1.83.0@sha256:8aff276f73e0bfb519e9cbdf6b8b6626c79369079d69efb86e669cbfe7aed2cc AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.22.2@sha256:2afa5f9261ebd9225ea0d7f74594f444999b6757db0707f1cb04ede3f17d1c84 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.4-alpine-slim@sha256:b2c6b4854a9bee724de2437b4030a18f213ef6801f1efbc8dad6bbe2c2fdb02c AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./