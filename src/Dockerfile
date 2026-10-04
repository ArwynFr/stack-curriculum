FROM asciidoctor/docker-asciidoctor:1.108.0@sha256:66041d57c25cec8b54cbf8b13141a83c3cb4768d41ccb3683cab28271c6775df AS asciidoc
WORKDIR /src/curriculum
COPY ./asciidoc ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor curriculum_classique.adoc
RUN asciidoctor trilemma.adoc
RUN asciidoctor-pdf curriculum.adoc
RUN asciidoctor-pdf curriculum_classique.adoc

FROM tdewolff/minify:v2.24.19@sha256:d8142550325e481deecd1c8b4a1b74dbd21f082016ccd48c731dec32bf204208 AS minifier
WORKDIR /src/curriculum
COPY --from=asciidoc /src/curriculum/*.html .
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done
RUN for ext in "css" "js" "html" "mp4" "png" "webp" "webm" "woff2"; do find . -name "*.$ext" -exec gzip -9k {} \;; done

FROM nginxinc/nginx-unprivileged:1.31.6-alpine-slim@sha256:c81a27f28bc2d9c2da8998444e653c7b85b9bbbaa92e44ef18d8920784e06507 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=minifier /src/curriculum/curriculum_classique.html curriculum_classique.html
COPY --from=minifier /src/curriculum/trilemma.html trilemma.html
COPY --from=asciidoc /src/curriculum/*.pdf .
COPY ./www ./