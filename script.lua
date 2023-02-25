local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local toggle = false

function Script()
    local Window = Library.CreateLib("gekkefries hub", "Synapse")
    local Main = Window:NewTab("Main")
    local MainSection = Main:NewSection("Main")
    
    MainSection:NewToggle("Auto parry", "Auto parry", function(state)
        toggle = state
        if toggle then
            startAutoParry()
        else
            stopAutoParry()
        end
    end)

    function startAutoParry()
        local lp = game.Players.LocalPlayer
        local animationInfo = {}
         
        function getInfo(id)
          local success, info = pcall(function()
              return game:GetService("MarketplaceService"):GetProductInfo(id)
          end)
          if success then
              return info
          end
          return {Name=''}
        end
        function block(player)
          keypress(0x46)
          wait()
          keyrelease(0x46)
        end
         
        local AnimNames = {
          'Slash',
          'Swing',
          'Sword'
        }
         
        function playerAdded(v)
            local function charadded(char)
                local humanoid = char:WaitForChild("Humanoid", 5)
                if humanoid and toggle then -- check if toggle is true
                    humanoid.AnimationPlayed:Connect(function(track)
                        local info = animationInfo[track.Animation.AnimationId]
                        if not info then
                            info = getInfo(tonumber(track.Animation.AnimationId:match("%d+")))
                            animationInfo[track.Animation.AnimationId] = info
                        end
        
                        if (lp.Character and lp.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Head")) then
                            local mag = (v.Character.Head.Position - lp.Character.Head.Position).Magnitude
                            if mag < 14  then
        
                                for _, animName in pairs(AnimNames) do
                                    if info.Name:match(animName) then
                                        pcall(block, v)
                                    end
                                end
        
                            end
                        end
                    end)
                end
            end
        
            if v.Character then
                charadded(v.Character)
            end
            v.CharacterAdded:Connect(charadded)
        end

         
        for i,v in pairs(game.Players:GetPlayers()) do
           if v ~= lp then
               playerAdded(v)
           end
        end
         
        game.Players.PlayerAdded:Connect(playerAdded)
    end
    
    -- Function to stop auto parry
    function stopAutoParry()
        -- Add code to stop auto parry if needed
        print("Auto parry stopped")
    end

    -- Credits
    local Credits = Window:NewTab("Credits")
    local CreditsSection = Credits:NewSection("Credits")
    CreditsSection:NewLabel("Created by gekkefries#1101")
end

if game.PlaceId == 4282985734 then
    Script()
end
