# ── Stage 1: Build the WAR file using Maven & Java 21 ──
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml and download project dependencies first (for faster caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy your source code and build the .war package
COPY src ./src
RUN mvn clean package -DskipTests

# ── Stage 2: Run Tomcat 10 & Deploy the WAR ──
FROM tomcat:10.1-jdk21-temurin
WORKDIR /usr/local/tomcat

# Remove default Tomcat sample applications
RUN rm -rf webapps/*

# Copy the generated WAR from Stage 1 into Tomcat's webapps as ROOT.war
# Naming it ROOT.war makes your endpoints accessible directly at /api/...
# instead of having an extra /smartsahay/ prefix.
COPY --from=build /app/target/*.war webapps/ROOT.war

# Expose Tomcat's default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]