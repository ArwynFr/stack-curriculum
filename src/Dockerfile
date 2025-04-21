FROM asciidoctor/docker-asciidoctor:1.84.0@sha256:c4fe627f068dd615bed2c0cde0f409307742e25c1ed72bc5d4cf8ab5ee3c3fbc AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.23.1@sha256:2e2091cc0558672d30c2cf095f9f4aff780e9d5f84df68d47a74407696820b74 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.4-alpine-slim@sha256:e9796392bfbd5d97721c1d67fa1433cb2f5658a72b9b3ef6af3f63b00a4c273e AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./