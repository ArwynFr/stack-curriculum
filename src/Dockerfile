FROM asciidoctor/docker-asciidoctor:1.86.0@sha256:c8d37412478126caadc04e8c683903c52a135009969a84a8e5bf4fcad0cbe899 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.23.2@sha256:584f7c921fffacd69dc75364ef8b3c89997eb944c570ff59db3b8b59ad48b06b AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.28.0-alpine-slim@sha256:8c63f2de91b27df915c17374fd088c0e73c33fc83fe56ad4812c7be22dcb4765 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./