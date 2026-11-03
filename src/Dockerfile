FROM asciidoctor/docker-asciidoctor:1.108.1@sha256:0b75447cc4b616e18746a77cd2739ec4eedc0d2fb3d7e6db121a9dd2dd9dc078 AS asciidoc
WORKDIR /src/curriculum
COPY ./asciidoc ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor curriculum_classique.adoc
RUN asciidoctor trilemma.adoc
RUN asciidoctor-pdf curriculum.adoc
RUN asciidoctor-pdf curriculum_classique.adoc

FROM tdewolff/minify:v2.24.25@sha256:c951803e4bcaeebb802f29a299f435283ace215102227e45e7961ab4fe772ae5 AS minifier
WORKDIR /src/curriculum
COPY --from=asciidoc /src/curriculum/*.html .
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done
RUN for ext in "css" "js" "html" "mp4" "png" "webp" "webm" "woff2"; do find . -name "*.$ext" -exec gzip -9k {} \;; done

FROM nginxinc/nginx-unprivileged:1.31.7-alpine-slim@sha256:a8cb0f33d51fa107c96fd2bd3a71aaf564ec131e9d2bdf8700944f0ed8b170d7 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=minifier /src/curriculum/curriculum_classique.html curriculum_classique.html
COPY --from=minifier /src/curriculum/trilemma.html trilemma.html
COPY --from=asciidoc /src/curriculum/*.pdf .
COPY ./www ./