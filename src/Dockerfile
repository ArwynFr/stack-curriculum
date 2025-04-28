FROM asciidoctor/docker-asciidoctor:1.85.0@sha256:7a2f8b8296612eaa0c39d00ade5d18d5263a04f55cad5d6a40604f7e0715b948 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.23.1@sha256:2e2091cc0558672d30c2cf095f9f4aff780e9d5f84df68d47a74407696820b74 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.28.0-alpine-slim@sha256:8c63f2de91b27df915c17374fd088c0e73c33fc83fe56ad4812c7be22dcb4765 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./