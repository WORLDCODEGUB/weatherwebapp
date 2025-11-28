# --- Stage 1: Build ---
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# 1. Create the standard Maven folder structure manually
RUN mkdir -p src/main/java
RUN mkdir -p src/main/webapp

# 2. Copy pom.xml
COPY pom.xml .

# 3. MAGIC STEP: Copy your folders to the correct Maven locations
# Copy your 'src' folder (Java code) to where Maven looks for Java code
COPY src/ src/main/java/

# Copy your 'WebContent' folder (HTML/JSP) to where Maven looks for Web apps
COPY WebContent/ src/main/webapp/

# 4. Build the app (Now Maven will find everything)
RUN mvn clean package

# --- Stage 2: Run ---
FROM tomcat:9.0-jdk17-temurin

# Clean existing apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Fix Render Health Check (Disable Shutdown Port)
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# Copy the Result
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
