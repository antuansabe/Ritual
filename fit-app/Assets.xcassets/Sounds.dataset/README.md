# Timer Sound Files

This folder contains audio files for the timer phase transitions.

## Files Required:

1. **work-beep.wav** - Sound played when starting work phase
   - Recommended: Short beep sound (0.3-0.5 seconds)
   - Format: WAV, 44.1kHz, Mono or Stereo
   - Volume: Should be clear and attention-grabbing

2. **rest-bell.wav** - Sound played when starting rest phase
   - Recommended: Gentle bell or chime sound (0.5-1 second)
   - Format: WAV, 44.1kHz, Mono or Stereo
   - Volume: Should be softer and more relaxing

## How to Replace:

1. Replace the placeholder files with your custom audio files
2. Keep the same file names: `work-beep.wav` and `rest-bell.wav`
3. Ensure the files are in WAV format for best compatibility
4. Test the sounds to ensure they're not too loud or too soft

## Fallback Sounds:

If custom files are not available, the app will use system sounds:
- Work phase: System ping sound (ID: 1054)
- Rest phase: System mail sound (ID: 1005)

## Notes:

- The app uses AVFoundation for audio playback
- Audio session is configured to mix with other apps
- Volume levels can be adjusted in the code if needed