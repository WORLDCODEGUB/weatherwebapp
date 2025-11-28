# --- Stage 1: Build ---
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# 1. Copy POM
COPY pom.xml .

# 2. Copy Source Code correctly
# This takes your 'src' folder and puts it exactly where Maven expects it
COPY src/ src/

# 3. Copy WebContent correctly
# This takes your HTML/JSP and puts it where Maven expects web pages
COPY WebContent/ src/mypackage

# 4. Build the app
RUN mvn clean package

# --- Stage 2: Run ---
FROM tomcat:9.0-jdk17-temurin

# Clean existing apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Fix Render Health Check
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# Copy the Result
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
