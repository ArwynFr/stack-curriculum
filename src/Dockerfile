FROM asciidoctor/docker-asciidoctor:1.106.0@sha256:6266e05784c2d8ece9d9fe5e593b12c3beebebbc467135fd6f4a56269c93cea3 AS asciidoc
WORKDIR /src/curriculum
COPY ./asciidoc ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor trilemma.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.24.12@sha256:4984574ecedf6b3214d63389179a30ab70d535f7d67992fda916565286612d8b AS minifier
WORKDIR /src/curriculum
COPY --from=asciidoc /src/curriculum/curriculum.html ./
COPY --from=asciidoc /src/curriculum/trilemma.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done
RUN for ext in "css" "js" "html" "mp4" "png" "webp" "webm" "woff2"; do find . -name "*.$ext" -exec gzip -9k {} \;; done

FROM nginxinc/nginx-unprivileged:1.31.2-alpine-slim@sha256:8f92ff79b9e9039b1ec2e363a04ce89c95c30e3d0be545bf6263024f5c21a2a8 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=minifier /src/curriculum/trilemma.html trilemma.html
COPY --from=asciidoc /src/curriculum/curriculum.pdf ./
COPY ./www ./