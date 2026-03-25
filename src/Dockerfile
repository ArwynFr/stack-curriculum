FROM asciidoctor/docker-asciidoctor:1.104.0@sha256:966d0fec668fc9b037a0375fbb6e299a15d59ff293b008f5fb1261df54e82ab9 AS asciidoc
WORKDIR /src/curriculum
COPY ./asciidoc ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.24.11@sha256:74923d2049c0e780aa1ff7d7244638fdc3f5b0a1411ea4fc9b2f326efc953063 AS minifier
WORKDIR /src/curriculum
COPY --from=asciidoc /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done
RUN for ext in "css" "js" "html" "mp4" "png" "webp" "webm" "woff2"; do find . -name "*.$ext" -exec gzip -9k {} \;; done

FROM nginxinc/nginx-unprivileged:1.29.5-alpine-slim@sha256:806f6d3e4bece5525e9b4d5086b5d7bf9149d3e6300174dded6fe64272cee99a AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=asciidoc /src/curriculum/curriculum.pdf ./
COPY ./www ./