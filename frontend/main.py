from fastapi import FastAPI
import torch
from transformers import AutoTokenizer

app = FastAPI()

model = torch.load('model.pt')
tokenizer = AutoTokenizer.from_pretrained("tokenizer")

@app.get("/")
def predict():
    prompt = '''def binarySearch(arr, left, right, x):
    mid = (left +'''
    input_ids = tokenizer.encode(prompt, return_tensors='pt')
    result = model.generate(input_ids, max_length=100, num_beams=1, num_return_sequences=1)
    op = []
    for res in result:
        op.append(tokenizer.decode(res))
    
    return{"output":op}


# @app.get("/get-student/{student_id}")
# def get_student(student_id: int = (None,description="The ID of the student you want to view")):
#     return students[student_id]