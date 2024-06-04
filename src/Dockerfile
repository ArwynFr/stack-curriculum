FROM asciidoctor/docker-asciidoctor:1.71.0@sha256:0c692ca0f9bcdd8a0b721a74391d5811d3bed4e118f4e50b8362549046c223c2 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.32@sha256:450b7e0ede28e085787fe4c798a85480238d3990b1c73e3bb78c7579d94fb3aa AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.0-alpine-slim@sha256:282c547c5946a9cbcdfb4ef0c29e116f775179eac609ba520d9a6aa00aa0d77a AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./*.pdf ./