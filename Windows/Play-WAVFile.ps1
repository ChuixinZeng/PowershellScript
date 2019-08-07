$PlayWav=New-Object System.Media.SoundPlayer

$PlayWav.SoundLocation=’C:\Foo\Soundfile.wav’

$PlayWav.playsync()

# https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-play-wav-files/