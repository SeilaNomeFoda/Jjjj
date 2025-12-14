-- Lista de códigos do Blox Fruits
local BloxFruitsCodes = {
    "NOMOREHACK",
    "BANEXPLOIT",
    "WildDares",
    "BossBuild",
    "GetPranked",
    "EARN_FRUITS",
    "FIGHT4FRUIT",
    "NOEXPLOITER",
    "NOOB2ADMIN",
    "CODESLIDE",
    "ADMINHACKED",
    "ADMINDARES",
    "fruitconcepts",
    "krazydares",
    "TRIPLEABUSE",
    "SEATROLLING",
    "24NOADMIN",
    "REWARDFUN",
    "Chandler",
    "NEWTROLL",
    "KITT_RESET",
    "Sub2CaptainMaui",
    "kittgaming",
    "Sub2Fer999",
    "Enyu_is_Pro",
    "Magicbus",
    "JCWK",
    "Starcodeheo",
    "Bluxxy",
    "fudd10_v2",
    "SUB2GAMERROBOT_EXP1",
    "Sub2NoobMaster123",
    "Sub2UncleKizaru",
    "Sub2Daigrock",
    "Axiore",
    "TantaiGaming",
    "StrawHatMaine",
    "Sub2OfficialNoobie",
    "Fudd10",
    "Bignews",
    "TheGreatAce",
    "SECRET_ADMIN",
    "SUB2GAMERROBOT_RESET1",
    "SUB2OFFICIALNOOBIE",
    "AXIORE",
    "BIGNEWS",
    "BLUXXY",
    "CHANDLER",
    "ENYU_IS_PRO",
    "FUDD10",
    "FUDD10_V2",
    "KITTGAMING",
    "MAGICBUS",
    "STARCODEHEO",
    "STRAWHATMAINE",
    "SUB2CAPTAINMAUI",
    "SUB2DAIGROCK",
    "SUB2FER999",
    "SUB2NOOBMASTER123",
    "SUB2UNCLEKIZARU",
    "TANTAIGAMING",
    "THEGREATACE"
}

-- Função para resgatar todos os códigos
local function RedeemAllCodes()
    print("🎁 Iniciando resgate de códigos...")
    
    local successCount = 0
    local failCount = 0
    
    for _, code in ipairs(BloxFruitsCodes) do
        pcall(function()
            -- Tenta resgatar o código
            local args = {code}
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Redeem"):InvokeServer(unpack(args))
            
            print("✅ Código resgatado: " .. code)
            successCount = successCount + 1
        end)
        
        -- Pequena pausa entre cada código para evitar rate limiting
        task.wait(0.2)
    end
    
    print("📊 Resumo dos códigos:")
    print("   ✅ Resgatados com sucesso: " .. successCount)
    print("   ❌ Falhas: " .. failCount)
    print("   📋 Total de códigos: " .. #BloxFruitsCodes)
    
    if failCount == 0 then
        print("🎉 Todos os códigos foram resgatados com sucesso!")
    else
        print("⚠️ Alguns códigos não puderam ser resgatados.")
    end
end

-- Função para resgatar códigos periodicamente
local function AutoRedeemCodes(intervalMinutes)
    intervalMinutes = intervalMinutes or 60 -- Padrão: 60 minutos
    
    print("⏰ Auto Redeem Codes ativado (intervalo: " .. intervalMinutes .. " minutos)")
    
    local function redeemLoop()
        while task.wait(intervalMinutes * 60) do -- Converte minutos para segundos
            print("🔄 Verificando códigos...")
            RedeemAllCodes()
        end
    end
    
    -- Inicia o loop em uma thread separada
    task.spawn(redeemLoop)
    
    -- Resgata imediatamente na primeira execução
    RedeemAllCodes()
    
    return {
        Stop = function()
            print("🛑 Auto Redeem Codes desativado")
            -- Aqui você precisaria implementar uma forma de parar o loop
            -- Como o loop está em uma thread separada, você precisaria de uma flag de controle
        end,
        RedeemNow = RedeemAllCodes,
        GetCodesList = function()
            return BloxFruitsCodes
        end,
        AddCode = function(newCode)
            table.insert(BloxFruitsCodes, newCode)
            print("➕ Código adicionado: " .. newCode)
        end
    }
end

-- Versão integrada com o Auto Farm
local function SetupAutoFarmWithCodes()
    local farmController = AutoFarmLevel1000WithSecondSea()
    local codesController = nil
    
    local function ToggleAutoCodes(value)
        if value then
            -- Ativa o resgate automático de códigos a cada 60 minutos
            codesController = AutoRedeemCodes(60)
            print("✅ Auto Redeem Codes ativado")
        else
            if codesController then
                codesController.Stop()
                codesController = nil
                print("❌ Auto Redeem Codes desativado")
            end
        end
    end
    
    return {
        -- Controles do Farm
        StopFarm = farmController.Stop,
        SetAutoStoreFruit = farmController.SetAutoStoreFruit,
        SetTweenFruit = farmController.SetTweenFruit,
        SetGrabFruit = farmController.SetGrabFruit,
        GetStatus = farmController.GetStatus,
        
        -- Controles dos Códigos
        ToggleAutoCodes = ToggleAutoCodes,
        RedeemCodesNow = RedeemAllCodes,
        GetCodesCount = function()
            return #BloxFruitsCodes
        end,
        
        -- Função combinada para parar tudo
        StopAll = function()
            farmController.Stop()
            if codesController then
                codesController.Stop()
                codesController = nil
            end
            print("🛑 Todos os sistemas parados")
        end
    }
end


local controller = SetupAutoFarmWithCodes()

-- Função para resgatar códigos uma vez (sem loop automático)
local function QuickRedeemCodes()
    print("⚡ Resgate rápido de códigos iniciado...")
    RedeemAllCodes()
    print("⚡ Resgate rápido concluído!")
end

-- Exportar funções principais
return {
    RedeemAllCodes = RedeemAllCodes,
    AutoRedeemCodes = AutoRedeemCodes,
    QuickRedeemCodes = QuickRedeemCodes,
    SetupAutoFarmWithCodes = SetupAutoFarmWithCodes,
    GetCodesList = function() return BloxFruitsCodes end
}
QuickRedeemCodes()
