package main

import (
	"fmt"
	"log"
	"net/http"
)

func newMux(s string) *http.ServeMux {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, %s!", s)
	})
	return mux
}

func main() {
	s := "gopher"
	mux := newMux(s)

	fmt.Printf("Server starting on :8080\n")
	if err := http.ListenAndServe(":8080", mux); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}
