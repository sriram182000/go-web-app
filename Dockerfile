FROM golang:1.22.5 as base 

WORKDIR /app

COPY go.mod .

RUN go mod download

COPY . .

RUN go build -o myapp .

# final image Distroless image -- less in size and secure 
FROM gcr.io/distroless/base

COPY --from=base /app/myapp .

COPY --from=base /app/static ./static

EXPOSE 8080

CMD ["./myapp"]
