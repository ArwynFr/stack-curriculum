FROM asciidoctor/docker-asciidoctor:1.82.0@sha256:3aa285210a046dcbc2f04d248df8db58e7196873f1659727168e5cea20416e91 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.21.3@sha256:27681462ac09607d893645ba09410c28e3e05c9e5ff2c0fd8c03ebd8af2adce1 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.3-alpine-slim@sha256:65f2b40f4d9bd814f38be587d6a6a23d8d62d7a44d3b30df181fc3b10543e063 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./