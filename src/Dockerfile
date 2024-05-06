FROM asciidoctor/docker-asciidoctor:1.69.0@sha256:8936b238f302216ed7c70f7a2d505a811d792820c0c29a479bc31cf9a9cefaf8 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.20@sha256:eb79a7f8ff8110c8eb3cc623ec6d60cfed668222411af5d8bb13c3478717abe2 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.26.0-alpine-slim@sha256:307d357c75f346ffaf359af4c093831499c179406f42170b69ffc9cf3ee3704b AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./*.pdf ./