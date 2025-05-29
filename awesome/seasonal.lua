-- this script chooses an appropriate wallpaper based on a number of
-- different conditions. If it's a holiday period, it will choose an
-- appropriate wallpaper corresponding to that holiday disregarding
-- the time of day. For non-holiday periods it will consider the current
-- season and time of day.

-- seasons are determined based on the meteorological periods, not the
-- astronomical ones, as follows:
-- Spring: March 1 - May 31
-- Summer: June 1 - August 31
-- Fall:   September 1 - November 30
-- Winter: December 1 - February 28

-- seasons as their day of the year:
-- Spring: 060-151
-- Summer: 152-243
-- Fall:   244-334
-- Winter: 335-059

-- Holidays we care about as their day of the year:
-- This is for NON LEAP YEARS:
-- New Years eve + day:  001 + 365
-- Independence Day:     185
-- Thanksgiving:         332
-- Halloween week:       298-304
-- Christmas 2 weeks:    354-364

local function determineWallpaper()
  --pull some useful info. Current hour and day of the year.
  local date = os.date("*t")

  --wallpaper path
  local image='/home/mark/Pictures/Wallpaper/PC/Seasonal/'

  --check for holidays
  if date.yday == 1 or date.yday == 365 then
    -- new years eve / day
    image = image .. 'Holiday/NewYears/'
  elseif date.yday == 185 then
    -- independence day
    image = image .. 'Holiday/IndependenceDay/'
  elseif date.yday == 332 then
    image = image .. 'Holiday/Thanksgiving/'
  elseif date.yday >= 298 and date.yday <= 304 then
    -- halloween week
    image = image .. 'Holiday/Halloween/'
  elseif date.yday >= 354 and date.yday <= 364 then
    -- christmas 2 weeks
    image = image .. 'Holiday/Christmas/'

  --holidays done, start checking seasons
  elseif date.yday >= 60 and date.yday <= 151 then
    -- spring
    image = image .. 'Spring/Day/'
  elseif date.yday >= 152 and date.yday <= 243 then
    -- summer
    image = image .. 'Summer/Day/'
  elseif date.yday >= 244 and date.yday <= 334 then
    -- fall
    image = image .. 'Fall/Day/'
  elseif date.yday >= 335 or date.yday <= 59 then
    -- winter
    image = image .. 'Winter/Day/'
  end

  --return selected image based on prior conditions
  local pathcom = 'ls ' .. image
  local i = 1
  local files = {}
  --for file in io.popen(pathcom):lines() do print(file) end
  for file in io.popen(pathcom):lines() do
    files[i] = file
    i = i + 1
  end

  math.randomseed(os.time())
  local pick = math.random(31)
  image = image .. files[pick]

  -- call wal on the chosen image to set the colors
  os.execute("wal -i " .. image)

end

return determineWallpaper

