FROM asciidoctor/docker-asciidoctor:1.73.0@sha256:5efb700de9b3b825b5b4807d2f6c0783767a5cfdc6b260c1ec193be9fa16df46 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.34@sha256:e0258f91b41d07609f0746e8e8117868a6da63de51afcc23f5e9eedfec72acb3 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.0-alpine-slim@sha256:de6ddde5c469a798004f3659bd694194171c118e6c513ebbb517178751abbe78 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./*.pdf ./