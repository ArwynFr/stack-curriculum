FROM asciidoctor/docker-asciidoctor:1.96.0@sha256:ebeb89d57bc7642aea2bceade509e5128dce3c3cea1841a7fe020a1496795c2b AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.24.4@sha256:9e3ddf38e66181f6e966723507dbbff5dfc592e833066fd6e12e40d5d9de78d5 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.29.2-alpine-slim@sha256:7e5a9a620fbf78f0ad3565a1e5527d5d4509381d16b08501b656cf5251b339ce AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./