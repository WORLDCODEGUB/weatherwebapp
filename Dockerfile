# --- Stage 1: Build ---
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# 1. Copy POM
COPY pom.xml .

# 2. Create correct folder structure
RUN mkdir -p src/main/java
RUN mkdir -p src/main/webapp

# 3. Copy Java Code
# Moves src/MyPackage -> src/main/java/MyPackage
COPY src/ src/main/java/

# 4. Copy Web Content (HTML, CSS, WEB-INF)
# Moves WebContent -> src/main/webapp
COPY WebContent/ src/main/webapp/

# 5. Build
RUN mvn clean package

# --- Stage 2: Run ---
FROM tomcat:9.0-jdk17-temurin

# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Fix Render Port Issue
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# Copy the built app to ROOT
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
