# Use the official Golang image as the builder stage
#FROM golang:1.26-alpine AS builder
FROM golang:1.24 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and download dependencies
# Note: go.sum is omitted as it is not present in the project
COPY go.mod ./
RUN go mod download

# Copy the source code
COPY . .

# Build the application
# CGO_ENABLED=0 ensures a statically linked binary
RUN CGO_ENABLED=0 GOOS=linux go build -o server .

# Use a minimal alpine image for the final stage
#FROM alpine:latest
FROM registry.access.redhat.com/rhscl/httpd-24-rhel7

# Install ca-certificates in case the app makes outbound HTTPS calls
#RUN apk --no-cache add ca-certificates

# Set the working directory
WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/server .

# Expose the port the server listens on
EXPOSE 8080

# Run the binary
CMD ["./server"]
