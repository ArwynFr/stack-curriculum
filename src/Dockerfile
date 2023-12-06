FROM asciidoctor/docker-asciidoctor:1.59.0@sha256:57cc6cb92db73f3d87eda00af21573748f1101b7ec455601b3ac60baeb18180d AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc ; asciidoctor-pdf curriculum.adoc


FROM debian:12.2-slim@sha256:2bc5c236e9b262645a323e9088dfa3bb1ecb16cc75811daf40a23a824d665be9 AS minifier
WORKDIR /src/curriculum
RUN apt-get update --yes
RUN apt-get install --yes --no-install-recommends minify=2.12.4-2
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \; -printf "gzip -9c %p > %p.gz\n" | sh; done

FROM nginxinc/nginx-unprivileged:1.25.3-alpine-slim@sha256:7a1e48fb200b847bfe8e9d4cc605d14237574cc8122ba435dfdc5b9bd1f032a3 AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./