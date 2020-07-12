local modem = component.proxy(component.list("modem")())
drone = component.proxy(component.list("drone")())

modem.open(1)

if modem.isOpen(1) then
  while true do
    -- Listen for command
    local name, _, _, _, _, command = computer.pullSignal()

    if name == "modem_message" then
      -- Tell sender command was recieved
      modem.broadcast(1, "recieved")
      
      -- Create command and run it
      command, err = load(command)
      if err == nil then
        -- Command loaded properly, run command
        ranProperly, result = pcall(command)
        
        if ranProperly then
          -- Command ran properly, show on drone
          drone.setStatusText("ran")
        else
          -- Command didn't run, show on drone
          drone.setStatusText("Didnt run")
        end
        
        -- Send result back to sender, could be an error message
        modem.broadcast(1, ranProperly, result)
      else
        -- Command loaded incorrectly, tell sender
        drone.setStatusText("Didnt load")
        modem.broadcast(1, false, err)
      end
    end
  end
else
  error("Couldn't open port")  
end
