FROM asciidoctor/docker-asciidoctor:1.107.0@sha256:23c022800c00bd7b73fe4e3deca49c77500f0fb34035b131cfed3f835e8d9de9 AS asciidoc
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

FROM nginxinc/nginx-unprivileged:1.31.5-alpine-slim@sha256:c94666682d7ecbfa0a1767fbe882cd1d82509333d15716c765f42bbef0d3809f AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=minifier /src/curriculum/curriculum_classique.html curriculum_classique.html
COPY --from=minifier /src/curriculum/trilemma.html trilemma.html
COPY --from=asciidoc /src/curriculum/*.pdf .
COPY ./www ./