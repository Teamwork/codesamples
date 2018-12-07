public async Task<string> PostData() {
  const string apiKey = "<YourAPIKey>";
  const string domain = "<YourDomain>"; //.teamwork.com
  const string endpoint = "projects.json"; //eg projects.json , milestones.json etc

  var client = new HttpClient {BaseAddress = new Uri("https://" + domain + ".teamwork.com")};
  client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
    "Basic", Convert.ToBase64String(
      UTF8Encoding.UTF8.GetBytes(string.Format("{0}:{1}", apiKey, "x"))
    )
  );
 
  client.DefaultRequestHeaders.Accept.Clear();
  client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

  string newProject = @"{'project': {
    name:
      'demo',
      'description':
      'Optional description',
      'companyId':
      '999' // integer,
      'newCompany':
      'Optional if creating a new company',
      'category-id':
      '999'
    }
  }";

  var data = await client.PostAsync(endpoint, new StringContent(newProject, Encoding.UTF8));
 
  using (Stream responseStream = await data.Content.ReadAsStreamAsync()) {
    return new StreamReader(responseStream).ReadToEnd();
  }
}