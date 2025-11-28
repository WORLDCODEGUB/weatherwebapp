# --- Build Stage ---
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app
COPY . .
RUN mvn -B clean package

# --- Run Stage ---
FROM tomcat:9.0-jdk17-temurin
# Clean default webapps
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy WAR from build stage
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
