-------------------------------------------------------------------------------
-- Properties
-------------------------------------------------------------------------------

local function floorArray(tbl)
    for i = 1, #tbl do
        tbl[i] = math.floor(tbl[i])
    end
    return tbl
end

local function propTypeToString(propType)
    local str = 'unknown'
    if propType == TYPE_INT then str = 'integer'
    elseif propType == TYPE_FLOAT then str = 'float'
    elseif propType == TYPE_DOUBLE then str = 'double'
    elseif propType == TYPE_STRING then str = 'string'
    elseif propType == TYPE_INT_ARRAY then str = 'int array'
    elseif propType == TYPE_FLOAT_ARRAY then str = 'float array'
    end
    return str
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Convert values from table to properties.
--- @param arguments table
--- @return table
function private.argumentsToProperties(arguments)
    local res = {}
    for k, v in pairs(arguments) do
        if type(v) == "function" then
            res[k] = v
        else
            if isProperty(v) then
                res[k] = v
            else
                res[k] = createProperty(v)
            end
        end
    end
    return res
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class Property
--- @field v any

--- @class GlobalProperty
--- @field name string
--- @field get fun(self:GlobalProperty, offset:number, numValues:number):any
--- @field set fun(self:GlobalProperty, value:any, offset:number, numValues:number)
--- @field size fun():number
--- @field free fun()
--- @field raw fun():userdata

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates new property with initial value.
--- @param value any
--- @return Property
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createProperty
function createProperty(value)
    if isProperty(value) then
        return value
    end
    return { __p = 1, v = value }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Checks if value is a property table.
--- @param value any
--- @return boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#isProperty
function isProperty(value)
    return type(value) == "table" and value.__p
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns value of property, traversing recursively.
--- @param property Property | GlobalProperty | function
--- @param offset number
--- @param numValues number
--- @overload fun(property:Property | GlobalProperty | function):any
--- @overload fun(property:Property | GlobalProperty | function, offset:number):any
--- @return any
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#get
function get(property, offset, numValues)
    if isProperty(property) then
        if property.get then
            return property:get(offset, numValues)
        else
            if isProperty(property.v) then
                return get(property.v, offset, numValues)
            else
                return property.v
            end
        end
    else
        if type(property) == "function" then
            return property()
        else
            return property
        end
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Sets value of property, traversing recursively.
--- @param property Property | GlobalProperty
--- @param value any
--- @param offset number
--- @param numValues number
--- @overload fun(property:Property | GlobalProperty, value:any)
--- @overload fun(property:Property | GlobalProperty, value:any, offset:number):any
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#set
function set(property, value, offset, numValues)
    if isProperty(property) then
        if property.set then
            property:set(value, offset, numValues)
        else
            if isProperty(property.v) then
                set(property.v, value, offset, numValues)
            else
                property.v = value
            end
        end
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns global sim property (dataref), retrieving type automatically.
--- @param name string
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#globalProperty
function globalProperty(name)
    local ref, t = sasl.findDataRef(name, TYPE_UNKNOWN, true)
    local index
    if not ref then
        local sname, sindex = string.match(name, '(.+)%[(%d+)%]$')
        if sname and sindex then
            ref, t = sasl.findDataRef(sname, TYPE_UNKNOWN, true)
            index = tonumber(sindex)
        end
        if not ref then
            sasl.findDataRef(name, TYPE_UNKNOWN)
            return nil
        end
    end

    local get, set
    local size = function() return sasl.getDataRefSize(ref) end
    if t == TYPE_INT_ARRAY or t == TYPE_FLOAT_ARRAY or t == TYPE_STRING then
        if index then
            get = function(_) return sasl.getDataRef(ref, index + 1, nil) end
            set = function(_, value) sasl.setDataRef(ref, value, index + 1, nil) end
            size = function() return 1 end
        else
            get = function(_, offset, numValues) return sasl.getDataRef(ref, offset, numValues) end
            set = function(_, value, offset, numValues) sasl.setDataRef(ref, value, offset, numValues) end
        end
    else
        get = function(_) return sasl.getDataRef(ref) end
        set = function(_, value) sasl.setDataRef(ref, value) end
    end

    return {
        __p = 1;
        name = name;
        get = get;
        set = set;
        size = size;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns global sim property (dataref) of type double.
--- @param name string
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#globalProperty
function globalPropertyd(name)
    local ref, t = sasl.findDataRef(name, TYPE_DOUBLE)
    if not ref then
        return nil
    end
    local get, set

    if t == TYPE_FLOAT or t == TYPE_DOUBLE or t == TYPE_INT then
        get = function(_) return sasl.getDataRef(ref) end
        set = function(_, value) sasl.setDataRef(ref, value) end
    elseif t == TYPE_STRING then
        get = function(_) return 0 end
        set = function(_, value) sasl.setDataRef(ref, tostring(value), nil, nil) end
        logDebug('"'..name..'": '.."Casting string to double")
    else
        logWarning('"'..name..'": '.."Can't cast "..propTypeToString(t).." to double")
        return nil
    end

    return {
        __p = 1;
        name = name;
        get = get;
        set = set;
        size = function() return 1 end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates new sim property (dataref) of type double.
--- @param name string
--- @param default number
--- @param isNotPublished boolean
--- @param isShared boolean
--- @param isReadOnly boolean
--- @overload fun(name:string):GlobalProperty
--- @overload fun(name:string, default:number):GlobalProperty
--- @overload fun(name:string, default:number, isNotPublished:boolean):GlobalProperty
--- @overload fun(name:string, default:number, isNotPublished:boolean, isShared:boolean):GlobalProperty
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createGlobalProperty
function createGlobalPropertyd(name, default, isNotPublished, isShared, isReadOnly)
    local ref = sasl.createDataRef(name, TYPE_DOUBLE, isNotPublished or false, isShared or false, isReadOnly or false)
    if default ~= nil then sasl.setDataRef(ref, default) elseif isShared then sasl.setDataRef(ref, 0) end
    return {
        __p = 1;
        name = name;
        get = function(_) return sasl.getDataRef(ref) end;
        set = function(_, value) sasl.setDataRef(ref, value) end;
        size = function() return 1 end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates new functional sim property (dataref) of type double.
--- @param name string
--- @param getter fun():number
--- @param setter fun(v:number)
--- @param isNotPublished boolean
--- @overload fun(name:string, getter:function, setter:function)
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createFunctionalProperty
function createFunctionalPropertyd(name, getter, setter, isNotPublished)
    local ref = sasl.createFunctionalDataRef(name, TYPE_DOUBLE, getter, setter, isNotPublished or false)
    return {
        __p = 1;
        name = name;
        get = function(_) return sasl.getDataRef(ref) end;
        set = function(_, value) sasl.setDataRef(ref, value) end;
        size = function() return 1 end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns global sim property (dataref) of type float.
--- @param name string
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#globalProperty
function globalPropertyf(name)
    local ref, t = sasl.findDataRef(name, TYPE_FLOAT)
    if not ref then
        return nil
    end
    local get, set

    if t == TYPE_FLOAT or t == TYPE_DOUBLE or t == TYPE_INT then
        get = function(_) return sasl.getDataRef(ref) end
        set = function(_, value) sasl.setDataRef(ref, value) end
    elseif t == TYPE_STRING then
        get = function(_) return 0 end
        set = function(_, value) sasl.setDataRef(ref, tostring(value), nil, nil) end
        logDebug('"'..name..'": '.."Casting string to float")
    else
        logWarning('"'..name..'": '.."Can't cast "..propTypeToString(t).." to float")
        return nil
    end

    return {
        __p = 1;
        name = name;
        get = get;
        set = set;
        size = function() return 1 end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates new sim property (dataref) of type float.
--- @param name string
--- @param default number
--- @param isNotPublished boolean
--- @param isShared boolean
--- @param isReadOnly boolean
--- @overload fun(name:string):GlobalProperty
--- @overload fun(name:string, default:number):GlobalProperty
--- @overload fun(name:string, default:number, isNotPublished:boolean):GlobalProperty
--- @overload fun(name:string, default:number, isNotPublished:boolean, isShared:boolean):GlobalProperty
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createGlobalProperty
function createGlobalPropertyf(name, default, isNotPublished, isShared, isReadOnly)
    local ref = sasl.createDataRef(name, TYPE_FLOAT, isNotPublished or false, isShared or false, isReadOnly or false)
    if default ~= nil then sasl.setDataRef(ref, default) elseif isShared then sasl.setDataRef(ref, 0) end
    return {
        __p = 1;
        name = name;
        get = function(_) return sasl.getDataRef(ref) end;
        set = function(_, value) sasl.setDataRef(ref, value) end;
        size = function() return 1 end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates new functional sim property (dataref) of type float.
--- @param name string
--- @param getter fun():number
--- @param setter fun(v:number)
--- @param isNotPublished boolean
--- @overload fun(name:string, getter:function, setter:function)
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createFunctionalProperty
function createFunctionalPropertyf(name, getter, setter, isNotPublished)
    local ref = sasl.createFunctionalDataRef(name, TYPE_FLOAT, getter, setter, isNotPublished or false)
    return {
        __p = 1;
        name = name;
        get = function(_) return sasl.getDataRef(ref) end;
        set = function(_, value) sasl.setDataRef(ref, value) end;
        size = function() return 1 end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns global sim property (dataref) of type int.
--- @param name string
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#globalProperty
function globalPropertyi(name)
    local ref, t = sasl.findDataRef(name, TYPE_INT)
    if not ref then
        return nil
    end
    local get, set

    if t == TYPE_INT then
        get = function(_) return sasl.getDataRef(ref) end
        set = function(_, value) sasl.setDataRef(ref, value) end
    elseif t == TYPE_FLOAT or t == TYPE_DOUBLE then
        get = function(_) return math.floor(sasl.getDataRef(ref)) end
        set = function(_, value) sasl.setDataRef(ref, math.floor(value)) end
        logDebug('"'..name..'": '.."Casting "..propTypeToString(t).." to int")
    elseif t == TYPE_STRING then
        get = function(_) return 0 end
        set = function(_, value) sasl.setDataRef(ref, tostring(value), nil, nil) end
        logDebug('"'..name..'": '.."Casting string to int")
    else
        logWarning('"'..name..'": '.."Can't cast "..propTypeToString(t).." to int")
        return nil
    end

    return {
        __p = 1;
        name = name;
        get = get;
        set = set;
        size = function() return 1 end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates new sim property (dataref) of type int.
--- @param name string
--- @param default number
--- @param isNotPublished boolean
--- @param isShared boolean
--- @param isReadOnly boolean
--- @overload fun(name:string):GlobalProperty
--- @overload fun(name:string, default:number):GlobalProperty
--- @overload fun(name:string, default:number, isNotPublished:boolean):GlobalProperty
--- @overload fun(name:string, default:number, isNotPublished:boolean, isShared:boolean):GlobalProperty
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createGlobalProperty
function createGlobalPropertyi(name, default, isNotPublished, isShared, isReadOnly)
    local ref = sasl.createDataRef(name, TYPE_INT, isNotPublished or false, isShared or false, isReadOnly or false)
    if default ~= nil then sasl.setDataRef(ref, default) elseif isShared then sasl.setDataRef(ref, 0) end
    return {
        __p = 1;
        name = name;
        get = function(_) return sasl.getDataRef(ref) end;
        set = function(_, value) sasl.setDataRef(ref, value) end;
        size = function() return 1 end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates new functional sim property (dataref) of type int.
--- @param name string
--- @param getter fun():number
--- @param setter fun(v:number)
--- @param isNotPublished boolean
--- @overload fun(name:string, getter:function, setter:function)
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createFunctionalProperty
function createFunctionalPropertyi(name, getter, setter, isNotPublished)
    local ref = sasl.createFunctionalDataRef(name, TYPE_INT, getter, setter, isNotPublished or false)
    return {
        __p = 1;
        name = name;
        get = function(_) return sasl.getDataRef(ref) end;
        set = function(_, value) sasl.setDataRef(ref, value) end;
        size = function() return 1 end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns global sim property (dataref) of type string.
--- @param name string
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#globalProperty
function globalPropertys(name)
    local ref, t = sasl.findDataRef(name, TYPE_STRING)
    if not ref then
        return nil
    end
    local get, set

    if t == TYPE_STRING then
        get = function(_, offset, numValues) return sasl.getDataRef(ref, offset, numValues) end
        set = function(_, value, offset, numValues) sasl.setDataRef(ref, value, offset, numValues) end
    elseif t == TYPE_FLOAT or t == TYPE_INT or t == TYPE_DOUBLE then
        get = function(_) return tostring(sasl.getDataRef(ref, nil, nil)) end
        set = function(_) end
        logDebug('"'..name..'": '.."Casting "..propTypeToString(t).." to string. Partial <get> and <set> aren't available")
    else
        logWarning('"'..name..'": '.."Can't cast "..propTypeToString(t).." to string")
        return nil
    end

    return {
        __p = 1;
        name = name;
        get = get;
        set = set;
        size = function() return sasl.getDataRefSize(ref) end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates new sim property (dataref) of type string.
--- @param name string
--- @param default string
--- @param isNotPublished boolean
--- @param isShared boolean
--- @param isReadOnly boolean
--- @overload fun(name:string):GlobalProperty
--- @overload fun(name:string, default:string):GlobalProperty
--- @overload fun(name:string, default:string, isNotPublished:boolean):GlobalProperty
--- @overload fun(name:string, default:string, isNotPublished:boolean, isShared:boolean):GlobalProperty
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createGlobalProperty
function createGlobalPropertys(name, default, isNotPublished, isShared, isReadOnly)
    local ref = sasl.createDataRef(name, TYPE_STRING, isNotPublished or false, isShared or false, isReadOnly or false)
    if default ~= nil then
        sasl.setDataRef(ref, default, nil, nil)
    elseif isShared then
        sasl.setDataRef(ref, '', nil, nil)
    end
    return {
        __p = 1;
        name = name;
        get = function(_, offset, numValues) return sasl.getDataRef(ref, offset, numValues) end;
        set = function(_, value, offset, numValues) sasl.setDataRef(ref, value, offset, numValues) end;
        size = function() return sasl.getDataRefSize(ref) end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates new functional sim property (dataref) of type string.
--- @param name string
--- @param getter fun(offset:number, numValues:number):string
--- @param setter fun(v:string, offset:number)
--- @param isNotPublished boolean
--- @param sizeGetter fun():number
--- @overload fun(name:string, getter:function, setter:function)
--- @overload fun(name:string, getter:function, setter:function, isNotPublished:boolean)
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createFunctionalProperty
function createFunctionalPropertys(name, getter, setter, isNotPublished, sizeGetter)
    local ref = sasl.createFunctionalDataRef(name, TYPE_STRING, getter, setter, isNotPublished or false, sizeGetter or 0)
    return {
        __p = 1;
        name = name;
        get = function(_, offset, numValues) return sasl.getDataRef(ref, offset, numValues) end;
        set = function(_, value, offset, numValues) sasl.setDataRef(ref, value, offset, numValues) end;
        size = function() return sasl.getDataRefSize(ref); end;
        free = function() sasl.freeDataRef(ref); end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns global sim property (dataref) of type int array.
--- @param name string
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#globalProperty
function globalPropertyia(name)
    local ref, t = sasl.findDataRef(name, TYPE_INT_ARRAY)
    if not ref then
        return nil
    end
    local get, set

    if t == TYPE_INT_ARRAY then
        get = function(_, offset, numValues)
            return sasl.getDataRef(ref, offset, numValues)
        end
        set = function(_, value, offset, numValues)
            sasl.setDataRef(ref, value, offset, numValues)
        end
    elseif t == TYPE_FLOAT_ARRAY then
        get = function(_, offset, numValues)
            return floorArray(sasl.getDataRef(ref, offset, numValues))
        end
        set = function(_, value, offset, numValues)
            sasl.setDataRef(ref, floorArray(value), offset, numValues)
        end
        logDebug('"'..name..'": '.."Casting float array to int array")
    else
        logWarning('"'..name..'": '.."Can't cast "..propTypeToString(t).." to int array")
        return nil
    end

    return {
        __p = 1;
        name = name;
        get = get;
        set = set;
        size = function() return sasl.getDataRefSize(ref) end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns global sim property (dataref) bound to int array element.
--- @param name string
--- @param index number
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#globalProperty
function globalPropertyiae(name, index)
    local ref, t = sasl.findDataRef(name, TYPE_INT_ARRAY)
    if not ref then
        return nil
    end
    local get, set
    if t == TYPE_INT_ARRAY then
        get = function(_) return sasl.getDataRef(ref, index, nil) end
        set = function(_, value) sasl.setDataRef(ref, value, index, nil) end
    elseif t == TYPE_FLOAT_ARRAY then
        get = function(_) return math.floor(sasl.getDataRef(ref, index, nil)) end
        set = function(_, value) sasl.setDataRef(ref, math.floor(value), index, nil) end
        logDebug('"'..name..'": '.."Casting float array element to int array element")
    else
        logWarning('"'..name..'": '.."Can't cast "..propTypeToString(t).." to int array element")
        return nil
    end

    return {
        __p = 1;
        name = name;
        get = get;
        set = set;
        size = function() return 1 end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates new sim property (dataref) of type int array.
--- @param name string
--- @param default table | number
--- @param isNotPublished boolean
--- @param isShared boolean
--- @param isReadOnly boolean
--- @overload fun(name:string):GlobalProperty
--- @overload fun(name:string, default:table | number):GlobalProperty
--- @overload fun(name:string, default:table | number, isNotPublished:boolean):GlobalProperty
--- @overload fun(name:string, default:table | number, isNotPublished:boolean, isShared:boolean):GlobalProperty
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createGlobalProperty
function createGlobalPropertyia(name, default, isNotPublished, isShared, isReadOnly)
    local ref = sasl.createDataRef(name, TYPE_INT_ARRAY, isNotPublished or false, isShared or false, isReadOnly or false)
    if default ~= nil then
        if type(default) == 'number' and default > 0 then
            local initializer = {}
            for i = 1, default do
                initializer[i] = 0
            end
            sasl.setDataRef(ref, initializer, nil, nil)
        else
            sasl.setDataRef(ref, default, nil, nil)
        end
    end

    return {
        __p = 1;
        name = name;
        get = function(_, offset, numValues)
            return sasl.getDataRef(ref, offset, numValues)
        end;
        set = function(_, value, offset, numValues)
            sasl.setDataRef(ref, value, offset, numValues)
        end;
        size = function() return sasl.getDataRefSize(ref) end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates new functional sim property (dataref) of type int array.
--- @param name string
--- @param getter fun(offset:number, numValues:number):table
--- @param setter fun(v:table, offset:number)
--- @param isNotPublished boolean
--- @param sizeGetter fun():number
--- @overload fun(name:string, getter:function, setter:function)
--- @overload fun(name:string, getter:function, setter:function, isNotPublished:boolean)
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createFunctionalProperty
function createFunctionalPropertyia(name, getter, setter, isNotPublished, sizeGetter)
    local ref = sasl.createFunctionalDataRef(name, TYPE_INT_ARRAY, getter, setter, isNotPublished or false, sizeGetter or 0)
    return {
        __p = 1;
        name = name;
        get = function(_, offset, numValues)
            return sasl.getDataRef(ref, offset, numValues)
        end;
        set = function(_, value, offset, numValues)
            sasl.setDataRef(ref, value, offset, numValues)
        end;
        size = function() return sasl.getDataRefSize(ref) end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns global sim property (dataref) of type float array.
--- @param name string
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#globalProperty
function globalPropertyfa(name)
    local ref, t = sasl.findDataRef(name, TYPE_FLOAT_ARRAY)
    if not ref then
        return nil
    end
    local get, set

    if t == TYPE_FLOAT_ARRAY or t == TYPE_INT_ARRAY then
        get = function(_, offset, numValues)
            return sasl.getDataRef(ref, offset, numValues)
        end
        set = function(_, value, offset, numValues)
            sasl.setDataRef(ref, value, offset, numValues)
        end
    else
        logWarning('"'..name..'": '.."Can't cast "..propTypeToString(t).." to float array")
        return nil
    end

    return {
        __p = 1;
        name = name;
        get = get;
        set = set;
        size = function() return sasl.getDataRefSize(ref) end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns global sim property (dataref) bound to float array element.
--- @param name string
--- @param index number
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#globalProperty
function globalPropertyfae(name, index)
    local ref, t = sasl.findDataRef(name, TYPE_FLOAT_ARRAY)
    if not ref then
        return nil
    end
    local get, set

    if t == TYPE_FLOAT_ARRAY or t == TYPE_INT_ARRAY then
        get = function(_) return sasl.getDataRef(ref, index, nil) end
        set = function(_, value) sasl.setDataRef(ref, value, index, nil) end
    else
        logWarning('"'..name..'": '.."Can't cast "..propTypeToString(t).." to float array element")
    end

    return {
        __p = 1;
        name = name;
        get = get;
        set = set;
        size = function() return 1 end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates new sim property (dataref) of type float array.
--- @param name string
--- @param default table | number
--- @param isNotPublished boolean
--- @param isShared boolean
--- @param isReadOnly boolean
--- @overload fun(name:string):GlobalProperty
--- @overload fun(name:string, default:table | number):GlobalProperty
--- @overload fun(name:string, default:table | number, isNotPublished:boolean):GlobalProperty
--- @overload fun(name:string, default:table | number, isNotPublished:boolean, isShared:boolean):GlobalProperty
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createGlobalProperty
function createGlobalPropertyfa(name, default, isNotPublished, isShared, isReadOnly)
    local ref = sasl.createDataRef(name, TYPE_FLOAT_ARRAY, isNotPublished or false, isShared or false, isReadOnly or false)
    if default ~= nil then
        if type(default) == 'number' and default > 0 then
            local initializer = {}
            for i = 1, default do
                initializer[i] = 0
            end
            sasl.setDataRef(ref, initializer, nil, nil)
        else
            sasl.setDataRef(ref, default, nil, nil)
        end
    end

    return {
        __p = 1;
        name = name;
        get = function(_, offset, numValues)
            return sasl.getDataRef(ref, offset, numValues)
        end;
        set = function(_, value, offset, numValues)
            sasl.setDataRef(ref, value, offset, numValues)
        end;
        size = function() return sasl.getDataRefSize(ref) end;
        free = function() sasl.freeDataRef(ref) end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates new functional sim property (dataref) of type float array.
--- @param name string
--- @param getter fun(offset:number, numValues:number):table
--- @param setter fun(v:table, offset:number)
--- @param isNotPublished boolean
--- @param sizeGetter fun():number
--- @overload fun(name:string, getter:function, setter:function)
--- @overload fun(name:string, getter:function, setter:function, isNotPublished:boolean)
--- @return GlobalProperty
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createFunctionalProperty
function createFunctionalPropertyfa(name, getter, setter, isNotPublished, sizeGetter)
    local ref = sasl.createFunctionalDataRef(name, TYPE_FLOAT_ARRAY, getter, setter, isNotPublished or false, sizeGetter or 0)
    return {
        __p = 1;
        name = name;
        get = function(_, offset, numValues)
            return sasl.getDataRef(ref, offset, numValues)
        end;
        set = function(_, value, offset, numValues)
            sasl.setDataRef(ref, value, offset, numValues)
        end;
        size = function() return sasl.getDataRefSize(ref); end;
        free = function() sasl.freeDataRef(ref); end;
        raw = function() return sasl.getRawDataRef(ref) end;
    }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
