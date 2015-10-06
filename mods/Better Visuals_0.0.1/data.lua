-- works on new or existing campaigns
data.raw["player"]["player"].light = {
  {
    minimum_darkness = 0.3,
    intensity = 1.0,
    size = 150,
  },
};
data.raw["car"]["car"].light = {
  {
    minimum_darkness = 0.3,
    intensity = 1.0,
    size = 250,
  },
};
-- only works on new campaign
data.raw["map-settings"]["map-settings"].pollution.expected_max_per_chunk = 10000000000;
