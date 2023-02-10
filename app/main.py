import datetime
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"time": datetime.datetime.now().isoformat()}
