--端末のモデルとピクセル高さを取得、条件に合うものは、isTallとする
local isTall = ("iPhone" == system.getInfo("model") or "iPod touch" == system.getInfo("model"))and (display.pixelHeight > 960)

--もし、isTallであれば次の処理
if(isTall)then
application = {
	content = {
		width = 320,
		height = 568, 
		scale = "letterBox",
		fps = 30,
		
		--[[
		imageSuffix = {
		    ["@2x"] = 2,
		}
		--]]
	},

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]
}

--もし、isTall以外であれば次の処理
else

--もともとconfig.luaに記述されている部分
application = {
	content = {
		width = 320,
		height = 480, 
		scale = "letterBox",
		fps = 30,
		
		--[[
		imageSuffix = {
		    ["@2x"] = 2,
		}
		--]]
	},

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}

--条件式を終了するendを追記
end
