FROM asciidoctor/docker-asciidoctor:1.70.0@sha256:133a4115f1234cc3c6832f032fc7ced7f54f742ab2408b2087304604e365a42a AS build
WORKDIR /src/curriculum
COPY ./curriculum.* ./
RUN asciidoctor curriculum.adoc
RUN asciidoctor-pdf curriculum.adoc

FROM tdewolff/minify:v2.20.30@sha256:bbbdd3315236ba08e00a534d17fb7bed179e5b92ba8770995ecb096ef4e5dbf8 AS minifier
WORKDIR /src/curriculum
COPY --from=build /src/curriculum/curriculum.html ./
RUN for ext in "css" "js" "html"; do find . -name "*.$ext" -exec minify -o {} {} \;; done

FROM nginxinc/nginx-unprivileged:1.26.0-alpine-slim@sha256:ca6c2c3bed6cba473d2bcc8e5583b562ee335d043b9c72dc0eab983f6dd3a49c AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/curriculum/curriculum.html index.html
COPY --from=build /src/curriculum/curriculum.pdf ./
COPY ./*.txt ./
COPY ./*.pdf ./