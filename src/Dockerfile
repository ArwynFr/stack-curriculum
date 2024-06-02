FROM asciidoctor/docker-asciidoctor:1.70.0@sha256:133a4115f1234cc3c6832f032fc7ced7f54f742ab2408b2087304604e365a42a AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.32@sha256:450b7e0ede28e085787fe4c798a85480238d3990b1c73e3bb78c7579d94fb3aa AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.27.0-alpine-slim@sha256:bda46c19e5c1c3d8f77f9a7dfff80f8852819015219d12f11d05cb82e6d1e4fa AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./*.pdf ./