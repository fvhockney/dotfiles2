import XMonad

import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Utils
import XMonad.Util.Run(spawnPipe, hPutStrLn)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig

-- Layouts
import XMonad.Layout.IndependentScreens as LIS
import XMonad.Layout.Maximize
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances

-- Actions
import XMonad.Actions.Navigation2D
import qualified XMonad.Actions.FlexibleResize as Flex
import XMonad.Actions.UpdatePointer

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "kitty"

-- Whethaer focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

rawWorkspaces :: [String]
rawWorkspaces = clickable . map xmobarEscape
               $ ["1:dev", "2:www", "3:sys", "4:doc", "5:vbox", "6:chat", "7:mus", "8:vid", "9:gfx"]
  where
        clickable l = [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]

numbers =["1","2","3","4","5","6","7","8","9"]
myWorkspaces    = withScreens 2 rawWorkspaces

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
myKeys conf@(XConfig {XMonad.modMask = modm}) = mkKeymap conf $

    -- launch a terminal
    [ ("M-<Return>", spawn $ XMonad.terminal conf)


    , ("M-d", spawn "rofi -modi drun -show drun -show-icons")
    -- prompts (rofi)
    , ("M-<Space> p a", spawn "rofi -modi drun -show drun -show-icons")
    , ("M-<Space> p h", spawn "rofi -modi ssh -show ssh")
    --, ("M-<Space> p r", spawn "rofi -modi run -show run")
    , ("M-<Space> p w", spawn "rofi -modi window -show window -show-icons")
    , ("M-<Space> p <Space>", spawn "passmenu")
    , ("M-<Space> <Space>", spawn "passmenu")

    -- close focused window
    , ("M-S-q", kill)


    -- layouts
    , ("M-<Space> l n", sendMessage NextLayout)
    , ("M-<Space> l d", setLayout $ XMonad.layoutHook conf)
    , ("M-<Space> l f", sendMessage ( Toggle NBFULL ) >> sendMessage ToggleStruts)
    , ("M-S-f", sendMessage ( Toggle NBFULL ) >> sendMessage ToggleStruts)

    -- Resize viewed windows to the correct size
    --, ((modm,               xK_n     ), refresh)

    -- windows
    -- Move focus Vim Style
    , ("M-j", windowGo D False)
    , ("M-k", windowGo U False)
    , ("M-l", windowGo R False)
    , ("M-h", windowGo L False)
    , ("M-<Space> w j", windowGo D False)
    , ("M-<Space> w k", windowGo U False)
    , ("M-<Space> w l", windowGo R False)
    , ("M-<Space> w h", windowGo L False)

    -- Swap Windows Vim Style
    , ("M-S-j", windowSwap D False )
    , ("M-S-k", windowSwap U False )
    , ("M-S-l", windowSwap R False )
    , ("M-S-h", windowSwap L False )
    , ("M-<Space> w S-j", windowSwap D False )
    , ("M-<Space> w S-k", windowSwap U False )
    , ("M-<Space> w S-l", windowSwap R False )
    , ("M-<Space> w S-h", windowSwap L False )

    -- focus current window
    , ("M-f", withFocused( sendMessage . maximizeRestore))
    , ("M-<Space> w f", withFocused( sendMessage . maximizeRestore))
    
    -- Move focus to the master window
    , ("M-m", windows W.focusMaster  )
    , ("M-<Space> w g m", windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ("M-S-m", windows W.swapMaster)
    , ("M-<Space> w m m", windows W.swapMaster)

    -- Push window back into tiling
    , ("M-<Space> w t", withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ("M-,", sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ("M-.", sendMessage (IncMasterN (-1)))

    -- Shrink the master area
    , ("M-<Down>", sendMessage Shrink)

    -- Expand the master area
    , ("M-<Up>", sendMessage Expand)


    -- Quit xmonad
    , ("M-S-<Backspace>", io (exitWith ExitSuccess))

    -- Restart xmonad
    , ("M-S-c", spawn "xmonad --recompile; xmonad --restart")
    ]

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
--conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    ++
    [(("M-"++k), windows $ onCurrentScreen f i)
        | (i, k) <- zip (workspaces' conf) numbers
        , (f, m) <- [(W.greedyView, 0)]]

    ++
    [(("M-S-"++k), windows $ onCurrentScreen f i)
        | (i, k) <- zip (workspaces' conf) numbers
        , (f, m) <- [(W.shift, 0)]]
    ++

   -- --
   -- -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
   -- -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
   -- --
    [(("M-"++key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip ["w", "e", "r"] [0..]
        , (f, m) <- [(W.view, 0)]]

    ++
    [(("M-S-"++key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip ["w", "e", "r"] [0..]
        , (f, m) <- [(W.shift, 0)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2 ), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> Flex.mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

myLayouts = tiled ||| Mirror tiled
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

myLayout = avoidStruts $ maximize $ mkToggle (single NBFULL) myLayouts

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = def <+> fullscreenEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
makeLog screen handle = dynamicLogWithPP . marshallPP screen $ def {
    ppCurrent = xmobarColor "#303030" "#909090" . wrap "[" "]" . pad
    , ppHidden = xmobarColor "#909090" "" . wrap "*" "" . pad
    , ppHiddenNoWindows = xmobarColor "#606060" "" . pad 
    , ppLayout = xmobarColor "#909090" "" . pad
    , ppUrgent = xmobarColor "#ff0000" "" . wrap "!" "!" . pad
    , ppTitle = shorten 30
    , ppWsSep = ""
    , ppSep = " "
    , ppExtras = [windowCount]
    , ppOrder = \(ws:l:t:ex) -> [ws, l]++ex++[t]
    , ppOutput = hPutStrLn handle
    }
myLogHook h1 h2 = makeLog 0 h1 >> makeLog 1 h2 >> updatePointer (0.25, 0.25) (0.25, 0.25)

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = composeAll
    [
        -- sync keyboard so xdotool doesn't overwrite it
        spawnOnce "setxkbmap -synch"
    ]

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
    bar1 <- spawnPipe "xmobar -x 0 /home/fvhockney/.config/xmobar/xmobar-mainrc"
    bar2 <- spawnPipe "xmobar -x 1 /home/fvhockney/.config/xmobar/xmobar2rc"
    xmonad $ ewmh $ withUrgencyHook NoUrgencyHook $ withNavigation2DConfig def $ defaults bar1 bar2

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults bar1 bar2 = docks def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook bar1 bar2,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Enter  Launch xterminal",
    "mod-d            Launch dmenu",
    "mod-Space        launch Passmenu",
    "mod-Shift-q      Close/kill the focused window",
    "mod-n            Cycle through next layout",
    "mod-Shift-n      Return to default layout",
    "",
    "-- move focus up or down the window stack",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Shift-m  Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-BackSpace  Quit xmonad",
    "mod-Shift-c          Restart xmonad",
    "mod-[1..9]           Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
