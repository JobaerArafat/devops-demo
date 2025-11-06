# Step 1: Use official Go image
FROM golang:1.25.3

# Step 2: Create working directory
WORKDIR /app

# Step 3: Copy all files to container
COPY . .

# Step 4: Build Go binary
RUN go build -o main .

# Step 5: Run the app
CMD ["./main"]
