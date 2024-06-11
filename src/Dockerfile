FROM asciidoctor/docker-asciidoctor:1.72.0@sha256:45c014ba79a97efd1707ae379403c6d46c5ad628dd3c6311b7090acb4ef9bd58 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.34@sha256:e0258f91b41d07609f0746e8e8117868a6da63de51afcc23f5e9eedfec72acb3 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.0-alpine-slim@sha256:0e78e8e98317a026210ca388234d4b2195adf2bc756f8ff932d87de607fd9ef1 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./*.pdf ./