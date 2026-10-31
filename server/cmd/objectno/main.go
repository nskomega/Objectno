package main

import (
	"context"
	"encoding/base64"
	"errors"
	"log"
	"net/http"
	"objectno/server/internal/auth"
	"os"
	"os/signal"
	"path/filepath"
	"strings"
	"syscall"
	"time"
)

func main() {
	key, err := base64.StdEncoding.DecodeString(os.Getenv("AUTH_SIGNING_KEY"))
	if err != nil || len(key) < 32 {
		log.Fatal("Set AUTH_SIGNING_KEY to base64 of at least 32 random bytes")
	}
	path := os.Getenv("AUTH_DB_PATH")
	if path == "" {
		path = "private/auth.db"
	}
	if err = os.MkdirAll(filepath.Dir(path), 0700); err != nil {
		log.Fatal("Cannot create database directory")
	}
	service, err := auth.Open(path, key)
	if err != nil {
		log.Fatal("Cannot open authentication database: ", err)
	}
	defer service.Close()
	if err = service.PruneExpired(); err != nil {
		log.Fatal("Cannot prune expired sessions")
	}

	address := os.Getenv("LISTEN_ADDR")
	if address == "" {
		address = "127.0.0.1:8080"
	}
	server := &http.Server{Addr: address, Handler: service.Handler(strings.Split(os.Getenv("ALLOWED_ORIGINS"), ",")), ReadHeaderTimeout: 5 * time.Second, ReadTimeout: 10 * time.Second, WriteTimeout: 15 * time.Second, IdleTimeout: 60 * time.Second, MaxHeaderBytes: 16 * 1024}
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()
	go func() {
		ticker := time.NewTicker(time.Hour)
		defer ticker.Stop()
		for {
			select {
			case <-ctx.Done():
				return
			case <-ticker.C:
				if err := service.PruneExpired(); err != nil {
					log.Print("Could not prune expired sessions")
				}
			}
		}
	}()

	go func() {
		<-ctx.Done()
		timeout, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		_ = server.Shutdown(timeout)
	}()
	log.Print("Objectno auth API listening on ", address, "; use an HTTPS reverse proxy for production")
	if err = server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
		log.Fatal(err)
	}
}
