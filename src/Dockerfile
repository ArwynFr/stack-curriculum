FROM asciidoctor/docker-asciidoctor:1.91.0@sha256:ce039dfbca63bd41bcb7de2ddb8135cad0bd5ac30a7015dec116f8ef9e71837a AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.23.9@sha256:f9cc21b37957351b6f38ec07cb2e8cd2ac0c85ed53bad28120acea2fe02e3348 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.29.0-alpine-slim@sha256:77b01fcb2a887ffdffafad6d050f8df3c2810041a31955fddb0fb45f7fcf52be AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./