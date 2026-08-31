FROM asciidoctor/docker-asciidoctor:1.106.0@sha256:6266e05784c2d8ece9d9fe5e593b12c3beebebbc467135fd6f4a56269c93cea3 AS asciidoc
WORKDIR /src/curriculum
COPY ./asciidoc ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor curriculum_classique.adoc
RUN asciidoctor trilemma.adoc
RUN asciidoctor-pdf curriculum.adoc
RUN asciidoctor-pdf curriculum_classique.adoc

FROM tdewolff/minify:v2.24.17@sha256:f3a9c5c91fad6b4e5b451a5076a9e2a8a8f6c51e9c93254c0eeeb2dda033e2e2 AS minifier
WORKDIR /src/curriculum
COPY --from=asciidoc /src/curriculum/*.html .
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done
RUN for ext in "css" "js" "html" "mp4" "png" "webp" "webm" "woff2"; do find . -name "*.$ext" -exec gzip -9k {} \;; done

FROM nginxinc/nginx-unprivileged:1.31.4-alpine-slim@sha256:d668aa123a6ec3216ba5ae6b398ae8001d5e81d3142d3659e20354fd0c3c3125 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=minifier /src/curriculum/curriculum_classique.html curriculum_classique.html
COPY --from=minifier /src/curriculum/trilemma.html trilemma.html
COPY --from=asciidoc /src/curriculum/*.pdf .
COPY ./www ./