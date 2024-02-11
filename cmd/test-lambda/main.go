package main

import (
    "context"
    "encoding/json"
    "net/http"
	"log"

    "github.com/aws/aws-lambda-go/events"
    "github.com/aws/aws-lambda-go/lambda"
	"go.uber.org/zap"

    "github.com/danielhough/terraform-delight/internal/logger"
)

type LambdaAPIGatewayHandler func(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error)

type Response struct {
    Message string `json:"message"`
}

func handler(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var err error

    zapLogger, err := logger.Production()
    if err != nil {
        log.Fatal("failed to initialise logger", err)
    }

    zapLogger.Info("Testing logging")

    body, err := json.Marshal(Response{Message: "Testing Lambda Response"})
    if err != nil {
        zapLogger.Error("failed to marshal response", zap.Error(err))
        return events.APIGatewayProxyResponse{}, err
    }

    return events.APIGatewayProxyResponse{
        Body:       string(body),
        Headers:    map[string]string{"Content-Type": "application/json"},
        StatusCode: http.StatusOK,
    }, nil
}

func main() {
    lambda.Start(handler)
}
