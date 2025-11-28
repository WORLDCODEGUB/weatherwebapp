# Stage 1: Build the Java Application using Maven
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

# Stage 2: Run Tomcat
FROM tomcat:9.0-jdk17-temurin
# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy the WAR file we built in Stage 1
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
