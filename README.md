### Test Endpoint
This command tests the connection to your API Gateway. Replace <gateway_hash> with your actual gateway hash.

```
curl --location --request GET 'https://<gateway_hash>.execute-api.us-east-1.amazonaws.com/live/test'
```


### Upload Endpoint
This command uploads a file to your S3 bucket via the API Gateway. Replace <gateway_hash> with your actual gateway hash.
```
curl --location --request POST 'https://<gateway_hash>.execute-api.us-east-1.amazonaws.com/live/upload' \
--header 'Content-Type: application/json' \
--data-raw '{
 "file_name": "testfile.txt",
 "content": "This is testfile.txt!"
}'
```

### Download Endpoint
This command downloads a file from your S3 bucket via the API Gateway.
```
curl --location --request GET 'https://<gateway_hash>.execute-api.us-east-1.amazonaws.com/live/download' \
--header 'Content-Type: application/json' \
--data-raw '{"file_name": "testfile.txt"}'
```