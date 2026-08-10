FROM asciidoctor/docker-asciidoctor:1.106.0@sha256:6266e05784c2d8ece9d9fe5e593b12c3beebebbc467135fd6f4a56269c93cea3 AS asciidoc
WORKDIR /src/curriculum
COPY ./asciidoc ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor trilemma.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.24.16@sha256:9666f3bd0b6c7ea756715270fd5be2c5ad008ceeace5801924b7db77f914e9f7 AS minifier
WORKDIR /src/curriculum
COPY --from=asciidoc /src/curriculum/curriculum.html ./
COPY --from=asciidoc /src/curriculum/trilemma.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done
RUN for ext in "css" "js" "html" "mp4" "png" "webp" "webm" "woff2"; do find . -name "*.$ext" -exec gzip -9k {} \;; done

FROM nginxinc/nginx-unprivileged:1.31.3-alpine-slim@sha256:ff4671e70f4f903721c5eacce1373d3e5d21b3d5f6fb03982154aabd084ed32e AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=minifier /src/curriculum/trilemma.html trilemma.html
COPY --from=asciidoc /src/curriculum/curriculum.pdf ./
COPY ./www ./