FROM asciidoctor/docker-asciidoctor:1.79.0@sha256:e2921ccf36e7a125675c92724ba604f84b3fe881205304921b5abf5256ccb87e AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.37@sha256:c52669ab0219f338d502bb5d0b68550e086052f7160ed8c5ca7daf7af9fc04f5 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.2-alpine-slim@sha256:a0a42ad77e45016c1a962db6e91e560ac333d2a7b0ae6b0d5bcdefbb213e2e26 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./