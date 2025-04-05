import librosa
import soundfile as sf
import numpy as np

def normalize_audio(filename):
    """
    Normalizes the amplitude of an audio file.
    """
    audio, fs = librosa.load(filename, sr=None)
    audio = audio / np.max(np.abs(audio))  # Scale between -1 and 1
    sf.write(filename, audio, fs)
    return filename
import librosa.effects


from scipy.signal import butter, lfilter

def butter_bandpass(lowcut, highcut, fs, order=5):
    """
    Creates band-pass filter coefficients.
    """
    nyquist = 0.5 * fs
    low = lowcut / nyquist
    high = highcut / nyquist
    b, a = butter(order, [low, high], btype='band')
    return b, a

def apply_bandpass_filter(filename, lowcut=85, highcut=4000, fs=16000):
    """
    Applies a band-pass filter to keep only speech frequencies (85Hz - 4000Hz).
    """
    audio, _ = librosa.load(filename, sr=fs)
    b, a = butter_bandpass(lowcut, highcut, fs)
    filtered_audio = lfilter(b, a, audio)
    sf.write(filename, filtered_audio, fs)
    return filename




def remove_noise_fft(filename, noise_threshold=0.01):
    """
    Removes background noise using FFT-based spectral subtraction.
    """
    audio, fs = librosa.load(filename, sr=None)
    fft_audio = np.fft.fft(audio)
    magnitude = np.abs(fft_audio)
    phase = np.angle(fft_audio)
    magnitude[magnitude < noise_threshold] = 0  # Remove low-energy noise
    cleaned_audio = np.fft.ifft(magnitude * np.exp(1j * phase)).real
    sf.write("cleaned_" + filename, cleaned_audio, fs)
    return "cleaned_" + filename




