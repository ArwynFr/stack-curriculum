FROM asciidoctor/docker-asciidoctor:1.69.0@sha256:8936b238f302216ed7c70f7a2d505a811d792820c0c29a479bc31cf9a9cefaf8 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.20 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.25.5-alpine-slim@sha256:5f0b566c0a525dcf56e85fcff490570fd029dbb589602eac7ccbaaf38f2a7367 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./*.pdf ./