FROM asciidoctor/docker-asciidoctor:1.103.0@sha256:a034dd14fd9d4abbb1a63042a165502b53d15d66635c70f6e35d549d2e9e27a2 AS asciidoc
WORKDIR /src/curriculum
COPY ./asciidoc ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.24.10@sha256:83bb2324dd6cc2b9ba9e0182e30b79daaaae223216b3c9774d9e08a2f9a443ba AS minifier
WORKDIR /src/curriculum
COPY --from=asciidoc /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done
RUN for ext in "css" "js" "html" "mp4" "png" "webp" "webm" "woff2"; do find . -name "*.$ext" -exec gzip -9k {} \;; done

FROM nginxinc/nginx-unprivileged:1.29.5-alpine-slim@sha256:800307aaf07c143f5d90aa9d4269cc1971dcfe5aee7cabd11579ac4c6bcf198f AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=asciidoc /src/curriculum/curriculum.pdf ./
COPY ./www ./