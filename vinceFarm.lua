
local function sowField()
-- assume it starts at the leftmost field, at the left bottom corner, facing away from the base.

    for i=1,3 do
        for j=1,8 do
            turtle.placeDown()
            turtle.suckDown()
            
            if j ~= 8 then
                turtle.forward()
            end
        end
        
        turtle.placeDown()
        turtle.suckDown()

        if i == 1 then
            turtle.turnRight()
            turtle.forward()
            turtle.turnRight()
        end
        if i == 2 then
            turtle.turnLeft()
            turtle.forward()
            turtle.turnLeft()
        end
    end

-- ends at the top right corner, facing away from the base
end

local function cleanPickUp() 
    for i=1,3 do
        for j=1,8 do
            turtle.suckDown()
            if j ~= 8 then
                turtle.back()
            end
        end
        
        if i == 1 then
            turtle.turnRight()
            turtle.back()
            turtle.turnRight()
        end
        if i == 2 then
            turtle.turnLeft()
            turtle.back()
            turtle.turnLeft()
        end
    end
end

local function dumpChest()
    -- start at the bottom left corner, facing away from the base
    turtle.back()


    -- facing away from base, chest one step to the right
    turtle.turnRight()
    turtle.forward()

    -- right over chest
    -- fuel always on 1
    for j = 2,16 do
        if turtle.getItemCount(j) > 0 then
            turtle.select(j)
            turtle.dropDown()
        end
    end
    turtle.select(1)

-- stops on the chest
end

local function nextField()
-- begin on chest facing next field

    for j=1,3 do
        turtle.forward()
    end
    turtle.turnLeft()
    turtle.forward()

-- end at next field, bottom left corner, facing away from base

end




local function restart()
-- now at the next field, but want to go back
    turtle.turnLeft()
    for j=1,20 do
        turtle.forward()
    end
    turtle.turnRight()
-- stops on the first field
end


print( "Press any key to stop the sowing after this cycle." )

local bEnd = false
local start = false
local coalCount = turtle.getItemCount(1)
parallel.waitForAll(
    function()
        while not bEnd do
            local event, key = os.pullEvent("key")
            if key ~= keys.escape then
                bEnd = true
            end
        end        
    end,
    function()
        while not bEnd do
            print("Place some type of coal into slot 1 (needs more than 19 to start)")
            
            -- keep on getting the coal until enough
            if not start then
                while coalCount < 20 do
                    coalCount = turtle.getItemCount(1)
                    sleep(5)
                end
                start = true
            end

            coalCount = turtle.getItemCount(1)
            if coalCount < 20 then
                -- goto chest and get coal
                turtle.turnLeft()
                turtle.forward()
                turtle.suckDown(44) 

                -- keep on getting the coal until enough
                while coalCount < 20 do
                    turtle.suckDown(44) 
                    coalCount = turtle.getItemCount(1)
                end

                -- return to position
                turtle.back()
                turtle.turnRight()

            end
            for i=1,5 do
                if turtle.getFuelLevel() < 250 then 
                    shell.run("refuel", "4")
                end
                print("Running field #", i)
                sowField()
                cleanPickUp()
                dumpChest()
                nextField()
            end
            restart()
            print("Sleeping for 10 minutes.")
            sleep(600)
        end
    end
)

