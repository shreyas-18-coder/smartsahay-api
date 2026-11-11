# ── Stage 1: Build WAR with Maven ──
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# ── Stage 2: Run Tomcat 10 ──
FROM tomcat:10.1-jdk21-temurin
WORKDIR /usr/local/tomcat

# Remove default sample apps
RUN rm -rf webapps/*

# Disable Tomcat server shutdown port to stop "Invalid shutdown command" warnings
RUN sed -i 's/<Server port="8005" shutdown="SHUTDOWN">/<Server port="-1" shutdown="SHUTDOWN">/' conf/server.xml

# Deploy application as ROOT.war
COPY --from=build /app/target/*.war webapps/ROOT.war

ENV PORT=8080
EXPOSE 8080

CMD ["catalina.sh", "run"]