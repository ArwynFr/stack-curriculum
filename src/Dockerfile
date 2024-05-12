FROM asciidoctor/docker-asciidoctor:1.69.0@sha256:8936b238f302216ed7c70f7a2d505a811d792820c0c29a479bc31cf9a9cefaf8 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.21@sha256:821a58086f874034d1becd7700a1db17627f5a86a02e734f25c557436a036482 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.26.0-alpine-slim@sha256:7f62297d72551a9d3baac731435a5a4c36c73bdc711a9deecd0c7aff43eb7849 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./*.pdf ./