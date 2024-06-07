FROM asciidoctor/docker-asciidoctor:1.72.0@sha256:45c014ba79a97efd1707ae379403c6d46c5ad628dd3c6311b7090acb4ef9bd58 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.33@sha256:493c26c52d55d43436ca9ea434f4d972f878006d7344c8e47a746accad9f461b AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.0-alpine-slim@sha256:282c547c5946a9cbcdfb4ef0c29e116f775179eac609ba520d9a6aa00aa0d77a AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./*.pdf ./