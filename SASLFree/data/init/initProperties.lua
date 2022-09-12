--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Returns true if argument is property
function isProperty(value)
    return type(value) == "table" and value.__p
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Returns value of property
-- Traverse recursive properties
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

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Set value of property
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

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Convert values from table to properties
function argumentsToProperties(arguments)
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

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Create new property table
function createProperty(value)
    if isProperty(value) then
        return value
    end
    return { __p = 1, v = value }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Returns property (with automatically retrieved type)
function globalProperty(name)
    local ref, t = sasl.findDataRef(name, true)
    local index = nil
    if not ref then
        local sname, sindex = string.match(name, '(.+)%[(%d+)%]$')
        if sname and sindex then
            ref, t = sasl.findDataRef(sname, true)
            index = tonumber(sindex)
        end
        if not ref then
            sasl.findDataRef(name)
            return nil
        end
    end

    local get, set
    local size = function() return sasl.getDataRefSize(ref); end;
    if t == TYPE_INT_ARRAY or t == TYPE_FLOAT_ARRAY or t == TYPE_STRING then
        if index then
            get = function(self) return sasl.getDataRef(ref, index + 1, nil) end
            set = function(self, value) sasl.setDataRef(ref, value, index + 1, nil) end
            size = function() return 1 end
        else
            get = function(self, offset, numValues) return sasl.getDataRef(ref, offset, numValues); end
            set = function(self, value, offset, numValues) sasl.setDataRef(ref, value, offset, numValues); end
        end
    else
        get = function(self) return sasl.getDataRef(ref); end
        set = function(self, value) sasl.setDataRef(ref, value); end
    end

    return {
        __p = 1;
        name = name;
        get = get;
        set = set;
        size = size;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Returns double property
function globalPropertyd(name)
    local ref, t = sasl.findDataRef(name)
    if not ref then
        return nil
    end
    local get, set

    if t == TYPE_FLOAT or t == TYPE_DOUBLE or t == TYPE_INT then
        get = function(self) return sasl.getDataRef(ref); end
        set = function(self, value) sasl.setDataRef(ref, value); end
    elseif t == TYPE_STRING then
        get = function(self) return 0 end
        set = function(self, value) sasl.setDataRef(ref, tostring(value), nil, nil); end
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
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Create new double property and set default value
function createGlobalPropertyd(name, default, isNotPublished, isShared, isReadOnly)
    local ref = sasl.createDataRef(name, TYPE_DOUBLE, isNotPublished or false, isShared or false, isReadOnly or false)
    if default ~= nil then sasl.setDataRef(ref, default) elseif isShared then sasl.setDataRef(ref, 0) end
    return {
        __p = 1;
        name = name;
        get = function(self) return sasl.getDataRef(ref); end;
        set = function(self, value) sasl.setDataRef(ref, value); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Create new functional double property
function createFunctionalPropertyd(name, getter, setter, isNotPublished)
    local ref = sasl.createFunctionalDataRef(name, TYPE_DOUBLE, getter, setter, isNotPublished or false)
    return {
        __p = 1;
        name = name;
        get = function(self) return sasl.getDataRef(ref); end;
        set = function(self, value) sasl.setDataRef(ref, value); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Returns float property
function globalPropertyf(name)
    local ref, t = sasl.findDataRef(name)
    if not ref then
        return nil
    end
    local get, set

    if t == TYPE_FLOAT or t == TYPE_DOUBLE or t == TYPE_INT then
        get = function(self) return sasl.getDataRef(ref); end
        set = function(self, value) sasl.setDataRef(ref, value); end
    elseif t == TYPE_STRING then
        get = function(self) return 0 end
        set = function(self, value) sasl.setDataRef(ref, tostring(value), nil, nil); end
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
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Create new float property and set default value
function createGlobalPropertyf(name, default, isNotPublished, isShared, isReadOnly)
    local ref = sasl.createDataRef(name, TYPE_FLOAT, isNotPublished or false, isShared or false, isReadOnly or false)
    if default ~= nil then sasl.setDataRef(ref, default) elseif isShared then sasl.setDataRef(ref, 0) end
    return {
        __p = 1;
        name = name;
        get = function(self) return sasl.getDataRef(ref); end;
        set = function(self, value) sasl.setDataRef(ref, value); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Create new functional float property
function createFunctionalPropertyf(name, getter, setter, isNotPublished)
    local ref = sasl.createFunctionalDataRef(name, TYPE_FLOAT, getter, setter, isNotPublished or false)
    return {
        __p = 1;
        name = name;
        get = function(self) return sasl.getDataRef(ref); end;
        set = function(self, value) sasl.setDataRef(ref, value); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Returns int property
function globalPropertyi(name)
    local ref, t = sasl.findDataRef(name)
    if not ref then
        return nil
    end
    local get, set

    if t == TYPE_INT then
        get = function(self) return sasl.getDataRef(ref); end
        set = function(self, value) sasl.setDataRef(ref, value); end
    elseif t == TYPE_FLOAT or t == TYPE_DOUBLE then
        get = function(self) return math.floor(sasl.getDataRef(ref)); end
        set = function(self, value) sasl.setDataRef(ref, math.floor(value)); end
        logDebug('"'..name..'": '.."Casting "..propTypeToString(t).." to int")
    elseif t == TYPE_STRING then
        get = function(self) return 0 end
        set = function(self, value) sasl.setDataRef(ref, tostring(value), nil, nil); end
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
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Create new int property and set default value
function createGlobalPropertyi(name, default, isNotPublished, isShared, isReadOnly)
    local ref = sasl.createDataRef(name, TYPE_INT, isNotPublished or false, isShared or false, isReadOnly or false)
    if default ~= nil then sasl.setDataRef(ref, default) elseif isShared then sasl.setDataRef(ref, 0) end
    return {
        __p = 1;
        name = name;
        get = function(self) return sasl.getDataRef(ref); end;
        set = function(self, value) sasl.setDataRef(ref, value); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Create new functional int property
function createFunctionalPropertyi(name, getter, setter, isNotPublished)
    local ref = sasl.createFunctionalDataRef(name, TYPE_INT, getter, setter, isNotPublished or false)
    return {
        __p = 1;
        name = name;
        get = function(self) return sasl.getDataRef(ref); end;
        set = function(self, value) sasl.setDataRef(ref, value); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Returns string property
function globalPropertys(name)
    local ref, t = sasl.findDataRef(name)
    if not ref then
        return nil
    end
    local get, set

    if t == TYPE_STRING then
        get = function(self, offset, numValues) return sasl.getDataRef(ref, offset, numValues); end
        set = function(self, value, offset, numValues) sasl.setDataRef(ref, value, offset, numValues); end
    elseif t == TYPE_FLOAT or t == TYPE_INT or t == TYPE_DOUBLE then
        get = function(self) return tostring(sasl.getDataRef(ref, nil, nil)); end
        set = function(self, value) end
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
        size = function() return sasl.getDataRefSize(ref); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Create new string property and set default value
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
        get = function(self, offset, numValues) return sasl.getDataRef(ref, offset, numValues); end;
        set = function(self, value, offset, numValues) sasl.setDataRef(ref, value, offset, numValues); end;
        size = function() return sasl.getDataRefSize(ref); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Create new functional string property
function createFunctionalPropertys(name, getter, setter, isNotPublished, sizeGetter)
    local ref = sasl.createFunctionalDataRef(name, TYPE_STRING, getter, setter, isNotPublished or false, sizeGetter or 0)
    return {
        __p = 1;
        name = name;
        get = function(self, offset, numValues) return sasl.getDataRef(ref, offset, numValues); end;
        set = function(self, value, offset, numValues) sasl.setDataRef(ref, value, offset, numValues); end;
        size = function() return sasl.getDataRefSize(ref); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Returns int array property
function globalPropertyia(name)
    local ref, t = sasl.findDataRef(name)
    if not ref then
        return nil
    end
    local get, set

    if t == TYPE_INT_ARRAY then
        get = function(self, offset, numValues)
            return sasl.getDataRef(ref, offset, numValues)
        end
        set = function(self, value, offset, numValues)
            sasl.setDataRef(ref, value, offset, numValues)
        end
    elseif t == TYPE_FLOAT_ARRAY then
        get = function(self, offset, numValues)
            return math.tablefloor(sasl.getDataRef(ref, offset, numValues))
        end
        set = function(self, value, offset, numValues)
            sasl.setDataRef(ref, math.tablefloor(value), offset, numValues)
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
        size = function() return sasl.getDataRefSize(ref); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Returns int array element property
function globalPropertyiae(name, index)
    local ref, t = sasl.findDataRef(name)
    if not ref then
        return nil
    end
    local get, set
    if t == TYPE_INT_ARRAY then
        get = function(self) return sasl.getDataRef(ref, index, nil) end
        set = function(self, value) sasl.setDataRef(ref, value, index, nil) end
    elseif t == TYPE_FLOAT_ARRAY then
        get = function(self) return math.floor(sasl.getDataRef(ref, index, nil)) end
        set = function(self, value) sasl.setDataRef(ref, math.floor(value), index, nil) end
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
        size = function() return 1; end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Create new int array property
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
        get = function(self, offset, numValues)
            return sasl.getDataRef(ref, offset, numValues)
        end;
        set = function(self, value, offset, numValues)
            sasl.setDataRef(ref, value, offset, numValues)
        end;
        size = function() return sasl.getDataRefSize(ref); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Create new functional int array property
function createFunctionalPropertyia(name, getter, setter, isNotPublished, sizeGetter)
    local ref = sasl.createFunctionalDataRef(name, TYPE_INT_ARRAY, getter, setter, isNotPublished or false, sizeGetter or 0)
    return {
        __p = 1;
        name = name;
        get = function(self, offset, numValues)
            return sasl.getDataRef(ref, offset, numValues)
        end;
        set = function(self, value, offset, numValues)
            sasl.setDataRef(ref, value, offset, numValues)
        end;
        size = function() return sasl.getDataRefSize(ref); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Returns float array property
function globalPropertyfa(name)
    local ref, t = sasl.findDataRef(name)
    if not ref then
        return nil
    end
    local get, set

    if t == TYPE_FLOAT_ARRAY or t == TYPE_INT_ARRAY then
        get = function(self, offset, numValues)
            return sasl.getDataRef(ref, offset, numValues)
        end
        set = function(self, value, offset, numValues)
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
        size = function() return sasl.getDataRefSize(ref); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Returns float array element property
function globalPropertyfae(name, index)
    local ref, t = sasl.findDataRef(name)
    if not ref then
        return nil
    end
    local get, set

    if t == TYPE_FLOAT_ARRAY or t == TYPE_INT_ARRAY then
        get = function(self) return sasl.getDataRef(ref, index, nil) end
        set = function(self, value) sasl.setDataRef(ref, value, index, nil) end
    else
        logWarning('"'..name..'": '.."Can't cast "..propTypeToString(t).." to float array element")
    end

    return {
        __p = 1;
        name = name;
        get = get;
        set = set;
        size = function() return 1; end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Create new float array property
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
        get = function(self, offset, numValues)
            return sasl.getDataRef(ref, offset, numValues)
        end;
        set = function(self, value, offset, numValues)
            sasl.setDataRef(ref, value, offset, numValues)
        end;
        size = function() return sasl.getDataRefSize(ref); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Create new functional float array property
function createFunctionalPropertyfa(name, getter, setter, isNotPublished, sizeGetter)
    local ref = sasl.createFunctionalDataRef(name, TYPE_FLOAT_ARRAY, getter, setter, isNotPublished or false, sizeGetter or 0)
    return {
        __p = 1;
        name = name;
        get = function(self, offset, numValues)
            return sasl.getDataRef(ref, offset, numValues)
        end;
        set = function(self, value, offset, numValues)
            sasl.setDataRef(ref, value, offset, numValues)
        end;
        size = function() return sasl.getDataRefSize(ref); end;
        free = function() sasl.freeDataRef(ref); end;
    }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Properties types-to-string converter
function propTypeToString(propType)
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

--------------------------------------------------------------------------
--------------------------------------------------------------------------
