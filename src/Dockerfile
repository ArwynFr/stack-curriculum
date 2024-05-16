FROM asciidoctor/docker-asciidoctor:1.70.0@sha256:133a4115f1234cc3c6832f032fc7ced7f54f742ab2408b2087304604e365a42a AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.23@sha256:13b7d13ed4e3b884ab401fbf2c4b58aa07c11ac63b2dc6fe05c7ab2f6d1eb3c6 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.26.0-alpine-slim@sha256:b097a0988e67f90171ed257d3c5da900d544a8f2271412621528365a4dc4b5df AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./*.pdf ./