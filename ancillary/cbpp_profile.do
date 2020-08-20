
// settings
set more off, permanently
set varabbrev off, permanently

// paths
local root = cond("`c(os)'" == "Windows", "C:", "")
global odpath "`root'/Users/`c(username)'/OneDrive - Center on Budget and Policy Priorities"
global sppath "`root'/Users/`c(username)'/Center on Budget and Policy Priorities"
global spdatapath "`root'/Users/`c(username)'/Center on Budget and Policy Priorities/Datasets - "
global ghpath "`root'/Users/`c(username)'/Documents/GitHub"

// api keys
global censuskey "your Census Bureau API key here"
