FROM asciidoctor/docker-asciidoctor:1.98.0@sha256:f7a1bb9317c511af033e51ad181e32e4b8c3ab5a0dbb2426a215fc7bf6c7bec9 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.24.4@sha256:9e3ddf38e66181f6e966723507dbbff5dfc592e833066fd6e12e40d5d9de78d5 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.29.2-alpine-slim@sha256:947101c7bb9ccc54b5197f0918a9023e24df9ac64f4ae3faae8500599bb1e92a AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./