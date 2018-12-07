package main

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
)

const (
	siteName       string = "{{yourSiteName}}"
	apiUrl         string = "https://" + siteName + ".teamwork.com/"
	apiKey         string = "{{yourApiKey}}"
	dataPreference string = "json"
)

var (
	companyId string = "{{yourCompanyId}}"
	projectId string = "{{yourProjectId}}"
	endPoint  string = "projects/" + projectId + "." + dataPreference
)

type ProjectJson struct {
	Project `json:"project"`
}

type Project struct {
	Category_id            string `json:"category-id"`
	CompanyID              string `json:"companyId"`
	Description            string `json:"description"`
	EndDate                string `json:"endDate"`
	Harvest_timers_enabled bool   `json:"harvest-timers-enabled"`
	Name                   string `json:"name"`
	NewCompany             string `json:"newCompany"`
	PrivacyEnabled         bool   `json:"privacyEnabled"`
	ReplyByEmailEnabled    bool   `json:"replyByEmailEnabled"`
	StartDate              string `json:"startDate"`
}

func main() {
	putRequest(endPoint)
}

func putRequest(endPoint string) {

	data := ProjectJson{
		Project{
			Category_id:            "0",
			CompanyID:              companyId,
			Description:            "Edited project",
			EndDate:                "",
			Harvest_timers_enabled: true,
			Name:                "Edited New Project",
			NewCompany:          "",
			PrivacyEnabled:      true,
			ReplyByEmailEnabled: true,
			StartDate:           "",
		}}

	jsonPayload, err := json.Marshal(data)
	if err != nil {
		log.Fatal(err)
	}

	client := &http.Client{}
	req, err := http.NewRequest("PUT", apiUrl+endPoint, bytes.NewBuffer(jsonPayload))
	req.Header.Add("Authorization", "Basic "+basicAuth(apiKey))
	req.Header.Set("Content-Type", "application/json")

	resp, err := client.Do(req)
	if err != nil {
		log.Fatal(err)
	}

	body, err := ioutil.ReadAll(resp.Body)
	s := string(body)
	log.Printf(s)

}

func basicAuth(apiKey string) string {
	return base64.StdEncoding.EncodeToString([]byte(apiKey))
}
