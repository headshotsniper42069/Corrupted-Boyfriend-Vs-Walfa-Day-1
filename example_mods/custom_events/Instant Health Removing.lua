function onEvent(eventName, value1, value2)
    if eventName == "Instant Health Removing" then
        setProperty("health", getProperty("health") - (value1 * 2 / 100))
    end
end