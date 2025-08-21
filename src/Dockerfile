FROM asciidoctor/docker-asciidoctor:1.92.0@sha256:0dfe230f2dc7dd49534320c3f008c16c40f1e78e5ed564642bb338a0bd413f43 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.24.0@sha256:8ff71f30f82cbc9ec5366fe33253563de1a83376903c8c8989fe234a7556d279 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.29.1-alpine-slim@sha256:08d9abede1bbaf8d76431e3899cacb5624fb066b0595f8ec9b078b8aff951fb9 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./