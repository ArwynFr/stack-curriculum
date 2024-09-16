FROM asciidoctor/docker-asciidoctor:1.76.0@sha256:78179dc7c4911be6f7698efb7183d6840443c7f98ca87a4e452e7793958a0399 AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.37@sha256:c52669ab0219f338d502bb5d0b68550e086052f7160ed8c5ca7daf7af9fc04f5 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.1-alpine-slim@sha256:a53de05dcb0d687c04f7dbeb9c65c9cf5622a72353fd2688963a521774e2d501 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./*.pdf ./