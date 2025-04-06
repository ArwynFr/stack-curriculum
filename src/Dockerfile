FROM asciidoctor/docker-asciidoctor:1.84.0@sha256:c4fe627f068dd615bed2c0cde0f409307742e25c1ed72bc5d4cf8ab5ee3c3fbc AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.23.0@sha256:aecee5126bf089008ed32d1a20066c26ef08b6365cb0fa19f517d334121ea6ea AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.4-alpine-slim@sha256:154d7db418e13bcb29375cfa1f05d77496e986c717b9ba8a831e11077c880358 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./