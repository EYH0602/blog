
safeDiv :: Double -> Double -> Maybe Double
safeDiv _ 0 = Nothing
safeDiv a b = Just (a / b)

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead xs = Just (head xs)

-- safeShow :: Show a => a -> Maybe String
-- safeShow

safeShow :: Show a => a -> Maybe String
safeShow = Just . show
