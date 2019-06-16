# Try without doing anything bad

Stop-Computer -WhatIf

# Stop the local computer

Stop-Computer

# Try without doing anything bad on multiple systems

Stop-computer -ComputerName ‘computer01′,’computer02′,’computer03’ -whatif

# Stop multiple systems

Stop-computer -ComputerName ‘computer01′,’computer02′,’computer03’

# https://devblogs.microsoft.com/scripting/powertip-turn-off-the-power-to-your-computer-with-powershell/