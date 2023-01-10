--[[

 - Version: 0.1
 Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
SPDX-License-Identifier: Apache-2.0
 - Made by Tom Tuning @ 2022
 
 - Mail: tom.tuning@sas.com

******************
 - INFORMATION
******************

  -- misc helper functions for lua strings
  
  usage: 
  
     local ttstrings = require ("/mnt/viya-share/lua/totuni/TTstrings")  -- general string functions
     local TTstr = ttstrings:new()  -- create instance 
  
  
--]]
----------------------------------------------------------------------------------------------------
------------------
-- Constants
------------------
--------------------------
--  Local Functions
--------------------------

------------------
-- Modules
------------------
local M = {}
local M_mt = { __index = M }


-- return new object
function M:new( )
	print ("string functions")
    local self = {}
    setmetatable( self, M_mt )  --  new object inherits from RF 
    return self

end

--  delete this object 
function M:destroy()

	self = nil
    return

end

 
function M:splitbydelimiter( 
    s,   -- string value
    delimiter,  -- string value with defines the delimiter. default is ","
    item )   -- number:  item in array to return.  Let's say you want the 3rd item parsed from string  "item1,item2,item3"
             --  if you say 2 item2 will be returned.  Note that Lua arrays start at 1 and not 0.  
    -- returns table of split items or item entry 
    answer = {};
    delimiter1 = delimiter or ","
    for x in string.gmatch(s,"(.-)"..delimiter1) do
        table.insert(answer, x);
    end
    if #answer == 0 then result = nil    -- return nil if nothing found. 
    elseif item then  -- does the user want an entry verses a parsed table?
        if #answer >= item then 
            result = answer[item]
        else result = nil     
        end 
    else  result = answer    
    end 
return result;
end



-- This doesn't actually generate the correct epoch time.  To lazy to debug.  It is close enough until SS5 is built.  
---Parse an RFC 3339 datetime at the given position
-- Returns a utc epoch, time table and the `tz_offset`
-- Return value is not normalised (this preserves a leap second)
-- If the timestamp is only partial (i.e. missing "Z" or time offset) then `tz_offset` will be nil
-- TODO: Validate components are within their boundarys (e.g. 1 <= month <= 12)
-- Pattern regex  https://riptutorial.com/lua/example/20315/lua-pattern-matching


function M:rfc_3339 ( 
    str ,  -- string to be parsed   ex:  ,2022-04-21T04:09:40.446853-05:00
    init ) -- number where to start matching 
    -- "2022-03-21T04:09:38.790768+00:00"
    local pattern = "^(%d%d%d%d)%-(%d%d)%-(%d%d)[Tt](%d%d%.?%d*):(%d%d):(%d%d%.?%d*)(.*)" 
	local year , month , day , hour , mins , sec , patt_end = string.match ( str, pattern, init )
    
    -- print (year , month , day , hour , mins , sec , patt_end)
	if not year then
		return nil, "Invalid RFC 3339 timestamp"
	end
    
    local tt = {}  
    
	tt["year"]  = tonumber ( year )
	tt["month"] = tonumber ( month )
	tt["day"]   = tonumber ( day )
	tt["hour"]  = tonumber ( hour )
	tt["min"]   = tonumber ( mins )
	tt["sec"] , tt["fractional"] =      math.modf (tonumber ( sec ))
    
    
	local tz_offset = nil
	if string.match ( patt_end, "[Zz]" ) then
		tz_offset = 0
	else
		local hour_offset , min_offset = string.match ( patt_end, "([+-]%d%d):(%d%d)"  )
		if hour_offset then
			tz_offset = tonumber ( hour_offset ) * 3600 + tonumber ( min_offset ) * 60
		else -- luacheck: ignore 542
			-- Invalid RFC 3339 timestamp offset (should be Z or (+/-)hour:min)
			-- tz_offset will be nil
		end
	end
    
    epoch = os.time(tt)
    epoch = epoch + tt["fractional"]
    
    
    if tz_offset then epoch = epoch + tz_offset end  -- adjust epoch if timezone was included.  Always return GTM

	return epoch , tt , tz_offset
end



-- “1.3f” means to print a float number with 3 decimal places.
function  M:string3Format( 
   value )   -- float     
   -- returns string formatted to 3 decimal places
	return string.format( "%1.3f", value )
end

return M

