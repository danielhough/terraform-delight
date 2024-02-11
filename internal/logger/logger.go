package logger

import (
	"fmt"

	"go.uber.org/zap"
)

func Production() (*zap.Logger, error) {
	cfg := zap.NewProductionConfig()

	logger, err := cfg.Build()
	if err != nil {
		return nil, fmt.Errorf("unable to initialise the production zap logger: %w", err)
	}

	logger = logger.With(zap.Namespace("context"))

	return logger, nil
}
