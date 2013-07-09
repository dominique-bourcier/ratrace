class Salesforcewebservices
    
  
  def self.getResults username, password, token
    result = Login.instance.getSessionId(username, password, token)
    wsdlURL = createWsdlUrl result[:server_url]
    headers = {'apex:SessionHeader' =>{'apex:sessionId' => result[:session_id]}, 'apex:DebuggingHeader' =>{'apex:debugLevel' => 'Callout', 'apex:categories' => {'apex:category'=>'Callout', 'apex:level'=>'INFO'}}}
    client = Savon.client(
          wsdl: 'app/assets/wsdl/apex.wsdl',
          endpoint: wsdlURL,
          namespace: 'http://soap.sforce.com/2006/08/apex',
          namespace_identifier: :apex,
          soap_header: headers,
          read_timeout: 6000
    )
    response = client.call(:run_tests) do
                message run_tests_request:{ all_tests: :true}
                
              end
    data = response.to_hash   
  end
  
def self.createWsdlUrl serverUrl
    urlArray = Array.new
    urlArray = serverUrl.split('/')
    wsdlUrl = urlArray[0]+'//'+urlArray[2]+'/'+urlArray[3]+'/'+urlArray[4]+'/s/'+urlArray[6]
end


  
end