# --- Stage 1: Build ---
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# 1. Copy POM file
COPY pom.xml .

# 2. CREATE STANDARD MAVEN STRUCTURE
RUN mkdir -p src/main/java
RUN mkdir -p src/main/webapp

# 3. FIX JAVA LOCATION
# We copy your 'src' folder (containing MyPackage) into Maven's expected folder
# Result inside container: /app/src/main/java/MyPackage/MyServlet.java
COPY src/ src/main/java/

# 4. FIX WEB CONTENT LOCATION
# We copy 'WebContent' to where Maven looks for HTML/JSP
COPY WebContent/ src/main/webapp/

# 5. Build the application
RUN mvn clean package

# --- Stage 2: Run ---
FROM tomcat:9.0-jdk17-temurin

# Clean existing apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Fix Render Health Check (Disable Shutdown Port)
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# Copy the built WAR file
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
