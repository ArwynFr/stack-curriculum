FROM asciidoctor/docker-asciidoctor:1.102.0@sha256:94027c29c7695780fd9990f9620cad93f820403678f7b2b6bdf4a5f114beca65 AS asciidoc
WORKDIR /src/curriculum
COPY ./asciidoc ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.24.8@sha256:7d7ba575269b7700f3ac1635532882adfe04b293c98d8548715ca818e782bc0c AS minifier
WORKDIR /src/curriculum
COPY --from=asciidoc /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done
RUN for ext in "css" "js" "html" "mp4" "png" "webp" "webm" "woff2"; do find . -name "*.$ext" -exec gzip -9k {} \;; done

FROM nginxinc/nginx-unprivileged:1.29.5-alpine-slim@sha256:159b51f8db2b96e768edab28fab7350f946416333b2ec8d2b10b8009695dfc47 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=asciidoc /src/curriculum/curriculum.pdf ./
COPY ./www ./