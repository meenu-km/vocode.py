from fastapi import FastAPI
import openai
import configparser
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Define CORS origins
origins = [
    "http://localhost",
    "http://localhost:8000",
    "http://localhost:3000",
    "http://localhost:64944"
]

MAX_TOKEN_DEFAULT = 2048
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
    # generatedCode = "## Python code generated from plain english: \n"
    generatedCode = ""
    # while True:
    for nextResponse in response:
        # nextResponse = next(response)
        completion = nextResponse['choices'][0]['text']
        generatedCode = generatedCode + completion
        if nextResponse['choices'][0]['finish_reason'] is not None:
            break
    return generatedCode

@app.get("/")
def predict(englishText:str):
    # prompt format: # + desired command
    initialize_openai_api()
    prompt = create_input_prompt(englishText)
    response = generate_completion(prompt)
    op = get_generated_response(response)
    return{"output":op}
    

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    #["http://localhost:52657/#/"],
    #origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
