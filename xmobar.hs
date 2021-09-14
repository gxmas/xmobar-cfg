import Xmobar

import Data.List (intercalate)

main :: IO ()
main = xmobar config

config :: Config
config = defaultConfig
    { font = "xft:Fira Code:size=8:style=bold:antialias=true:autohint=false:rgba=rbg"
    , additionalFonts =
        [ "xft:Mononoki Nerd Font:size=10:antialias=true:hinting=true"
        , "xft:FontAwesome:size=10"
        ]
    , bgColor = "#292c3e"
    , fgColor = "#ebebeb"
    , position = Top
    , alpha = 255
    , textOffset = -1
    , iconOffset = -1
    , lowerOnStart = True
    , hideOnStart = False
    , pickBroadest = False
    , allDesktops = True
    , overrideRedirect = True
    , persistent = False
    , iconRoot = "/home/gnoel/.config/xmobar/icons"
    , sepChar = "%"
    , alignSep = "}{"
    , template = templateLeft ++ " }{ " ++ templateRight
    , commands =
        [ Run $ Date "<fn=1>\xf455</fn> %b %d %Y, %Hh%M " "date" 50

        , Run $ Wireless "wlan0"
            [ "-t", "<qualityipat> <fc=#98be65><ssid></fc>"
            , "--"
            , "--quality-icon-pattern", "<icon=network/wireless/%%.xpm/>"
            ] 10

        , Run $ DynNetwork
            [ "--template" , "<txipat> <rxipat>"
            , "--Low"      , "10000"   -- units: B/s
            , "--High"     , "100000"  -- units: B/s
            , "--low"      , "#b5bd68"
            , "--normal"   , "#f1e65b"
            , "--high"     , "#a54242"
            , "--maxtwidth", "0"
            , "--"
            , "--rx-icon-pattern", "<icon=network/rx/%%.xpm/>"
            , "--tx-icon-pattern", "<icon=network/tx/%%.xpm/>"
            ] 10

        , Run $ Alsa "default" "Master"
            [ "--template", "<fn=1>\xfa7e</fn> <volume>% <status>"
            , "--"
            , "--alsactl=/usr/bin/alsactl"
            ]

        , Run $ BatteryP ["BAT0"]
            [ "-t",          "<leftipat> <acstatus>"
            , "--Low",       "10"
            , "--High",      "20"
            , "--low",       "#a54242"
            , "--normal",    "#f1e65b"
            , "--high",      "#98be65"
            , "--maxtwidth", "10"
            , "--"
            , "--on-icon-pattern",   "<icon=battery/on/%%.xpm/>"
            , "--off-icon-pattern",  "<icon=battery/off/%%.xpm/>"
            , "--idle-icon-pattern", "<icon=battery/idle/%%.xpm/>"
            , "-o",                  "<left><fc=#c5c8c6>%</fc> <timeleft>"
            , "-O",                  "<left><fc=#c5c8c6>% <timeleft></fc>"
            , "-i",                  "<fc=#707880>IDLE</fc>"
            ] 10

        -- , Run $ PipeReader "Vol:/tmp/xmobar.vol" "pr:volume"

        , Run $ StdinReader
        ]
    }

templateLeft :: String
templateLeft = "<icon=haskell_20.xpm/> %StdinReader%"

templateRight :: String
templateRight = intercalate " <icon=separator.xpm/> "
    --[ "%pr:volume%"
    --, "%alsa:hw:sofhdadsp:Speaker%"
    [ "%alsa:default:Master%"
    , "%wlan0wi% %dynnetwork%"
    , "%battery%"
    , "%date%"
    ]
