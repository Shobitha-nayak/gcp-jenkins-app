# Builder stage
FROM bitnami/node:9 as builder
ENV NODE_ENV=production

WORKDIR /app

# Copy only package.json and package-lock.json
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Final stage
FROM bitnami/node:9-prod

ENV NODE_ENV=production \
    PORT=5000

WORKDIR /app

# Copy built application from the builder stage
COPY --from=builder /app .

# Expose port
EXPOSE 5000

# Start the application
CMD ["npm", "start"]
