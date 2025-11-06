package main

import (
    "fmt"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "Hello, DevOps from Docker!")
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("Server running at http://localhost:8080")
    http.ListenAndServe(":8080", nil)
}

এই কোড run করলে:


http://localhost:8080
এখানে ব্রাউজারে "Hello, DevOps from Docker!" দেখাবে।

Dockerfile এ এই HTTP server run করানোর পরে, container চালালে ব্রাউজারে দেখা যাবে।


 এখন পুরো Go HTTP server + Docker + GitHub CI/CD → run locally in browser workflow তৈরি করব।


main.go ফাইল:

package main

import (
    "fmt"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "Hello, DevOps from Docker!")
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("Server running at http://localhost:8080")
    http.ListenAndServe(":8080", nil)
}

এখন এটি ব্রাউজারে চলবে।


===============================================================================================
Dockerfile তৈরি
Dockerfile:


# Use official Go image
FROM golang:1.21-alpine

# Set working directory inside container
WORKDIR /app

# Copy Go module files
COPY go.mod ./


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


============================================================================================


GitHub Repository তৈরি ও push
bash
Copy code
git init
git add .
git commit -m "Add Go HTTP server and Dockerfile"
git branch -M main
git remote add origin https://github.com/<username>/demoapp.git
git push -u origin main


================================================================================================

github & dockerhub authentication 

gh --version
gh auth login

# Docker Hub username
gh secret set DOCKER_USERNAME -b"yourdockerusername"

# Docker Hub Personal Access Token (PAT)
gh secret set DOCKER_PASSWORD -b"yourdockerPAT"


============================================================================================
 GitHub Actions Workflow
.github/workflows/docker-ci.yml:

yaml
Copy code
name: Docker CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Log in to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}

    - name: Build and push Docker image
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: <your-dockerhub-username>/demoapp:latest
Secrets:

DOCKER_USERNAME = Docker Hub username

DOCKER_PASSWORD = Docker Hub password
====================================================================================================
Docker Hub থেকে pull ও run
Pull image:


docker pull <your-dockerhub-username>/demoapp:latest
Run container:


docker run -p 8080:8080 <your-dockerhub-username>/demoapp:latest
ব্রাউজারে যান:


http://localhost:8080
দেখবেন: Hello, DevOps from Docker!

✅ এখন পুরো workflow ready:

Git push → GitHub Actions → Docker Hub → Local run → Browser
