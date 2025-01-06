from pydantic_ai.models.openai import OpenAIModel
import os
from enum import Enum
from openai import AsyncOpenAI, OpenAI

class ModelInfo(Enum):
    
    def __init__(self, base_url: str | None, api_key: str | None):
        self.base_url = base_url
        self.api_key = api_key

    def to_pydaic_model(self, model: str):
        return OpenAIModel(model_name=model, base_url=self.base_url, api_key=self.api_key)
    
    def to_openai_model(self, is_async: bool = False):
        if is_async:
            return AsyncOpenAI(base_url=self.base_url, api_key=self.api_key)
        return OpenAI(base_url=self.base_url, api_key=self.api_key)
    
class Models(ModelInfo):
    OPENAI = (None, os.getenv('OPENAI_API_KEY'))
    GROQ = ('https://api.groq.com/openai/v1', os.getenv('GROQ_API_KEY'))
    GEMINI = ("https://generativelanguage.googleapis.com/v1beta/openai/", os.getenv('GEMINI_API_KEY'))
    DEEPSEEK = ('https://api.deepseek.com', os.getenv("DEEPSEEK_API_KEY"))
    
    