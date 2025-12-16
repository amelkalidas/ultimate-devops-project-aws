### BY AMEL

FROM eclipse-temurin:21-jdk AS baseline

WORKDIR /usr/src/app

COPY gradlew settings.gradle build.gradle .
COPY ./gradle ./gradle

RUN chmod +x gradlew
RUN ./gradlew
RUN ./gradlew downloadRepos

COPY ./src ./src  
COPY ./pb ./proto

RUN ./gradlew installDist -PprotoSourceDir=./proto

FROM eclipse-temurin:21-jre AS runner

WORKDIR /usr/src/app
COPY --from=baseline /usr/src/app/build/install/opentelemetry-demo-ad/ ./
RUN ls -lsrta

ENV AD_PORT=8080

ENTRYPOINT ["./bin/Ad"]