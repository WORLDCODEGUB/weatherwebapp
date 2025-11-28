# Use Nginx to serve the static files
FROM nginx:alpine

# Copy your project files to the Nginx html directory
COPY . /usr/share/nginx/html

# Expose port 80 (Standard for web traffic)
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
