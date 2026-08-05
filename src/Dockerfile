FROM asciidoctor/docker-asciidoctor:1.106.0@sha256:6266e05784c2d8ece9d9fe5e593b12c3beebebbc467135fd6f4a56269c93cea3 AS asciidoc
WORKDIR /src/curriculum
COPY ./asciidoc ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor trilemma.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.24.15@sha256:e4dda200f163bfeb45bbaf99743b31e7af13e6a450c36c05e34c92e3586f6546 AS minifier
WORKDIR /src/curriculum
COPY --from=asciidoc /src/curriculum/curriculum.html ./
COPY --from=asciidoc /src/curriculum/trilemma.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done
RUN for ext in "css" "js" "html" "mp4" "png" "webp" "webm" "woff2"; do find . -name "*.$ext" -exec gzip -9k {} \;; done

FROM nginxinc/nginx-unprivileged:1.31.3-alpine-slim@sha256:98edb4ebb9aae4d8ff4bd2ea5edc9939cc2f7cd206a20644928ada32a657c052 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=minifier /src/curriculum/trilemma.html trilemma.html
COPY --from=asciidoc /src/curriculum/curriculum.pdf ./
COPY ./www ./