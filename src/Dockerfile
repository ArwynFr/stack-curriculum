FROM asciidoctor/docker-asciidoctor:1.86.0@sha256:c8d37412478126caadc04e8c683903c52a135009969a84a8e5bf4fcad0cbe899 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.23.3@sha256:9b83566ba0aa4b87ff7071904587e9d750c7647b1f36c481c6001b3e6b99be29 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.28.0-alpine-slim@sha256:72fd2701efcfdedf84819444bf8e8826e5dbc8754c988f916e962d2304019d51 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./