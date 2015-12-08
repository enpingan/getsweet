
QB_KEY = "qyprde4RTOIcvXqijCqz7UrdPHvIL2"
QB_SECRET = "LkvWMT6PTZxrKDkAPN1G3RSwFnF2I3zG3KYQGum2"

$qb_oauth_consumer = OAuth::Consumer.new(QB_KEY, QB_SECRET, {
  :site                 => "https://oauth.intuit.com",
  :request_token_path   => "/oauth/v1/get_request_token",
  :authorize_url        => "https://appcenter.intuit.com/Connect/Begin",
  :access_token_path    => "/oauth/v1/get_access_token"
})

Quickbooks.sandbox_mode = true