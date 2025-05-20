# app/main.py
from fastapi import FastAPI
import json

app = FastAPI()

@app.get("/resume")
def get_resume():
    with open("app/resume.json", "r") as f:
        resume = json.load(f)
    return resume
