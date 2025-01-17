PWMySQL = {
    Async = {},
    Sync = {},
}

local function safeParameters(params)
    if nil == params then
        return {[''] = ''}
    end

    assert(type(params) == "table", "A table is expected")
    assert(params[1] == nil, "Parameters should not be an array, but a map (key / value pair) instead")

    if next(params) == nil then
        return {[''] = ''}
    end

    return params
end

---
-- Execute a query with no result required, sync version
--
-- @param query
-- @param params
--
-- @return int Number of rows updated
--
function PWMySQL.Sync.execute(query, params)
    assert(type(query) == "string", "The SQL Query must be a string")

    local res = 0
    local finishedQuery = false
    exports['pw_mysql2']:mysql_execute(query, safeParameters(params), function (result)
        res = result
        finishedQuery = true
    end)
    repeat Citizen.Wait(0) until finishedQuery == true
    return res
end
---
-- Execute a query and fetch all results in an sync way
--
-- @param query
-- @param params
--
-- @return table Query results
--
function PWMySQL.Sync.fetchAll(query, params)
    assert(type(query) == "string", "The SQL Query must be a string")

    local res = {}
    local finishedQuery = false
    exports['pw_mysql2']:mysql_fetch_all(query, safeParameters(params), function (result)
        res = result
        finishedQuery = true
    end)
    repeat Citizen.Wait(0) until finishedQuery == true
    return res
end

---
-- Execute a query and fetch the first column of the first row, sync version
-- Useful for count function by example
--
-- @param query
-- @param params
--
-- @return mixed Value of the first column in the first row
--
function PWMySQL.Sync.fetchScalar(query, params)
    assert(type(query) == "string", "The SQL Query must be a string")

    local res = ''
    local finishedQuery = false
    exports['pw_mysql2']:mysql_fetch_scalar(query, safeParameters(params), function (result)
        res = result
        finishedQuery = true
    end)
    repeat Citizen.Wait(0) until finishedQuery == true
    return res
end

---
-- Execute a query and retrieve the last id insert, sync version
--
-- @param query
-- @param params
--
-- @return mixed Value of the last insert id
--
function PWMySQL.Sync.insert(query, params)
    assert(type(query) == "string", "The SQL Query must be a string")

    local res = 0
    local finishedQuery = false
    exports['pw_mysql2']:mysql_insert(query, safeParameters(params), function (result)
        res = result
        finishedQuery = true
    end)
    repeat Citizen.Wait(0) until finishedQuery == true
    return res
end

---
-- Execute a List of querys and returns bool true when all are executed successfully
--
-- @param querys
-- @param params
--
-- @return bool if the transaction was successful
--
function PWMySQL.Sync.transaction(querys, params)
    local res = 0
    local finishedQuery = false
    exports['pw_mysql2']:mysql_transaction(query, params, function (result)
        res = result
        finishedQuery = true
    end)
    repeat Citizen.Wait(0) until finishedQuery == true
    return res
end

---
-- Execute a query with no result required, async version
--
-- @param query
-- @param params
-- @param func(int)
--
function PWMySQL.Async.execute(query, params, func)
    assert(type(query) == "string", "The SQL Query must be a string")

    exports['pw_mysql2']:mysql_execute(query, safeParameters(params), func)
end

---
-- Execute a query and fetch all results in an async way
--
-- @param query
-- @param params
-- @param func(table)
--
function PWMySQL.Async.fetchAll(query, params, func)
    assert(type(query) == "string", "The SQL Query must be a string")

    exports['pw_mysql2']:mysql_fetch_all(query, safeParameters(params), func)
end

---
-- Execute a query and fetch the first column of the first row, async version
-- Useful for count function by example
--
-- @param query
-- @param params
-- @param func(mixed)
--
function PWMySQL.Async.fetchScalar(query, params, func)
    assert(type(query) == "string", "The SQL Query must be a string")

    exports['pw_mysql2']:mysql_fetch_scalar(query, safeParameters(params), func)
end

---
-- Execute a query and retrieve the last id insert, async version
--
-- @param query
-- @param params
-- @param func(string)
--
function PWMySQL.Async.insert(query, params, func)
    assert(type(query) == "string", "The SQL Query must be a string")

    exports['pw_mysql2']:mysql_insert(query, safeParameters(params), func)
end

---
-- Execute a List of querys and returns bool true when all are executed successfully
--
-- @param querys
-- @param params
-- @param func(bool)
--
function PWMySQL.Async.transaction(querys, params, func)
    return exports['pw_mysql2']:mysql_transaction(querys, params, func)
end

function PWMySQL.ready (callback)
    Citizen.CreateThread(function ()
        -- add some more error handling
        while GetResourceState('pw_mysql2') ~= 'started' do
            Citizen.Wait(0)
        end
        while not exports['pw_mysql2']:is_ready() do
            Citizen.Wait(0)
        end
        callback()
    end)
end
