from flask import Flask, render_template, request, jsonify
from flask_cors import CORS
import base64
import os
from DSP import apply_bandpass_filter, remove_noise_fft, normalize_audio
from speech_to_text import convert_speech_to_text, get_ai_response
from text_to_speech import text_to_speech
from utils import convert_webm_to_wav  # You will create this helper function

app = Flask(__name__)
CORS(app)  # Or replace * with your frontend URL if you want more security


def process_and_clean_audio(filename):
    print("🎛 Applying DSP Processing...")
    normalized_file = normalize_audio(filename)
    noise_reduced_file = remove_noise_fft(normalized_file)
    cleaned_file = apply_bandpass_filter(noise_reduced_file)
    print("✅ Audio Processing Complete.")
    return cleaned_file


@app.route('/')
def index():
    return render_template('UI.html')  # Make sure UI.html is in your templates folder


@app.route('/speak', methods=['POST'])
def speak():
    try:
        if 'audio' not in request.files:
            return jsonify({"error": "No audio file received"}), 400

        audio_file = request.files['audio']
        webm_path = "user_voice.webm"
        wav_path = "user_voice.wav"
        audio_file.save(webm_path)

        convert_webm_to_wav(webm_path, wav_path)
        cleaned_audio = process_and_clean_audio(wav_path)
        user_text = convert_speech_to_text(cleaned_audio)
        ai_response = get_ai_response(user_text)
        audio_bytes = text_to_speech(ai_response)
        audio_base64 = base64.b64encode(audio_bytes).decode("utf-8")

        return jsonify({
            "response": ai_response,
            "audio_data": audio_base64
        })

    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(debug=True)
