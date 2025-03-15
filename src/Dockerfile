FROM asciidoctor/docker-asciidoctor:1.82.0@sha256:3aa285210a046dcbc2f04d248df8db58e7196873f1659727168e5cea20416e91 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.22.2@sha256:2afa5f9261ebd9225ea0d7f74594f444999b6757db0707f1cb04ede3f17d1c84 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.4-alpine-slim@sha256:66baf037eb69535e1e478658081d0b89c6af261a2e353d120da1a051765a9731 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./