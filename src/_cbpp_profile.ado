// Settings
set more off, permanently

// Paths
local root = cond("`c(os)'" == "Windows", "C:", "")
global odpath "`root'/Users/`c(username)'/OneDrive - Center on Budget and Policy Priorities"
global sppath "`root'/Users/`c(username)'/Center on Budget and Policy Priorities"
global spdatapath "`root'/Users/`c(username)'/Center on Budget and Policy Priorities/Datasets - "
global ghpath "`root'/Users/`c(username)'/Documents/GitHub"

// Census Bureau API key for getcensus
global censuskey "your Census Bureau API key here"

// Rscript executable for rscript
global RSCRIPT_PATH "path to your Rscript executable"