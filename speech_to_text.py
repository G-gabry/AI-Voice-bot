

import  whisper
model=whisper.load_model("base")
# Initialize the OpenAI client


import ollama

def get_ai_response(user_text):
    response = ollama.chat(
        model='phi',
        messages=[
            {"role": "system", "content": "You are a warm, conversational AI voice assistant. Always reply like you're speaking to a real person in a natural, friendly tone. Your answers must be easy to understand, limited to **one or two clear sentences**, and **never more than 15 words**. Avoid repeating the question or over-explaining. Speak like a helpful human — casual, not robotic."
},
            {"role": "user", "content": user_text}
        ]
    )
    return response['message']['content']




def convert_speech_to_text(filename="user_voice.wav"):
    """
    Converts speech to text using OpenAI's Whisper model locally.
    """
    result = model.transcribe(filename)
    return result["text"]
