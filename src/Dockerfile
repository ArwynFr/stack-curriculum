FROM asciidoctor/docker-asciidoctor:1.70.0@sha256:133a4115f1234cc3c6832f032fc7ced7f54f742ab2408b2087304604e365a42a AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.31@sha256:88ee7c53043c93abaf658b04fe61b2788253b6469f2d04eb8f181f7fdc91cfc3 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.26.0-alpine-slim@sha256:9d742a6544a066f7a7f66e937a62e63974af477a58fa923dae96564c776e8180 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./*.pdf ./