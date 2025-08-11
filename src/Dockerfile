FROM asciidoctor/docker-asciidoctor:1.91.1@sha256:277ac405228f4cb5ca640174f9e6a8fab6600bba79c67f29aa7b3ffe215a8cf5 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.23.11@sha256:3e245648b418b1abffba4f2f3c2a969080fe943768d677955d416b64e89bb95a AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.29.0-alpine-slim@sha256:a910bc3b8e3d28493ab397a42e882e00346da7a4b7e40f62b281cdc150cbda99 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./