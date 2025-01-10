/*
Developed By Taipei Urban Intelligence Center 2023-2024

// Lead Developer:  Igor Ho (Full Stack Engineer)
// Systems & Auth: Ann Shih (Systems Engineer)
// Data Pipelines:  Iima Yu (Data Scientist)
// Design and UX: Roy Lin (Prev. Consultant), Chu Chen (Researcher)
// Testing: Jack Huang (Data Scientist), Ian Huang (Data Analysis Intern)
*/

package main

import "TaipeiCityDashboardBE/cmd"

// comment code below to build the server

import (
"github.com/rs/cors"
 "net/http"
 "log"
)

func violationsGeojsonHandler(w http.ResponseWriter, r *http.Request) {
// Your logic to return the geojson data goes here
// Example: Writing a sample response
w.Header().Set("Content-Type", "application/json")
w.Write([]byte(`{"type": "FeatureCollection", "features": []}`))
}

func main() {
 Your existing routes and handlers
	http.HandleFunc("/violations-polygon-geojson", violationsGeojsonHandler)

 Enable CORS
	c := cors.New(cors.Options{
	AllowedOrigins: []string{"http://localhost:8080"}, // Adjust the allowed origin (your dashboard FE URL)
	AllowCredentials: true,
	AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE"},
	AllowedHeaders:   []string{"Content-Type", "Authorization"},
})

// Wrap the handler with CORS
handler := c.Handler(http.DefaultServeMux)

log.Println("Server running on :8000")
log.Fatal(http.ListenAndServe(":8000", handler))
cmd.Execute()
}

//comment code above to build the server

// uncomment code below to build the server
//  func main() {
 // 	cmd.Execute() 
// }