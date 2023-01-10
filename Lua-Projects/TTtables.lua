--[[

 - Version: 0.1
 Copyright © 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
SPDX-License-Identifier: Apache-2.0
 - Made by Tom Tuning @ 2022
 
 - Mail: tom.tuning@sas.com

******************
 - INFORMATION
******************

  -- misc helper functions for lua tables
  
  usage: 
  
     local tttables = require ("/mnt/viya-share/lua/totuni/TTtables")  -- general table functions
     local TTtbl = tttables:new()  -- create instance 
  
  
--]]
----------------------------------------------------------------------------------------------------
------------------
-- Constants
------------------
--------------------------
--  Local Functions
--------------------------
-- tail recursion version of the print table function 
local function L_printtable (
   t)  -- table to print 
			print("misc:printtable", t )
			if type(t) == "table" then 
				print ("===== printing table =====", t )
				for k,v in pairs (t) do
					print ("key is ", k ," value ===", v , type(v))
					if type(v) == "table" then 
						-- print ("key is ", k ," value ===", v , type(v))
						L_printtable(v)  -- try a little fun with recursion 
						print ("===== completed table =====" , v )
					end
					
				end 
			end 
return
end	


------------------
-- Modules
------------------
local M = {}
local M_mt = { __index = M }

--------------------------
--  Local Functions
--------------------------

local function L_printtable (t)
			if type(t) == "table" then 
				print ("===== printing table =====", t )
				for k,v in pairs (t) do
					print ("key is ", k ," value ===", v , type(v))
					if type(v) == "table" then 
						-- print ("key is ", k ," value ===", v , type(v))
						L_printtable(v)  -- try a little fun with recursion 
						print ("===== completed table =====" , v )
					end
					
				end 
			end 
return
end	

function M:printtableRecursive( t )
	L_printtable(t)
return 
end

local success8 = false 
local function L_find_value_by_key (
   t ,  --   table address  
   key ) --  table key 
   -- return value from key for false 
			if type(t) == "table" then 
				for k,v in pairs (t) do
                    if k == key then success8 = v
					elseif type(v) == "table" then 
                      success8 = L_find_value_by_key(v , key )  -- recursively look down this table
					end
                  if success8 then break end 
				end 
			end 
return success8
end	

function M:find_value_by_key( t , k  )
    success8 = false 
    local answer = L_find_value_by_key(t, k )
return answer 
end


-- return new object
function M:new( )
	print ("misc functions")
    local self = {}
    setmetatable( self, M_mt )  --  new object inherits from RF 
    return self

end

--  delete this object 
function M:destroy()

	self = nil
    return

end

 
function M:printtable( t )
	L_printtable(t)
return 
end

--  hard code the depth to print. 
function M:printtableD(
   t ,       -- table:  address of table to be printed 
   depth)    -- integer:  depth to print table  Max of 4.  tables contain tables which contain tables.  
   -- returns nothing. prints to console 
   
	local dep  = depth or 2 
    if t then  -- do nothing if table is null
	 -- what have I done? 
		for k1, v1 in pairs( t ) do
			print ("Table1 key ", k1 ," value is ", v1 , type(v1))
			if dep > 1 then 
				if type(v1) == "table" then 
					for k2,v2 in pairs (v1) do	
						print ("---Table2 key ", k2 ," value is ", v2 , type(v2))
						if dep > 2 then 
							if type(v2) == "table" then 
								for k3,v3 in pairs (v2) do	
									print ("-----Table3 key ", k3 ," value is ", v3 , type(v3))
									if dep > 3 then 
										if type(v3) == "table" then 
											for k4,v4 in pairs (v3) do	
												print ("-------Table4 key ", k4 ," value is ", v4 , type(v4))
											end 
										end 
									end
								end 
							end 
						end
						
					end 
				end 
			end 
			 
		end
    else print ("Table was null")
    end 
	return 
	end 
	

--  set all entries in table to value by key 

function M:table_set_by_key(
key,       -- key of table 
value,     -- value to set 
t)         -- table name 
-- return true or error message 

    local key = key 
    local value = value
    local t = t
	local tableCount = #t
    local success = true 
			if tableCount > 0 then
				for i = tableCount, 1, -1 do
                    t[i][key] = value 
                end
            else success = "Error,  table_set_by_key:  table was empty "    
			end

return (success)
end 

--  delete all entries in table by value by key 
--  
function M:table_delete_by_key(
key,       -- key of table 
value,     -- value to delete 
t)         -- table name 
    local key = key 
    local value = value
    local t = t
	local tableCount = #t
    local success = false 
			if tableCount > 0 then
				for i = tableCount, 1, -1 do
					local Tentry = t[i]  -- table entry
                    if Tentry[key] == value  then 
                        table.remove(t , i)  --  we don't need to clear it because at 0 it clears itself.
                        success = true 
                    end     
                end
			end

return (success)
end 

function M:table_delete_by_value(value,t)
    local value = value
    local t = t
	local tableCount = #t
    local success = false 
			if tableCount > 0 then
				for i = tableCount, 1, -1 do
					local Tentry = t[i]  -- table entry
                    if Tentry == value  then 
                        table.remove(t , i)  
                        success = true 
                    end     
                end
			end

return (success)
end 

function M:table_find_by_key(key,value,t)
-- returns index of key field which contains value 
    
    local key = key 
    local value = value
    local t = t
	local tableCount = #t
    local success = false 
			if tableCount > 0 then
				for i = tableCount, 1, -1 do
					local Tentry = t[i]  -- table entry
                    if Tentry[key] == value  then
                        success = i 
                    end     
                end
			end
-- print ("Misc: table_find_by_key", key,value,t, "isFound = ", success )
return (success)
end 

-- update existing or add entry to table  
-- if found just delete and add to the same spot in table 
-- inserts a new entry to front of table.  

-- returns  updated entry number or false for new entry 
function M:table_update_by_key(k,v,t,e)
    local key = k
    local value = v
    local tt = t
    local entry = e
    -- print ("Misc: table_update_by_key", key,value,tt,entry)
    -- print ("Misc: table_update_by_key", Json.prettify(tt))
    local found = self:table_find_by_key(key,value,tt)
    if found then 
        -- print ("Misc: table_update_by_key found " , found )
        self:table_delete_by_key(key,value,tt)
        table.insert(tt,found,entry)
    else 
        table.insert(tt,1,entry) 
    end 
    -- print ("Misc: table_update_by_key after insert ", Json.prettify(tt))
return found 
end

-- “1.3f” means to print a float number with 3 decimal places.
function  M:string3Format( 
   value )   -- float     
   -- returns string formatted to 3 decimal places
	return string.format( "%1.3f", value )
end

return M
