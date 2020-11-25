sInput = nil
local modem = peripheral.wrap("top")
modem.open(123)  -- Open channel 123 so that we can listen on it

while true do
   sInput = read()
   if sInput == "exit" then
         break -- Break out of the infinite loop
          -- Monitor code goes here
   end
    
   modem.transmit(3, 123, sInput)
   print("The message was: "..sInput)
end