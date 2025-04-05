import asyncio
import edge_tts
from io import BytesIO

def text_to_speech(text):
    """
    Converts text to speech using Edge TTS (Microsoft) and returns audio bytes.
    """
    async def synthesize():
        tts = edge_tts.Communicate(
            text=text,
            voice="en-GB-LibbyNeural"  # You can change the voice
        )
        output = BytesIO()
        async for chunk in tts.stream():
            if chunk["type"] == "audio":
                output.write(chunk["data"])
        output.seek(0)
        return output.read()

    return asyncio.run(synthesize())
