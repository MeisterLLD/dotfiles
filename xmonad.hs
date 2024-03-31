--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import Data.Monoid
import Data.Maybe (maybeToList)
--import XMonad.Layout.LayoutModifier
--import XMonad.Layout.ResizableTile
import Control.Monad ((>=>), join, liftM, when)
import System.Exit
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog
import XMonad.Layout.Spacing
import XMonad.Actions.NoBorders
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Control.Monad -- liftM2
import XMonad.Layout.ResizableTile
import XMonad.Layout.IndependentScreens
import Data.Semigroup
import XMonad.Hooks.OnPropertyChange
import XMonad.Layout.Renamed
import XMonad.Layout.Magnifier
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "st"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 2

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
myWorkspaces    = ["web","vim","mel","not","dev","spo","mco", "8"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#3d6f65"
myFocusedBorderColor = "#1cf2c6"

myTabConf :: Theme
myTabConf = def{ 
                 activeTextColor = "#2AA090"
               , inactiveColor = "#657B81"
               , activeColor = "#657B81"
               , fontName = "xft:Ubuntu:size=25:antialias=True"
               , inactiveTextColor = "#657B81"
               , inactiveBorderColor = "#002B36"
               , activeBorderColor = "#002B36"
               }




------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu with instant 1 match opening
    , ((modm,               xK_p     ), spawn "dmenu_run -b -n  -nf '#eee8d5' -sb '#002b36' -nb '#002b36' -sf '#2aa198' -fn 'Ubuntu:size=18'")

    -- launch dmenu classic 
    , ((modm .|. shiftMask, xK_p     ), spawn "dmenu_run -b  -nf '#eee8d5' -sb '#002b36' -nb '#002b36' -sf '#2aa198' -fn 'Ubuntu:size=18'")

    -- launch dmenu extended
    , ((modm .|. shiftMask, xK_h     ), spawn "dmenu_extended_run")
    , ((modm .|. shiftMask, xK_h     ), spawn "rofi -modi file-browser-extended -show file-browser-extended -file-browser-depth 7")


    -- launch dmenu extended piped into dragon drag and drop
    , ((modm .|. shiftMask, xK_y     ), spawn "dmenu_extended_run \"dragon-drag-and-drop:\"")    
    , ((modm .|. shiftMask, xK_y     ), spawn "rofi -modi file-browser-extended -show file-browser-extended -file-browser-depth 7 -file-browser-cmd dragon-drop")

   
    
-- launch bookmenu 
    , ((modm,               xK_b     ), spawn "bookmenu")
    
    -- launch ranger 
    , ((modm,               xK_r     ), spawn "st ranger")

    -- launch gvim 
    , ((modm,               xK_v     ), spawn "gvim +History")

    -- launch gmrun
    --, ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    ---- Move focus to the previous window
    --, ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    -- patch fr
    , ((modm              , xK_semicolon), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))


     -- Toggle Fullscreen
    , ((modm              , xK_f), toggleFull)

    -- ResizableTall
    , ((modm,               xK_Up), sendMessage MirrorExpand)
    , ((modm,               xK_Down), sendMessage MirrorShrink)
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [0x26,0xe9,0x22,0x27,0x28,0x2d,0xe8,0x5f,0xe7]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)
        , (\i -> W.greedyView i . W.shift i, controlMask)]]
   
 
    ++

    --
    -- mod-{w,e,x}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,x}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_z, xK_e, xK_x] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]






------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
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
-- tab configuration
addSpace = spacingRaw 
  True  (Border 10 0 10 0) 
  True  (Border 0 10 0 10) 
  True

myLayout =   smartBorders $ avoidStruts ( tiled ||| Mirror tiled ||| Full ||| magnifier tiled |||  spiral (6/7)) 
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = renamed [Replace "Tiled"] $ addSpace $ ResizableTall nmaster delta ratio []

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100


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
    , className =? "@molotov/desktop-wrapper"     --> doFloat
    , className =? "vlc"            --> doFloat
    , className =? "SpeedCrunch"    --> doFloat
    -- toolkit = le lecteur incrusté de FF
    --, title =? "Incrustation vidéo" --> doFloat
    , className =? "firefox"        --> viewShift "web"
    , className =? "MComix"        --> viewShift "mco"
    , className =? "Gvim"           --> viewShift "vim"
    , className =? "thunderbird"    --> viewShift "mel"
    , title     =? "Private Internet Access"     --> doShift   "7"
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , isFullscreen --> doFullFloat ]
  where    viewShift = doF . liftM2 (.) W.greedyView W.shift

addNETSupported :: Atom -> X ()
addNETSupported x   = withDisplay $ \dpy -> do
    r               <- asks theRoot
    a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
    a               <- getAtom "ATOM"
    liftIO $ do
       sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
       when (fromIntegral x `notElem` sup) $
         changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen   = do
    wms <- getAtom "_NET_WM_STATE"
    wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
    mapM_ addNETSupported [wms, wfs]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--

-- Certaines fenêtres comme Spotify ou LibreOffice changent leur classname à l'ouverture, ce qui empêche
-- de les déplacer. Il faut faire ça avec dynamicPropertyChange.

myEventHook = composeAll
   [
   onXPropertyChange "WM_NAME"  (title =? "Spotify Premium" --> viewShift "spo"),
   onXPropertyChange "WM_NAME"  (className =? "libreoffice-calc" --> viewShift "not")
   ]
   where    viewShift = doF . liftM2 (.) W.greedyView W.shift
   


------------------------------------------------------------------------
-- Status bars and logging

myLogHook = return()

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
  spawnOnce "nitrogen --restore &"
  spawnOnce "volumeicon &"
  -- spawnOnce "picom &"
  spawnOnce "nm-applet &"
  spawnOnce "xbindkeys &"
  spawnOnce "exec /usr/bin/trayer --edge top --align right --width 6  --height 28 --tint 0x002b36 --alpha 0 --transparent true &"
  spawnOnce "nextcloud &"
  spawnOnce "redshift-gtk &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do 
  xmproc0 <- spawnPipe "xmobar -x 0"
  xmproc1 <- spawnPipe "xmobar -x 1"
  -- xmonad $ docks defaults
  xmonad $ ewmhFullscreen . ewmh $ docks $ defaults {
        logHook = dynamicLogWithPP xmobarPP 
       {  ppOutput = \x -> hPutStrLn xmproc0 x  >> hPutStrLn xmproc1 x 
         ,ppVisible = xmobarColor "#fff200" ""  . wrap "(" ")"
         ,ppTitle = xmobarColor "orange" "" . shorten 50 
         ,ppCurrent = xmobarColor "#fff200" "" . wrap "[" "]"
         ,ppHidden  = xmobarColor "#ba291c" "" . wrap "[" "]"
         ,ppHiddenNoWindows  = xmobarColor "lightblue" "" . wrap "[" "]"  
         ,ppLayout = xmobarColor"white" ""
         ,ppUrgent = xmobarColor "#657b83" "" . wrap "!" "!" 
         ,ppSep = " | "
      }
      , manageHook = manageDocks <+> myManageHook
      , startupHook = myStartupHook 
  }

  
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
  --xmonad $ def{
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
        logHook            = myLogHook,
        startupHook        = myStartupHook >> addEWMHFullscreen
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
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
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
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

-------


--Looks to see if focused window is floating and if it is the places it in the stack
--else it makes it floating but as full screen
toggleFull = withFocused (\windowId -> do
    { 
      floats <- gets (W.floating . windowset);
        if windowId `M.member` floats
        then do 
           withFocused $ toggleBorder
           withFocused $ windows . W.sink
        else do 
           withFocused $ toggleBorder
           withFocused $  windows . (flip W.float $ W.RationalRect 0 0 1 1) 
   } 
   )  

