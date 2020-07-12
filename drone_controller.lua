local component = require("component")
local shell = require("shell")
local event = require("event")
local modem = component.modem


--Open port
modem.open(1)

if modem.isOpen(1) then
  while true do
    --Seperate commands with empty lines
    print("")
  
    local command = io.read()

    --Check if command was the exit command
    if command == "exit" then break end

    --Try sending command
    sent = modem.broadcast(1, command)
    if not sent then
      print("Command not sent")
      goto continue
    end
  
    --Check if drone recieved command
    local event_type, _, _, _, _, message = event.pull(10,"modem_message")
    if event_type then
      --Check if drone loaded and read message
      local _, _, _, _, _, ranProperly, message = event.pull("modem_message")
      if ranProperly then
        --Command loaded and ran correctly
        print("Drone ran/is running command")
      end
    
      --Print message whether it is an error message or return values
      if message then
        print(message)
      end
    else
      print("Drone didn't recieve message")
    end
    
    ::continue::
  end
else
  error("Port not opened")
end
