# Use official Go image
FROM golang:1.25.3

# Set working directory inside container
WORKDIR /app

# Copy Go module files
COPY go.mod ./
COPY go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the Go app
RUN go build -o main .

# Expose port 8080
EXPOSE 8080

# Run the executable
CMD ["./main"]