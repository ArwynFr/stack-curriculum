FROM asciidoctor/docker-asciidoctor:1.91.1@sha256:277ac405228f4cb5ca640174f9e6a8fab6600bba79c67f29aa7b3ffe215a8cf5 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.23.10@sha256:0bef3087d505bf87b3eed28c4ecaf90a83b6b9e9dab553ca353dbeace8b6d208 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.29.0-alpine-slim@sha256:e61b77b27c8f3124fad6d19e894ca5b603bcaf6a34a2df035511299dfa6fad35 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./