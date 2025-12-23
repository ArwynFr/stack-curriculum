FROM asciidoctor/docker-asciidoctor:1.101.0@sha256:7aae24f5d37b4aa543db08cb118257626d6b397b39624bcb07f1feb13aab8d03 AS asciidoc
WORKDIR /src/curriculum
COPY ./curriculum.* ./
COPY ./docinfo.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.24.8@sha256:7d7ba575269b7700f3ac1635532882adfe04b293c98d8548715ca818e782bc0c AS minifier
WORKDIR /src/curriculum
COPY --from=asciidoc /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done
RUN for ext in "css" "js" "html" "mp4" "png" "webp" "webm" "woff2"; do find . -name "*.$ext" -exec gzip -9k {} \;; done

FROM nginxinc/nginx-unprivileged:1.29.3-alpine-slim@sha256:d9def221bf58500eb9d2f896367d149af317dce65a67bfdd1260754a4a8bc073 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=asciidoc /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./favicon.ico ./