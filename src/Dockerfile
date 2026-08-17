FROM asciidoctor/docker-asciidoctor:1.106.0@sha256:6266e05784c2d8ece9d9fe5e593b12c3beebebbc467135fd6f4a56269c93cea3 AS asciidoc
WORKDIR /src/curriculum
COPY ./asciidoc ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor trilemma.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.24.17@sha256:f3a9c5c91fad6b4e5b451a5076a9e2a8a8f6c51e9c93254c0eeeb2dda033e2e2 AS minifier
WORKDIR /src/curriculum
COPY --from=asciidoc /src/curriculum/curriculum.html ./
COPY --from=asciidoc /src/curriculum/trilemma.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done
RUN for ext in "css" "js" "html" "mp4" "png" "webp" "webm" "woff2"; do find . -name "*.$ext" -exec gzip -9k {} \;; done

FROM nginxinc/nginx-unprivileged:1.31.3-alpine-slim@sha256:d61d7ef52430df468e74ed6ee6e914429b80e20ba988e3176278a73165f876cf AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=minifier /src/curriculum/trilemma.html trilemma.html
COPY --from=asciidoc /src/curriculum/curriculum.pdf ./
COPY ./www ./