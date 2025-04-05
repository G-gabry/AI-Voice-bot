from pydub import AudioSegment

def convert_webm_to_wav(input_path, output_path):
    audio = AudioSegment.from_file(input_path, format="webm")
    audio.export(output_path, format="wav")
