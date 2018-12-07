package main

import (
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
	getRequest(endPoint)
}

func getRequest(endPoint string) {

	client := &http.Client{}
	req, err := http.NewRequest("GET", apiUrl+endPoint, nil)
	req.Header.Add("Authorization", "Basic "+basicAuth(apiKey))

	resp, err := client.Do(req)
	if err != nil {
		log.Fatal(err)
	}

	body, err := ioutil.ReadAll(resp.Body)

	var p ProjectJson
	err = json.Unmarshal(body, &p)
	if err != nil {
		log.Fatal(err)
	}

	log.Println(p.Project.Name)
	log.Println(string(body))

}

func basicAuth(apiKey string) string {
	return base64.StdEncoding.EncodeToString([]byte(apiKey))
}
