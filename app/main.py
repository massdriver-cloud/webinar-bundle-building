from typing import List, Optional
from fastapi import FastAPI
from fastapi.param_functions import Query
from fastapi.responses import PlainTextResponse
from mangum import Mangum
import boto3
from fastapi import FastAPI, File, UploadFile
from pydantic import BaseModel
from botocore.exceptions import NoCredentialsError
import os

app = FastAPI()

s3_bucket = os.environ.get("S3_BUCKET", "s3-bucket-not-set")

s3 = boto3.client('s3')

@app.get("/")
async def health():
    return {"status": "OK"}

@app.get("/test")
async def test():
    return {"response": "this works!"}

class UploadFileBody(BaseModel):
    file_name: str
    content: str

@app.post("/upload")
async def upload_file(body: UploadFileBody):
    bucket_name = s3_bucket
    content = body.content
    filename = "/tmp/"+body.file_name
    with open(filename, 'w') as f:
        f.write(content)
    try:
        with open(filename, 'rb') as data:
            s3.upload_fileobj(data, bucket_name, body.file_name)
        return {"message": "Upload successful"}
    except FileNotFoundError:
        return {"error": "File not found"}
    except NoCredentialsError:
        return {"error": "Credentials not available"}
    finally:
        os.remove(filename)  # remove the temporary file

class DownloadFileBody(BaseModel):
    file_name: str

@app.get("/download")
async def download_file(body: DownloadFileBody):
    bucket_name = s3_bucket
    file_name = body.file_name
    try:
        s3.download_file(bucket_name, file_name, '/tmp/temp.txt')
        with open('/tmp/temp.txt', 'r') as f:
            file_content = f.read()
        return PlainTextResponse(file_content)
    except FileNotFoundError:
        return {"error": "File not found"}
    except NoCredentialsError:
        return {"error": "Credentials not available"}


handler = Mangum(app)