from fastapi import FastAPI
import openai
import configparser

app = FastAPI()

MAX_TOKEN_DEFAULT = 128
TEMPERATURE = 0.0
STREAM = True

def initialize_openai_api():
    config = configparser.ConfigParser()
    config.read('config')
    openai.api_key = config['api_key']['secret_key']

def create_input_prompt(englishTextIn=""):
    prompt = "The following bot transforms natural language to Python code. \n" + \
             "Input: {}\n".format(englishTextIn) + \
             "Python: \n '''python"
    return prompt


def generate_completion(input_prompt, num_tokens=MAX_TOKEN_DEFAULT):
    stop_string = "'''\n"
    response = openai.Completion.create(engine='text-davinci-002', prompt=input_prompt, temperature=TEMPERATURE,
                                        max_tokens=num_tokens, stream=STREAM, stop=stop_string,
                                        top_p=1.0, frequency_penalty=0.0, presence_penalty=0.0)
    return response


def get_generated_response(response):
    generatedCode = "## Python code generated from plain english: \n"
    while True:
        nextResponse = next(response)
        completion = nextResponse['choices'][0]['text']
        generatedCode = generatedCode + completion
        if nextResponse['choices'][0]['finish_reason'] is not None:
            break
    return generatedCode

@app.get("/")
def predict(englishText:str):
# def predict():
    # prompt format: python program + the desired action
    initialize_openai_api()
    # englishText = 'def add_two_numbers(a, b): #initialise a to 3 in the function'
    prompt = create_input_prompt(englishText)
    # print(prompt)
    response = generate_completion(prompt)
    op = get_generated_response(response)
    # print(op)
    
    return{"output":op}