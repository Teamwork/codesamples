public async Task<string> GetData() {
  const string apiKey = "<YourAPIKey>";
  const string domain = "<YourDomain>"; //.teamwork.com
  const string endpoint = "projects.json"; //eg projects.json , milestones.json etc

  var client = new HttpClient {BaseAddress = new Uri("https://" + domain + ".teamwork.com")};
  client.DefaultRequestHeaders.Authorization =
 
  new AuthenticationHeaderValue("Basic",Convert.ToBase64String(UTF8Encoding.UTF8.GetBytes(string.Format("{0}:{1}", apiKey, "x"))));
  client.DefaultRequestHeaders.Accept.Clear();
  client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

  var data = await client.GetAsync(endpoint);
  using (Stream responseStream = await data.Content.ReadAsStreamAsync()) {
    return new StreamReader(responseStream).ReadToEnd();
  }
}