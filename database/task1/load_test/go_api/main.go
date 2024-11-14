package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"sync"

	_ "github.com/lib/pq"
)

var db *sql.DB
var dbOnce sync.Once

// Configuration variables for the DB
var (
	DBHost     = "localhost"
	DBPort     = "6432"
	DBName     = "postgres"
	DBUser     = "postgres"
	DBPassword = "admin"
)

// Initialize DB connection pool (Singleton pattern)
func getDBConnection() (*sql.DB, error) {
	var err error
	dbOnce.Do(func() {
		connStr := fmt.Sprintf("host=%s port=%s dbname=%s user=%s password=%s sslmode=disable binary_parameters=yes",
			DBHost, DBPort, DBName, DBUser, DBPassword)
		db, err = sql.Open("postgres", connStr)
		if err != nil {
			log.Fatal("Error initializing DB connection pool: ", err)
		}
		// Set the maximum number of idle connections in the pool
		db.SetMaxIdleConns(10)
		// Set the maximum number of open connections to the database
		db.SetMaxOpenConns(100)
	})
	return db, err
}

// Recommendation handler
func triggerRecommendation(w http.ResponseWriter, r *http.Request) {
	deviceID := r.URL.Query().Get("user_id") // Get device_id from query params

	if deviceID == "" {
		http.Error(w, "user_id is required", http.StatusBadRequest)
		return
	}

	// Ensure DB connection is available
	db, err := getDBConnection()
	if err != nil {
		http.Error(w, "Failed to connect to database: "+err.Error(), http.StatusInternalServerError)
		return
	}

	// Execute the stored procedure asynchronously
	go func() {
		_, err := db.Exec("SELECT get_recommendations_by_user_id($1);", deviceID)
		if err != nil {
			log.Println("Error triggering recommendation:", err)
		}
	}()

	// Prepare and send response
	response := map[string]string{
		"status":  "success",
		"message": fmt.Sprintf("Triggered recommendation for user_id: %s", deviceID),
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func main() {
	http.HandleFunc("/recommendations", triggerRecommendation)

	// Start the server
	port := "8080"
	fmt.Printf("Server is running on port %s...\n", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
