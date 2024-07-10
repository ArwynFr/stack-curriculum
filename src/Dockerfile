FROM asciidoctor/docker-asciidoctor:1.74.0@sha256:bec43821ae2dfedb7e1196683caa27e19c7ac225a412bb601d60afac15764fd4 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.37@sha256:c52669ab0219f338d502bb5d0b68550e086052f7160ed8c5ca7daf7af9fc04f5 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.0-alpine-slim@sha256:3eee4da6664c4bfce131d7a8ea7536504665c3c907c9137cb88da09b911f2d81 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./*.pdf ./