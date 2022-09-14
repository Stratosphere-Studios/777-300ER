-------------------------------------------------------------------------------
-- API
-------------------------------------------------------------------------------

--- @class gl
gl = {}

--- @class al
al = {}

--- @class net
net = {}

--- @class options
options = {}

--- @class windows
windows = {}

--- @class sasl
--- @field gl gl
--- @field al al
--- @field net net
--- @field options options
sasl = {
    gl = gl,
    al = al,
    net = net,
    options = options,
    windows = windows
}

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class LogLevelID

LOG_DEFAULT = nil
LOG_TRACE = nil
LOG_DEBUG = nil
LOG_INFO = nil
LOG_WARN = nil
LOG_ERROR = nil

--- Writes data to log files using info-level.
--- @vararg string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#logInfo
function logInfo(...) end;
sasl.logInfo = logInfo;

--- Writes data to log files using info-level.
--- @vararg string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#print
function print(...) end;
sasl.print = print;

--- Writes data to log files using warning-level.
--- @vararg string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#logWarning
function logWarning(...) end;
sasl.logWarning = logWarning;

--- Writes data to log files using error-level.
--- @vararg string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#logError
function logError(...) end;
sasl.logError = logError;

--- Writes data to log files using debug-level.
--- @vararg string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#logDebug
function logDebug(...) end;
sasl.logDebug = logDebug;

--- Writes data to log files using debug-level.
--- @vararg string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#logTrace
function logTrace(...) end;
sasl.logTrace = logTrace;

--- Returns currently selected log level.
--- @return LogLevelID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getLogLevel
function getLogLevel() end;
sasl.getLogLevel = getLogLevel;

--- Sets current log level for logger.
--- @param level LogLevelID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setLogLevel
function setLogLevel(level) end;
sasl.setLogLevel = setLogLevel;

--- Writes data to log files using more parameters
--- @param level LogLevelID
--- @param isFatal boolean
--- @param header string
--- @param message string
--- @param stackTraceDepth number
--- @param color Color
--- @overload fun(level:LogLevelID, isFatal:boolean, header:string, message:string):void
--- @overload fun(level:LogLevelID, isFatal:boolean, header:string, message:string, stackTraceDepth:string):void
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#log
function log(level, isFatal, header, message, stackTraceDepth, color) end;
sasl.log = log;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns value of system environment variable for current process.
--- @param name string
--- @return boolean, string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getEnvVariable
function getEnvVariable(name) end;
sasl.getEnvVariable = getEnvVariable;

--- Sets value of system environment variable (creates new, if it doesn't exist) for current process.
--- @param name string
--- @param value string
--- @return boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setEnvVariable
function setEnvVariable(name, value) end;
sasl.setEnvVariable = setEnvVariable;

--- Unsets environment variable for current process.
--- @param name string
--- @return boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#unsetEnvVariable
function unsetEnvVariable(name) end;
sasl.unsetEnvVariable = unsetEnvVariable;

--- Returns the identifier of OS.
--- @return string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getOS
function getOS() end;
sasl.getOS = getOS;

--- Returns X-Plane version.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getXPVersion
function getXPVersion() end;
sasl.getXPVersion = getXPVersion;

--- Sets text, specified in text into OS clipboard.
--- @param text string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setClipboardText.
function setClipboardText(text) end;
sasl.setClipboardText = setClipboardText;

--- Gets current text from OS clipboard
--- @return string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getClipboardText
function getClipboardText() end;
sasl.getClipboardText = getClipboardText;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class FileEntry
--- @field name string
--- @field type string

--- Returns data about directories and files located in the specified path.
--- @param path string
--- @return FileEntry[]
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#listFiles
function listFiles(path) end;
sasl.listFiles = listFiles;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Enables/disables rendering on aircraft pane (for non-scenery SASL project types).
--- @param isOn boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setAircraftPanelRendering
function setAircraftPanelRendering(isOn) end;
options.setAircraftPanelRendering = setAircraftPanelRendering;

--- Enables/disables 3D rendering for SASL project.
--- @param isOn boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#set3DRendering
function set3DRendering(isOn) end;
options.set3DRendering = set3DRendering;

--- Enables/disables interactive abilities for SASL project (mouse and keyboard callbacks).
--- @param isOn boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setInteractivity
function setInteractivity(isOn) end;
options.setInteractivity = setInteractivity;

--- Enables/disables ability to alter blending parameters when drawing to 2D targets.
--- @param isOn boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setCustomBlending
function setCustomBlending(isOn) end;
options.setCustomBlending = setCustomBlending;

--- Enables/disables optimization related to drawing into multiple render targets in 'update' function.
--- @param isOn boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setUpdateDrawingReady
function setUpdateDrawingReady(isOn) end;
options.setUpdateDrawingReady = setUpdateDrawingReady;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class RenderingMode2DId

SASL_RENDER_2D_DEFAULT = nil
SASL_RENDER_2D_MULTIPASS = nil

--- Changes current 2D rendering mode based on the passed ID value.
--- @param ID RenderingMode2DId
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setRenderingMode2D
function setRenderingMode2D(ID) end;
options.setRenderingMode2D = setRenderingMode2D;

--- @class PanelRenderingModeId

SASL_RENDER_PANEL_DEFAULT = nil
SASL_RENDER_PANEL_BEFORE_AND_AFTER = nil

--- Changes current rendering mode of Aircraft Panel based on the passed ID value.
--- @param ID PanelRenderingModeId
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setPanelRenderingMode
function setPanelRenderingMode(ID) end;
options.setPanelRenderingMode = setPanelRenderingMode;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class ErrorsHandlingModeID

SASL_KEEP_PROCESSING = nil
SASL_STOP_PROCESSING = nil

--- Sets different modes for handling Lua errors during project development,
--- depending on the passed ID value.
--- @param ID ErrorsHandlingModeID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setLuaErrorsHandling
function setLuaErrorsHandling(ID) end;
options.setLuaErrorsHandling = setLuaErrorsHandling;

--- Sets limit for Lua stack trace entries. Default stack trace limit is 6.
--- @param limit number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setLuaStackTraceLimit
function setLuaStackTraceLimit(limit) end;
options.setLuaStackTraceLimit = setLuaStackTraceLimit;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns the table of monitor IDs, which are covered with global simulator
--- desktop window (only monitors with simulator in full-screen mode are
--- included).
--- @return table
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getMonitorsIDsGlobal
function getMonitorsIDsGlobal() end;
windows.getMonitorsIDsGlobal = getMonitorsIDsGlobal;

--- Returns the table of all monitor IDs in the OS. This may include monitors
--- that are not covered by the simulator window.
--- @return table
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getMonitorsIDsOS
function getMonitorsIDsOS() end;
windows.getMonitorsIDsOS = getMonitorsIDsOS;

--- Returns the bounds (taking scaling into account) of each full-screen X-Plane
--- window within the X-Plane global desktop space.
--- @param id number
--- @return number, number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getMonitorBoundsGlobal
function getMonitorBoundsGlobal(id) end;
windows.getMonitorBoundsGlobal = getMonitorBoundsGlobal;

--- Returns the bounds of the monitor in OS pixels. id is a numeric identifier of
--- particular monitor.
--- @param id number
--- @return number, number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getMonitorBoundsOS
function getMonitorBoundsOS(id) end;
windows.getMonitorBoundsOS = getMonitorBoundsOS;

--- This routine returns the bounds of the ”global” X-Plane desktop.
--- @return number, number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getScreenBoundsGlobal
function getScreenBoundsGlobal() end;
windows.getScreenBoundsGlobal = getScreenBoundsGlobal;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class command

--- Find simulator command by specified name.
--- @param name string
--- @return command
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#findCommand
function findCommand(name) end;
sasl.findCommand = findCommand;

--- Starts command execution.
--- @param commandID command
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#commandBegin
function commandBegin(commandID) end;
sasl.commandBegin = commandBegin;

--- Finishes command execution.
--- @param commandID command
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#commandEnd
function commandEnd(commandID) end;
sasl.commandEnd = commandEnd;

--- Starts and finishes command immediately.
--- @param commandID command
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#commandOnce
function commandOnce(commandID) end;
sasl.commandOnce = commandOnce;

--- Creates new command, specified by name and description.
--- @param name string
--- @param description string
--- @return command
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createCommand
function createCommand(name, description) end;
sasl.createCommand = createCommand;

--- @class phase

SASL_COMMAND_BEGIN = nil
SASL_COMMAND_CONTINUE = nil
SASL_COMMAND_END = nil

--- Adds handler to command commandID.
--- @param commandID command
--- @param isBefore number
--- @param handle fun(phase:number)
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#registerCommandHandler
function registerCommandHandler(commandID, isBefore, handle) end;
sasl.registerCommandHandler = registerCommandHandler;

--- Removes command handler from command commandID and isBefore pair.
--- @param commandID command
--- @param isBefore number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#unregisterCommandHandler
function unregisterCommandHandler(commandID, isBefore) end;
sasl.unregisterCommandHandler = unregisterCommandHandler;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class menuID

PLUGINS_MENU_ID = nil
AIRCRAFT_MENU_ID = nil

--- @class menuItemID

--- @class menuItemState

MENU_NO_CHECK = nil
MENU_UNCHECKED = nil
MENU_CHECKED = nil

--- Appends new menu item with name to the menu with specified inMenuID.
--- @param inMenuID menuID
--- @param name string
--- @param callback fun():void
--- @overload fun(inMenuID:menuID, name:string):menuItemID
--- @return menuItemID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#appendMenuItem
function appendMenuItem(inMenuID, name, callback) end;
sasl.appendMenuItem = appendMenuItem;

--- Appends new menu item with name to the menu with specified inMenuID.
--- @param inMenuID menuID
--- @param name string
--- @param commandID command
--- @return menuItemID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#appendMenuItemWithCommand
function appendMenuItemWithCommand(inMenuID, name, commandID) end;
sasl.appendMenuItemWithCommand = appendMenuItemWithCommand;

--- Removes menu item specified by inMenuItemID from menu that corresponds to
--- inMenuID.
--- @param inMenuID menuID
--- @param inMenuItemID menuItemID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#removeMenuItem
function removeMenuItem(inMenuID, inMenuItemID) end;
sasl.removeMenuItem = removeMenuItem;

--- Sets name for menu item, specified by inMenuItemID that corresponds to menu
--- with inMenuID.
--- @param inMenuID menuID
--- @param inMenuItemID menuItemID
--- @param name string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setMenuItemName
function setMenuItemName(inMenuID, inMenuItemID, name) end;
sasl.setMenuItemName = setMenuItemName;

--- Sets current state of menu item, specified by inMenuItemID that corresponds to
--- menu with inMenuID.
--- @param inMenuID menuID
--- @param inMenuItemID menuItemID
--- @param inState menuItemState
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setMenuItemState
function setMenuItemState(inMenuID, inMenuItemID, inState) end;
sasl.setMenuItemState = setMenuItemState;

--- Gets current state of menu item, specified by inMenuItemID that belongs to menu
--- with inMenuID.
--- @param inMenuID menuID
--- @param inMenuItemID menuItemID
--- @return menuItemState
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getMenuItemState
function getMenuItemState(inMenuID, inMenuItemID) end;
sasl.getMenuItemState = getMenuItemState;

--- Enables or disables menu item, specified by inMenuItemID that corresponds to menu
--- inMenuID.
--- @param inMenuID menuID
--- @param inMenuItemID menuItemID
--- @param isEnable number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#enableMenuItem
function enableMenuItem(inMenuID, inMenuItemID, isEnable) end;
sasl.enableMenuItem = enableMenuItem;

--- Creates new child menu with specified parent menu parentMenuID in menu item
--- specified by parentMenuItemID
--- @param name string
--- @param parentMenuID menuID
--- @param parentMenuItemID menuItemID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createMenu
function createMenu(name, parentMenuID, parentMenuItemID) end;
sasl.createMenu = createMenu;

--- Appends menu separator to the menu, specified by inMenuID.
--- @param inMenuID menuID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#appendMenuSeparator
function appendMenuSeparator(inMenuID) end;
sasl.appendMenuSeparator = appendMenuSeparator;

--- Deletes all menu items from menu that corresponds to inMenuID.
--- @param inMenuID menuID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#clearAllMenuItems
function clearAllMenuItems(inMenuID) end;
sasl.clearAllMenuItems = clearAllMenuItems;

--- Destroys menu, specified by inMenuID argument.
--- @param inMenuID menuID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#destroyMenu
function destroyMenu(inMenuID) end;
sasl.destroyMenu = destroyMenu;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates interactive message window for users.
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param title string
--- @param message string
--- @param buttonsCount number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#messageWindow
function messageWindow(x, y, width, height, title, message, buttonsCount, ...) end;
sasl.messageWindow = messageWindow;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class CameraStatus

CAMERA_NOT_CONTROLLED = nil
CAMERA_CONTROLLED_UNTIL_VIEW_CHANGE = nil
CAMERA_CONTROLLED_ALWAYS = nil

--- Gets current camera state.
--- @return number, number, number, number, number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCamera
function getCamera() end;
sasl.getCamera = getCamera;

--- Sets current camera state.
--- @param x number
--- @param y number
--- @param z number
--- @param pitch number
--- @param yaw number
--- @param roll number
--- @param zoom number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setCamera
function setCamera(x, y, z, pitch, yaw, roll, zoom) end;
sasl.setCamera = setCamera;

--- Registers new camera controller with provided callback.
--- @param callback fun():void
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#registerCameraController
function registerCameraController(callback) end;
sasl.registerCameraController = registerCameraController;

--- Unregisters camera controller function with provided numeric identifier id.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#unregisterCameraController
function unregisterCameraController(id) end;
sasl.unregisterCameraController = unregisterCameraController;

--- Gets current camera status.
--- @return CameraStatus
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCurrentCameraStatus
function getCurrentCameraStatus() end;
sasl.getCurrentCameraStatus = getCurrentCameraStatus;

--- Starts camera control with camera controller, specified by numeric identifier
--- id and with provided status
--- @param id number
--- @param status CameraStatus
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#startCameraControl
function startCameraControl(id, status) end;
sasl.startCameraControl = startCameraControl;

--- Stops camera controlling.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#stopCameraControl
function stopCameraControl() end;
sasl.stopCameraControl = stopCameraControl;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Synchronously downloads file, specified by url and writes it to the
--- specified path.
--- @param url string
--- @param path string
--- @return boolean, string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#downloadFileSync
function downloadFileSync(url, path) end;
net.downloadFileSync = downloadFileSync;

--- Asynchronously downloads file, specified by url and writes it to the
--- specified path
--- @param url string
--- @param path string
--- @param callback fun(url:string, path:string, isOk:boolean, error:string):void
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#downloadFileAsync
function downloadFileAsync(url, path, callback) end;
net.downloadFileAsync = downloadFileAsync;

--- Synchronously downloads contents from file, specified by url.
--- @param url string
--- @return boolean, string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#downloadFileContentsSync
function downloadFileContentsSync(url) end;
net.downloadFileContentsSync = downloadFileContentsSync;

--- Asynchronously downloads contents from file, specified by url.
--- @param url string
--- @param callback fun(url:string, contents:string, isOk:boolean, error:string):void
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#downloadFileContentsAsync
function downloadFileContentsAsync(url, callback) end;
net.downloadFileContentsAsync = downloadFileContentsAsync;

--- @class TimeoutType

SASL_TIMEOUT_CONNECTION = nil
SASL_TIMEOUT_OPERATION = nil
SASL_TIMEOUT_SPEEDLIMIT = nil

SASL_TIMEOUT_VALUE_DEFAULT = nil

--- Synchronously downloads contents from file, specified by url.
--- @param type TimeoutType
--- @param time number
--- @param speed number
--- @overload fun(type:TimeoutType, time:number):void
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setDownloadTimeout
function setDownloadTimeout(type, time, speed) end;
net.setDownloadTimeout = setDownloadTimeout;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class timerID

--- Creates new simple timer object based on simulator clock and returns its
--- identifier id.
--- @return timerID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createTimer
function createTimer() end;
sasl.createTimer = createTimer;

--- Creates new high resolution performance timer object and returns its
--- identifier id.
--- @return timerID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createTimer
function createPerformanceTimer() end;
sasl.createPerformanceTimer = createPerformanceTimer;

--- Deletes timer object by specific timer id.
--- @param id timerID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#deleteTimer
function deleteTimer(id) end;
sasl.deleteTimer = deleteTimer;

--- Starts timer, specified by id.
--- @param id timerID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#startTimer
function startTimer(id) end;
sasl.startTimer = startTimer;

--- Pauses timer, specified by id.
--- @param id timerID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#pauseTimer
function pauseTimer(id) end;
sasl.pauseTimer = pauseTimer;

--- Resumes previously paused timer, specified by id.
--- @param id timerID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#resumeTimer
function resumeTimer(id) end;
sasl.resumeTimer = resumeTimer;

--- Stops timer, specified by id.
--- @param id timerID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#stopTimer
function stopTimer(id) end;
sasl.stopTimer = stopTimer;

--- Resets timer to its initial state.
--- @param id timerID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#resetTimer
function resetTimer(id) end;
sasl.resetTimer = resetTimer;

--- Returns elapsed time in seconds for timer, specified by id.
--- @param id timerID
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getElapsedSeconds
function getElapsedSeconds(id) end;
sasl.getElapsedSeconds = getElapsedSeconds;

--- Returns elapsed time in microseconds for timer, specified by id.
--- @param id timerID
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getElapsedMicroseconds
function getElapsedMicroseconds(id) end;
sasl.getElapsedMicroseconds = getElapsedMicroseconds;

--- Returns overall count of performed updating cycles in simulator.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCurrentCycle
function getCurrentCycle() end;
sasl.getCurrentCycle = getCurrentCycle;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class PluginID

NO_PLUGIN_ID = nil

--- Returns identifier of the SASL project plugin in simulator plugins system.
--- @return PluginID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getMyPluginID
function getMyPluginID() end;
sasl.getMyPluginID = getMyPluginID;

--- Returns full path to SASL project plugin.
--- @return string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getMyPluginPath
function getMyPluginPath() end;
sasl.getMyPluginPath = getMyPluginPath;

--- Returns full path to simulator folder.
--- @return string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getXPlanePath
function getXPlanePath() end;
sasl.getXPlanePath = getXPlanePath;

--- Returns full path to the SASL project folder (for every project type
--- and location).
--- @return string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getProjectPath
function getProjectPath() end;
sasl.getProjectPath = getProjectPath;

--- Returns name of SASL project.
--- @return string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getProjectName
function getProjectName() end;
sasl.getProjectName = getProjectName;

--- Returns full path to the currently loaded aircraft.
--- @return string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getAircraftPath
function getAircraftPath() end;
sasl.getAircraftPath = getAircraftPath;

--- Returns filename of the currently loaded aircraft.
--- @return string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getAircraft
function getAircraft() end;
sasl.getAircraft = getAircraft;

--- Returns total number of currently loaded plugins in simulator system.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#countPlugins
function countPlugins() end;
sasl.countPlugins = countPlugins;

--- Returns the identifier of the plugin, represented by index in simulator
--- plugins system.
--- @param index number
--- @return PluginID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getNthPlugin
function getNthPlugin(index) end;
sasl.getNthPlugin = getNthPlugin;

--- Returns the identifier of the plugin, which located in specified path.
--- @param path string
--- @return PluginID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#findPluginByPath
function findPluginByPath(path) end;
sasl.findPluginByPath = findPluginByPath;

--- Returns the identifier of the plugin with specified signature.
--- @param signature string
--- @return PluginID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#findPluginBySignature
function findPluginBySignature(signature) end;
sasl.findPluginBySignature = findPluginBySignature;

--- Returns the set of information about plugin, specified by id.
--- @param id PluginID
--- @return string, string, string, string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getPluginInfo
function getPluginInfo(id) end;
sasl.getPluginInfo = getPluginInfo;

--- Returns the state (enabled or disabled) identifier of plugin with
--- specified id.
--- @param id PluginID
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#isPluginEnabled
function isPluginEnabled(id) end;
sasl.isPluginEnabled = isPluginEnabled;

--- Enables plugin, specified by id.
--- @param id PluginID
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#enablePlugin
function enablePlugin(id) end;
sasl.enablePlugin = enablePlugin;

--- Disables plugin, specified by id.
--- @param id PluginID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#disablePlugin
function disablePlugin(id) end;
sasl.disablePlugin = disablePlugin;

--- Reloads all plugins in simulator system.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#reloadPlugins
function reloadPlugins() end;
sasl.reloadPlugins = reloadPlugins;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class MessageDataType

TYPE_UNKNOWN = nil
TYPE_INT_ARRAY = nil
TYPE_FLOAT_ARRAY = nil
TYPE_STRING = nil

--- Registers new message handler for message with unique specified messageID.
--- @param messageID number
--- @param type MessageDataType
--- @param callback fun(id:PluginID, messageID:number, data:string | table) : void | fun(id:PluginID, messageID:number) : void
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#registerMessageHandler
function registerMessageHandler(messageID, type, callback) end;
sasl.registerMessageHandler = registerMessageHandler;

--- Unregisters message handler for message with unique specified messageID.
--- @param messageID number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#unregisterMessageHandler
function unregisterMessageHandler(messageID) end;
sasl.unregisterMessageHandler = unregisterMessageHandler;

--- Sends message with unique identifier messageID to the plugin with identifier id.
--- @param id PluginID
--- @param messageID number
--- @param type MessageDataType
--- @overload fun(id:PluginID, messageID:number, type:MessageDataType, data:string | table):void
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#sendMessageToPlugin
function sendMessageToPlugin(id, messageID, type) end;
sasl.sendMessageToPlugin = sendMessageToPlugin;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class MouseButton

MB_LEFT = nil
MB_RIGHT = nil
MB_MIDDLE = nil

--- [DEPRECATED] Enables auxiliary click system if isActive is true, and disables auxiliary
--- click system if isActive is false.
--- @param isActive boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setAuxiliaryClickSystem
function setAuxiliaryClickSystem(isActive) end;
sasl.setAuxiliaryClickSystem = setAuxiliaryClickSystem;

--- Sets interval in seconds for double-click events.
--- @param interval number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setCSDClickInterval
function setCSDClickInterval(interval) end;
sasl.setCSDClickInterval = setCSDClickInterval;

--- Returns interval in seconds for double-click events.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSDClickInterval
function getCSDClickInterval() end;
sasl.getCSDClickInterval = getCSDClickInterval;

--- Sets current auxiliary click system mode, represented by number.
--- @param mode number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setCSMode
function setCSMode(mode) end;
sasl.setCSMode = setCSMode;

--- Returns current auxiliary click system mode.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setCSMode
function getCSMode() end;
sasl.getCSMode = getCSMode;

--- Enables custom cursor showing and sets the cursor that corresponds
--- to cursorID.
--- @param cursorID number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setCSShowCursor
function setCSShowCursor(cursorID) end;
sasl.setCSShowCursor = setCSShowCursor;

--- Returns current selected cursor identifier cursorID.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSShowCursor
function getCSShowCursor() end;
sasl.getCSShowCursor = getCSShowCursor;

--- Sets delay in seconds between last mouse zoom event and first
--- possible mouse wheel custom event handling.
--- @param delay number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setCSWheelInteractionDelay
function setCSWheelInteractionDelay(delay) end;
sasl.setCSWheelInteractionDelay = setCSWheelInteractionDelay;

--- Returns delay in seconds between last mouse zoom event and first possible
--- mouse wheel custom event handling.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSWheelInteractionDelay
function getCSWheelInteractionDelay() end;
sasl.getCSWheelInteractionDelay = getCSWheelInteractionDelay;

--- Sets special flag for auxiliary click system to ignore mouse wheel events
--- one update cycle.
--- @param flag number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setCSPassWheelEventFlag
function setCSPassWheelEventFlag(flag) end;
sasl.setCSPassWheelEventFlag = setCSPassWheelEventFlag;

--- [DEPRECATED] Sets the scale of the drawn custom cursor.
--- @param scale number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setCSCursorScale
function setCSCursorScale(scale) end;
sasl.setCSCursorScale = setCSCursorScale;

--- Gets current mouse down state for mouse button, specified by buttonID.
--- @param buttonID MouseButton
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSClickDown
function getCSClickDown(buttonID) end;
sasl.getCSClickDown = getCSClickDown;

--- Gets current mouse up state for mouse button, specified by buttonID.
--- @param buttonID MouseButton
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSClickUp
function getCSClickUp(buttonID) end;
sasl.getCSClickUp = getCSClickUp;

--- Gets current mouse hold state for mouse button, specified by buttonID.
--- @param buttonID MouseButton
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSClickHold
function getCSClickHold(buttonID) end;
sasl.getCSClickHold = getCSClickHold;

--- Gets current mouse double-click state for mouse button, specified by buttonID.
--- @param buttonID MouseButton
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSDoubleClick
function getCSDoubleClick(buttonID) end;
sasl.getCSDoubleClick = getCSDoubleClick;

--- Gets the number of performed wheel clicks.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSWheelClicks
function getCSWheelClicks() end;
sasl.getCSWheelClicks = getCSWheelClicks;

--- Gets current abscissa coordinate of mouse pointer in simulator window.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSMouseXPos
function getCSMouseXPos() end;
sasl.getCSMouseXPos = getCSMouseXPos;

--- Gets current ordinate coordinate of mouse pointer in simulator window.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSMouseYPos
function getCSMouseYPos() end;
sasl.getCSMouseYPos = getCSMouseYPos;

--- Gets dragging direction.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSDragDirection
function getCSDragDirection() end;
sasl.getCSDragDirection = getCSDragDirection;

--- Gets dragging value.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSDragValue
function getCSDragValue() end;
sasl.getCSDragValue = getCSDragValue;

--- Determines if cursor is currently on SASL window context.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSCursorOnInterface
function getCSCursorOnInterface() end;
sasl.getCSCursorOnInterface = getCSCursorOnInterface;

--- Determines if mouse cursor is currently on 3D panel.
--- @return boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSMouseIsOnPanel
function getCSMouseIsOnPanel() end;
sasl.getCSMouseIsOnPanel = getCSMouseIsOnPanel;

--- Returns 3D panel mouse position in texture coordinates (0.0 − 1.0)
--- in case if mouse is currently on 3D panel and returns nil otherwise.
--- @return number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getCSPanelMousePos
function getCSPanelMousePos() end;
sasl.getCSPanelMousePos = getCSPanelMousePos;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class AsciiKeyCode

--- @class VirtualKeyCode

--- @class KeyEventType
KB_DOWN_EVENT = nil
KB_UP_EVENT = nil
KB_HOLD_EVENT = nil

--- Registers keyboard input callback.
--- @param callback fun(char:AsciiKeyCode, key:VirtualKeyCode, shiftDown:number, ctrlDown:number, altOptDown:number, event:KeyEventType):void
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#registerGlobalKeyHandler
function registerGlobalKeyHandler(callback) end;
sasl.registerGlobalKeyHandler = registerGlobalKeyHandler;

--- Unregisters keyboard input callback, specified with numeric identifier id.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#unregisterGlobalKeyHandler
function unregisterGlobalKeyHandler(id) end;
sasl.unregisterGlobalKeyHandler = unregisterGlobalKeyHandler;

--- Registers new Hot Key ID.
--- @param key VirtualKeyCode
--- @param shiftDown number
--- @param ctrlDown number
--- @param altOptDown number
--- @param description string
--- @param callback fun():void
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#registerHotKey
function registerHotKey(key, shiftDown, ctrlDown, altOptDown, description, callback) end;
sasl.registerHotKey = registerHotKey;

--- Unregisters Hot Key, specified by numeric identifier id.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#unregisterHotKey
function unregisterHotKey(id) end;
sasl.unregisterHotKey = unregisterHotKey;

--- Sets key combination for the Hot Key.
--- @param id number
--- @param key VirtualKeyCode
--- @param shiftDown number
--- @param ctrlDown number
--- @param altOptDown number
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setHotKeyCombination
function setHotKeyCombination(id, key, shiftDown, ctrlDown, altOptDown) end;
sasl.setHotKeyCombination = setHotKeyCombination;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class NavAidType

NAV_UNKNOWN = nil
NAV_AIRPORT = nil
NAV_NDB = nil
NAV_VOR = nil
NAV_ILS = nil
NAV_LOCALIZER = nil
NAV_GLIDESLOPE = nil
NAV_OUTERMARKER = nil
NAV_MIDDLEMARKER = nil
NAV_INNERMARKER = nil
NAV_FIX = nil
NAV_DME = nil

--- @class NavAidID

NAV_NOT_FOUND = nil

--- Returns identifier of first entry in the navigation database.
--- @return NavAidID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getFirstNavAid
function getFirstNavAid() end;
sasl.getFirstNavAid = getFirstNavAid;

--- Returns identifier of the navigation point which next to the point with id
--- identifier.
--- @param id NavAidID
--- @return NavAidID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getNextNavAid
function getNextNavAid(id) end;
sasl.getNextNavAid = getNextNavAid;

--- Returns identifier of first navigation point of specified type in database.
--- @param type NavAidType
--- @return NavAidID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#findFirstNavAidOfType
function findFirstNavAidOfType(type) end;
sasl.findFirstNavAidOfType = findFirstNavAidOfType;

--- Returns identifier of last navigation point of specified type in database.
--- @param type NavAidType
--- @return NavAidID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#findLastNavAidOfType
function findLastNavAidOfType(type) end;
sasl.findLastNavAidOfType = findLastNavAidOfType;

--- Search in database for navigation points.
--- @param fragmentName string
--- @param fragmentID string
--- @param latitude number
--- @param longitude number
--- @param frequency number
--- @param type NavAidType
--- @return NavAidID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#findNavAid
function findNavAid(fragmentName, fragmentID, latitude, longitude, frequency, type) end;
sasl.findNavAid = findNavAid;

--- Returns all available information about navigation point, represented by identifier id.
--- @param id NavAidID
--- @return NavAidType, number, number, number, number, number, string, string, boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getNavAidInfo
function getNavAidInfo(id) end;
sasl.getNavAidInfo = getNavAidInfo;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns number of entries in FMS.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#countFMSEntries
function countFMSEntries() end;
sasl.countFMSEntries = countFMSEntries;

--- Returns index of entry, displayed on FMS.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getDisplayedFMSEntry
function getDisplayedFMSEntry() end;
sasl.getDisplayedFMSEntry = getDisplayedFMSEntry;

--- Returns index of entry aircraft flying to.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getDestinationFMSEntry
function getDestinationFMSEntry() end;
sasl.getDestinationFMSEntry = getDestinationFMSEntry;

--- Sets displayed FMS entry with specified index.
--- @param index number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setDisplayedFMSEntry
function setDisplayedFMSEntry(index) end;
sasl.setDisplayedFMSEntry = setDisplayedFMSEntry;

--- Changes which entry the FMS is flying the aircraft toward.
--- @param index number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setDestinationFMSEntry
function setDestinationFMSEntry(index) end;
sasl.setDestinationFMSEntry = setDestinationFMSEntry;

--- Returns information about FMS entry.
--- @param index number
--- @return NavAidType, string, NavAidID, number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getFMSEntryInfo
function getFMSEntryInfo(index) end;
sasl.getFMSEntryInfo = getFMSEntryInfo;

--- Changes entry in FMS at specified index to navigation point which
--- corresponds to id argument.
--- @param index number
--- @param id NavAidID
--- @param altitude number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFMSEntryInfo
function setFMSEntryInfo(index, id, altitude) end;
sasl.setFMSEntryInfo = setFMSEntryInfo;

--- Changes the entry in the FMS to a latitude/longitude entry with the given
--- coordinates.
--- @param index number
--- @param latitude number
--- @param longitude number
--- @param altitude number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFMSEntryLatLon
function setFMSEntryLatLon(index, latitude, longitude, altitude) end;
sasl.setFMSEntryLatLon = setFMSEntryLatLon;

--- Clears the given entry, specified by index, potentially shortening the
--- flight plan.
--- @return NavAidType
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#clearFMSEntry
function clearFMSEntry() end;
sasl.clearFMSEntry = clearFMSEntry;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns the type of currently selected GPS destination, one of fix, airport,
--- VOR or NDB.
--- @return NavAidType
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getGPSDestinationType
function getGPSDestinationType() end;
sasl.getGPSDestinationType = getGPSDestinationType;

--- Returns identifier of the navigation point, which is current GPS destination.
--- @return NavAidID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getGPSDestination
function getGPSDestination() end;
sasl.getGPSDestination = getGPSDestination;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class TerrainProbeResult

PROBE_HIT_TERRAIN = nil
PROBE_ERROR = nil
PROBE_MISSED = nil

--- [DEPRECATED] Draws simulator object, specified by numeric identifier id.
--- @param id number
--- @param x number
--- @param y number
--- @param z number
--- @param pitch number
--- @param heading number
--- @param roll number
--- @param lighting number
--- @param earthRelative number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawObject
function drawObject(id, x, y, z, pitch, heading, roll, lighting, earthRelative) end;
sasl.drawObject = drawObject;

--- Reloads simulator scenery files.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#reloadScenery
function reloadScenery() end;
sasl.reloadScenery = reloadScenery;

--- Converts simulator world coordinates to local OpenGL coordinates.
--- @param latitude number
--- @param longitude number
--- @param altitude number
--- @return number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#worldToLocal
function worldToLocal(latitude, longitude, altitude) end;
sasl.worldToLocal = worldToLocal;

--- Converts simulator local OpenGL coordinates to world coordinates.
--- @param x number
--- @param y number
--- @param z number
--- @return number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#localToWorld
function localToWorld(x, y, z) end;
sasl.localToWorld = localToWorld;

--- Converts aircraft model OpenGL coordinates (with origin in aircraft center and
--- aircraft orientation) to local OpenGL coordinates.
--- @param u number
--- @param v number
--- @param w number
--- @return number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#modelToLocal
function modelToLocal(u, v, w) end;
sasl.modelToLocal = modelToLocal;

--- Converts local OpenGL coordinates to the aircraft OpenGL model coordinates
--- (with origin in aircraft center and aircraft orientation).
--- @param x number
--- @param y number
--- @param z number
--- @return number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#localToModel
function localToModel(x, y, z) end;
sasl.localToModel = localToModel;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Locates physical scenery terrain mesh.
--- @param x number
--- @param y number
--- @param z number
--- @return TerrainProbeResult, number, number, number, number, number, number, number, number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#probeTerrain
function probeTerrain(x, y, z) end;
sasl.probeTerrain = probeTerrain;

--- Returns magnetic variation (declination) corresponding to the geographic
--- location, identified by latitude and longitude.
--- @param latitude number
--- @param longitude number
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getMagneticVariation
function getMagneticVariation(latitude, longitude) end;
sasl.getMagneticVariation = getMagneticVariation;

--- Converts a heading in degrees relative to magnetic north at the user’s current
--- location into a value relative to true north.
--- @param heading number
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#degMagneticToDegTrue
function degMagneticToDegTrue(heading) end;
sasl.degMagneticToDegTrue = degMagneticToDegTrue;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Creates a new instance of the object based on the objectId object identifier.
--- @param objectId number
--- @param datarefs string[]
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createInstance
function createInstance(objectId, datarefs) end;
sasl.createInstance = createInstance;

--- Destroys an instance of the object with instanceId identifier.
--- @param instanceId number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#destroyInstance
function destroyInstance(instanceId) end;
sasl.destroyInstance = destroyInstance;

--- Sets position and dataref values for the object instance, specified by numeric
--- identifier instanceId.
--- @param instanceId number
--- @param x number
--- @param y number
--- @param z number
--- @param pitch number
--- @param heading number
--- @param roll number
--- @param data table
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setInstancePosition
function setInstancePosition(instanceId, x, y, z, pitch, heading, roll, data) end;
sasl.setInstancePosition = setInstancePosition;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class Color

--- @class ShapeExtrusionMode

SHAPE_EXTRUDE_INNER = nil
SHAPE_EXTRUDE_OUTER = nil
SHAPE_EXTRUDE_CENTER = nil

--- Draws line between x1, y1 point and x2, y2 point with specified color.
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawLine
function drawLine(x1, y1, x2, y2, color) end;
gl.drawLine = drawLine;

--- Draws wide line between x1, y1 point and x2, y2 point with specified color and with
--- specified thickness.
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @param thickness number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawWideLine
function drawWideLine(x1, y1, x2, y2, thickness, color) end;
gl.drawWideLine = drawWideLine;

--- Draws poly-line between specified points with specified color.
--- @param points table
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawPolyLine
function drawPolyLine(points, color) end;
gl.drawPolyLine = drawPolyLine;

--- Acts like drawPolyLine function, but takes line thickness parameter into account.
--- @param points table
--- @param thickness number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawWidePolyLine
function drawWidePolyLine(points, thickness, color) end;
gl.drawWidePolyLine = drawWidePolyLine;

--- Draws filled triangle by given points x1, y1, x2, y2 and x3, y3 with specified color.
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @param x3 number
--- @param y3 number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawTriangle
function drawTriangle(x1, y1, x2, y2, x3, y3, color) end;
gl.drawTriangle = drawTriangle;

--- Draws filled rectangle, specified by x, y, width and height with specified color.
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawRectangle
function drawRectangle(x, y, width, height, color) end;
gl.drawRectangle = drawRectangle;

--- Draws frame, specified by x, y, width and height with specified color.
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawFrame
function drawFrame(x, y, width, height, color) end;
gl.drawFrame = drawFrame;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Sets current line pattern, which will be used with drawLinePattern function.
--- @param pattern table
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setLinePattern
function setLinePattern(pattern) end;
gl.setLinePattern = setLinePattern;

--- Draws line between x1, y1 and x2, y2 points using pattern and specified color.
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @param savePatternState boolean
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawLinePattern
function drawLinePattern(x1, y1, x2, y2, savePatternState, color) end;
gl.drawLinePattern = drawLinePattern;

--- Acts like drawLinePattern function, but draws poly-line with current selected pattern.
--- @param points table
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawPolyLinePattern
function drawPolyLinePattern(points, color) end;
gl.drawPolyLinePattern = drawPolyLinePattern;

--- Draws line between x1, y1 and x2, y2 points using pattern and specified color.
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @param x3 number
--- @param y3 number
--- @param parts number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawBezierLineQ
function drawBezierLineQ(x1, y1, x2, y2, x3, y3, parts, color) end;
gl.drawBezierLineQ = drawBezierLineQ;

--- Works as drawBezierLineQ function, but draws Bezier line with specific thickness.
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @param x3 number
--- @param y3 number
--- @param parts number
--- @param thickness number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawWideBezierLineQ
function drawWideBezierLineQ(x1, y1, x2, y2, x3, y3, parts, thickness, color) end;
gl.drawWideBezierLineQ = drawWideBezierLineQ;

--- Draws curved quadratic Bezier line, specified by anchor points x1, y1 and x3, y3,
--- and control point x2, y2.
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @param x3 number
--- @param y3 number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawBezierLineQAdaptive
function drawBezierLineQAdaptive(x1, y1, x2, y2, x3, y3, color) end;
gl.drawBezierLineQAdaptive = drawBezierLineQAdaptive;

--- Works as drawBezierLineQAdaptive function, but draws Bezier line with specific
--- thickness.
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @param x3 number
--- @param y3 number
--- @param thickness number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawWideBezierLineQAdaptive
function drawWideBezierLineQAdaptive(x1, y1, x2, y2, x3, y3, thickness, color) end;
gl.drawWideBezierLineQAdaptive = drawWideBezierLineQAdaptive;

--- Draws curved cubic Bezier line, specified by anchor points x1, y1 and x4, y4, and
--- control points x2, y2 and x3, y3.
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @param x3 number
--- @param y3 number
--- @param x4 number
--- @param y4 number
--- @param parts number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawBezierLineC
function drawBezierLineC(x1, y1, x2, y2, x3, y3, x4, y4, parts, color) end;
gl.drawBezierLineC = drawBezierLineC;

--- Works as drawBezierLineC function, but draws Bezier line with specific thickness.
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @param x3 number
--- @param y3 number
--- @param x4 number
--- @param y4 number
--- @param parts number
--- @param thickness number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawWideBezierLineC
function drawWideBezierLineC(x1, y1, x2, y2, x3, y3, x4, y4, parts, thickness, color) end;
gl.drawWideBezierLineC = drawWideBezierLineC;

--- Draws curved cubic Bezier line, specified by anchor points x1, y1 and x4, y4, and
--- control points x2, y2 and x3, y3.
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @param x3 number
--- @param y3 number
--- @param x4 number
--- @param y4 number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawBezierLineCAdaptive
function drawBezierLineCAdaptive(x1, y1, x2, y2, x3, y3, x4, y4, color) end;
gl.drawBezierLineCAdaptive = drawBezierLineCAdaptive;

--- Works as drawBezierLineCAdaptive function, but draws Bezier line with specific
--- thickness.
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @param x3 number
--- @param y3 number
--- @param x4 number
--- @param y4 number
--- @param thickness number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawWideBezierLineCAdaptive
function drawWideBezierLineCAdaptive(x1, y1, x2, y2, x3, y3, x4, y4, thickness, color) end;
gl.drawWideBezierLineCAdaptive = drawWideBezierLineCAdaptive;

--- Draws circle with center in x, y coordinates and specified radius.
--- @param x number
--- @param y number
--- @param radius number
--- @param isFilled boolean
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawCircle
function drawCircle(x, y, radius, isFilled, color) end;
gl.drawCircle = drawCircle;

--- Draws arc with center in x, y. radiusInner and radiusOuter defines arc form, arc
--- will be drawn between these distances.
--- @param x number
--- @param y number
--- @param radiusInner number
--- @param radiusOuter number
--- @param startAngle number
--- @param arcAngle number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawArc
function drawArc(x, y, radiusInner, radiusOuter, startAngle, arcAngle, color) end;
gl.drawArc = drawArc;

--- Draws arc with center in x, y and of specified radius.
--- @param x number
--- @param y number
--- @param radius number
--- @param startAngle number
--- @param arcAngle number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawArcLine
function drawArcLine(x, y, radius, startAngle, arcAngle, color) end;
gl.drawArcLine = drawArcLine;

--- Draws custom convex shape.
--- @param points table
--- @param isFilled boolean
--- @param thickness number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawConvexPolygon
function drawConvexPolygon(points, isFilled, thickness, color) end;
gl.drawConvexPolygon = drawConvexPolygon;

--- Draws custom convex shape with per-vertex color
--- @param points table
--- @param colors table
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawConvexPolygonMC
function drawConvexPolygonMC(points, colors) end;
gl.drawConvexPolygonMC = drawConvexPolygonMC;

--- Sets shape extrusion mode for drawing polygons.
--- @param mode ShapeExtrusionMode
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setPolygonExtrudeMode
function setPolygonExtrudeMode(mode) end;
gl.setPolygonExtrudeMode = setPolygonExtrudeMode;

--- Sets shape extrusion mode for wide lines drawing.
--- @param mode ShapeExtrusionMode
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setWideLineExtrudeMode
function setWideLineExtrudeMode(mode) end;
gl.setWideLineExtrudeMode = setWideLineExtrudeMode;

--- Wrapper around glLineWidth OpenGL function.
--- @param width number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setInternalLineWidth
function setInternalLineWidth(width) end;
gl.setInternalLineWidth = setInternalLineWidth;

--- Wrapper around glLineStipple OpenGL function.
--- @param enabled boolean
--- @overload fun(enabled: boolean, factor: number, pattern: number):void
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setInternalLineStipple
function setInternalLineStipple(enabled) end;
gl.setInternalLineStipple = setInternalLineStipple;

--- Saves to the settings stack current OpenGL internal line settings like width, pattern
--- and stipple to be able restoreInternalLineState() in future.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#saveInternalLineState
function saveInternalLineState() end;
gl.saveInternalLineState = saveInternalLineState;

--- Restores from the settings stack OpenGL internal line settings like width, pattern
--- and stipple.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#restoreInternalLineState
function restoreInternalLineState() end;
gl.restoreInternalLineState = restoreInternalLineState;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class TextureWrappingMode

TEXTURE_CLAMP = nil
TEXTURE_REPEAT = nil
TEXTURE_MIRROR_CLAMP = nil
TEXTURE_MIRROR_REPEAT = nil

--- Draws texture specified by numeric texture handle id at position, specified by
--- coordinates x, y.
--- @param id number
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawTexture
function drawTexture(id, x, y, width, height, color) end;
gl.drawTexture = drawTexture;

--- Draws texture specified by numeric texture handle id at position, specified by
--- coordinates x, y, rotated around texture center by angle in degrees.
--- @param id number
--- @param angle number
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawRotatedTexture
function drawRotatedTexture(id, angle, x, y, width, height, color) end;
gl.drawRotatedTexture = drawRotatedTexture;

--- Draws texture specified by numeric texture handle id at position, specified by
--- coordinates x, y, rotated around rx, ry point by angle in degrees.
--- @param id number
--- @param angle number
--- @param rx number
--- @param ry number
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawRotatedTextureCenter
function drawRotatedTextureCenter(id, angle, rx, ry, x, y, width, height, color) end;
gl.drawRotatedTextureCenter = drawRotatedTextureCenter;

--- Draws texture like drawTexture function, but only the part of specified texture will
--- be drawn.
--- @param id number
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param tx number
--- @param ty number
--- @param twidth number
--- @param theight number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawTexturePart
function drawTexturePart(id, x, y, width, height, tx, ty, twidth, theight, color) end;
gl.drawTexturePart = drawTexturePart;

--- Draws texture like drawRotatedTexture function, but only the part of specified texture
--- will be drawn.
--- @param id number
--- @param angle number
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param tx number
--- @param ty number
--- @param twidth number
--- @param theight number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawRotatedTexturePart
function drawRotatedTexturePart(id, angle, x, y, width, height, tx, ty, twidth, theight, color) end;
gl.drawRotatedTexturePart = drawRotatedTexturePart;

--- Draws texture like drawRotatedTextureCenter function, but only the part of
--- specified texture will be drawn.
--- @param id number
--- @param angle number
--- @param rx number
--- @param ry number
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param tx number
--- @param ty number
--- @param twidth number
--- @param theight number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawRotatedTexturePartCenter
function drawRotatedTexturePartCenter(id, angle, rx, ry, x, y, width, height, tx, ty, twidth, theight, color) end;
gl.drawRotatedTexturePartCenter = drawRotatedTexturePartCenter;

--- Draws texture specified by numeric texture handle id using four points to
---specify drawn shape.
--- @param id number
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @param x3 number
--- @param y3 number
--- @param x4 number
--- @param y4 number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawTextureCoords
function drawTextureCoords(id, x1, y1, x2, y2, x3, y3, x4, y4, color) end;
gl.drawTextureCoords = drawTextureCoords;

--- Draws texture specified by numeric texture handle id at position, specified by x, y,
--- width, height.
--- @param id number
--- @param angle number
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param tx number
--- @param ty number
--- @param twidth number
--- @param theight number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawTextureWithRotatedCoords
function drawTextureWithRotatedCoords(id, angle, x, y, width, height, tx, ty, twidth, theight) end;
gl.drawTextureWithRotatedCoords = drawTextureWithRotatedCoords;

--- Returns width and height of texture, specified by numeric texture handle id.
--- @param id number
--- @return number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getTextureSize
function getTextureSize(id) end;
gl.getTextureSize = getTextureSize;

--- Same as getTextureSize.
--- @param id number
--- @return number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getTextureSourceSize
function getTextureSourceSize(id) end;
gl.getTextureSourceSize = getTextureSourceSize;

--- Same as getTextureSize.
--- @param id number
--- @param mode TextureWrappingMode
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setTextureWrapping
function setTextureWrapping(id, mode) end;
gl.setTextureWrapping = setTextureWrapping;

--- @class SpecID

GENERAL_INTERFACE_TEX = nil
AIRCRAFT_PAINT_TEX = nil
AIRCRAFT_LITE_MAP_TEX = nil

--- Imports specific texture with identifier inSpecID in SASL textures system and returns
--- numeric texture handle of imported texture - id.
--- @param inSpecID SpecID
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#importTexture
function importTexture(inSpecID) end;
gl.importTexture = importTexture;

--- Exports specific texture with identifier inSpecID from SASL textures system and
--- returns underlying graphics API texture handler.
--- @param inSpecID SpecID
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#exportTexture
function exportTexture(inSpecID) end;
gl.exportTexture = exportTexture;

--- Recreates texture specified by numeric identifier id with new width and height.
--- @param id number
--- @param width number
--- @param height number
--- @param saveContents boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#recreateTexture
function recreateTexture(id, width, height, saveContents) end;
gl.recreateTexture = recreateTexture;

--- Start rendering into texture, specified by numeric handle id.
--- @param id number
--- @param isNeedClear boolean
--- @param inAALevel number
--- @overload fun(id:number):void
--- @overload fun(id:number, isNeedClear:boolean):void
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setRenderTarget
function setRenderTarget(id, isNeedClear, inAALevel) end;
gl.setRenderTarget = setRenderTarget;

--- Clears rectangular area of current render target.
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#clearRenderTarget
function clearRenderTarget(x, y, width, height) end;
gl.clearRenderTarget = clearRenderTarget;

--- Finishes rendering to texture and continue rendering to default render target.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#restoreRenderTarget
function restoreRenderTarget() end;
gl.restoreRenderTarget = restoreRenderTarget;

--- @class RenderTargetAttachment
RENDER_TARGET_C = nil
RENDER_TARGET_CDS = nil

--- Generates new RGBA texture that can be used as render target and returns its numeric
--- handle id.
--- @param width number
--- @param height number
--- @param aaLevel number
--- @param attachment RenderTargetAttachment
--- @overload fun(width:number, height:number):number
--- @overload fun(width:number, height:number, aaLevel:number):number
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createRenderTarget
function createRenderTarget(width, height, aaLevel, attachment) end;
gl.createRenderTarget = createRenderTarget;

--- Destroys render target specified by id, previously created with createRenderTarget
--- function.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#destroyRenderTarget
function destroyRenderTarget(id) end;
gl.destroyRenderTarget = destroyRenderTarget;

--- Creates new RGBA texture and returns its numeric handle id.
--- @param width number
--- @param height number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createTexture
function createTexture(width, height) end;
gl.createTexture = createTexture;

--- Copies current data from render target to texture, specified by numeric identifier id.
--- @param id number
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getTargetTextureData
function getTargetTextureData(id, x, y, width, height) end;
gl.getTargetTextureData = getTargetTextureData;

--- Creates new texture data storage object and returns its numeric identifier id.
--- @param width number
--- @param height number
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createTextureDataStorage
function createTextureDataStorage(width, height) end;
gl.createTextureDataStorage = createTextureDataStorage;

--- Deletes texture data storage object, specified by numeric handle id.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#deleteTextureDataStorage
function deleteTextureDataStorage(id) end;
gl.deleteTextureDataStorage = deleteTextureDataStorage;

--- Returns raw texture data, stored in storage with specified numeric identifier id.
--- @param id number
--- @return userdata
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getTextureDataPointer
function getTextureDataPointer(id) end;
gl.getTextureDataPointer = getTextureDataPointer;

--- Fills storage, specified by numeric handle storageID, by texture raw data and
--- returns this data.
--- @param textID number
--- @param storageID number
--- @return userdata
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getRawTextureData
function getRawTextureData(textID, storageID) end;
gl.getRawTextureData = getRawTextureData;

--- Updates texture, specified by numeric handle texID, with current storage data.
--- @param textID number
--- @param storageID number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setRawTextureData
function setRawTextureData(textID, storageID) end;
gl.setRawTextureData = setRawTextureData;

--- Saves texture, specified by numeric handle texID, in file.
--- @param filename string
--- @param texID number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#imageFromTexture
function imageFromTexture(filename, texID) end;
gl.imageFromTexture = imageFromTexture;

--- @class FontHinterPreference
FONT_HINTER_AUTO = nil
FONT_HINTER_NATIVE = nil
FONT_HINTER_DISABLED = nil

--- @class TextAlignment

TEXT_ALIGN_LEFT = nil
TEXT_ALIGN_RIGHT = nil
TEXT_ALIGN_CENTER = nil
TEXT_ALIGN_TOP = nil
TEXT_ALIGN_BOTTOM = nil

--- Draws text string at specified position x, y using bitmap font, specified by
--- numeric identifier id.
--- @param id number
--- @param x number
--- @param y number
--- @param text string
--- @param alignment TextAlignment
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawBitmapText
function drawBitmapText(id, x, y, text, alignment, color) end;
gl.drawBitmapText = drawBitmapText;

--- Draws text string at specified position x, y using bitmap font, specified by
--- numeric identifier id.
--- @param id number
--- @param cx number
--- @param cy number
--- @param angle number
--- @param x number
--- @param y number
--- @param text string
--- @param alignment TextAlignment
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawRotatedBitmapText
function drawRotatedBitmapText(id, cx, cy, angle, x, y, text, alignment, color) end;
gl.drawRotatedBitmapText = drawRotatedBitmapText;

--- Measures text string using bitmap font, specified by numeric identifier id.
--- @param id number
--- @param text string
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#measureBitmapText
function measureBitmapText(id, text) end;
gl.measureBitmapText = measureBitmapText;

--- Measures text string using bitmap font, specified by numeric identifier id.
--- @param id number
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#measureBitmapTextGlyphs
function measureBitmapTextGlyphs(id, text) end;
gl.measureBitmapTextGlyphs = measureBitmapTextGlyphs;

--- Sets outline thickness for font instance, specified by numeric font instance
--- handle id.
--- @param id number
--- @param outlineThickness number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFontOutlineThickness
function setFontOutlineThickness(id, outlineThickness) end;
gl.setFontOutlineThickness = setFontOutlineThickness;

--- Sets outline color for font instance, specified by id.
--- @param id number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFontOutlineColor
function setFontOutlineColor(id, color) end;
gl.setFontOutlineColor = setFontOutlineColor;

--- @class FontRenderMode

TEXT_RENDER_DEFAULT = nil
TEXT_RENDER_FORCED_MONO = nil

--- Sets outline color for font instance, specified by id.
--- @param id number
--- @param mode FontRenderMode
--- @param value number
--- @overload fun(id:number, mode:FontRenderMode):void
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFontRenderMode
function setFontRenderMode(id, mode, value) end;
gl.setFontRenderMode = setFontRenderMode;

--- Sets render mode for font instance, specified by id.
--- @param id number
--- @param mode FontRenderMode
--- @param value number
--- @overload fun(id:number, mode:FontRenderMode):void
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFontRenderMode
function setFontRenderMode(id, mode, value) end;
gl.setFontRenderMode = setFontRenderMode;

--- Sets size for font instance, specified by id.
--- @param id number
--- @param size number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFontSize
function setFontSize(id, size) end;
gl.setFontSize = setFontSize;

--- @class FontDirectionMode

TEXT_DIRECTION_HORIZONTAL = nil
TEXT_DIRECTION_VERTICAL = nil

--- Sets direction for font instance, specified by id.
--- @param id number
--- @param mode FontDirectionMode
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFontDirection
function setFontDirection(id, mode) end;
gl.setFontDirection = setFontDirection;

--- Enables/disables bold mode for font instance, specified by id.
--- @param id number
--- @param isBold boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFontBold
function setFontBold(id, isBold) end;
sasl.gl.setFontBold = setFontBold;

--- Enables/disables italic mode for font instance, specified by id.
--- @param id number
--- @param isItalic boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFontItalic
function setFontItalic(id, isItalic) end;
gl.setFontItalic = setFontItalic;

--- @class TextBckMode

TEXT_BCK_NONE = nil
TEXT_BCK_STANDARD = nil
TEXT_BCK_RECTANGLE = nil

--- Sets text background rendering mode for font instance, specified by id.
--- @param id number
--- @param mode TextBckMode
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFontBckMode
function setFontBckMode(id, mode) end;
gl.setFontBckMode = setFontBckMode;

--- Sets background color for font instance, specified by id.
--- @param id number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFontBckColor
function setFontBckColor(id, color) end;
gl.setFontBckColor = setFontBckColor;

--- Sets text background padding values for font instance, specified by id.
--- @param id number
--- @param left number
--- @param top number
--- @param right number
--- @param bottom number
--- @overload fun(id:number, left:number):void
--- @overload fun(id:number, left:number, top:number):void
--- @overload fun(id:number, left:number, top:number, bottom:number):void
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFontBckPadding
function setFontBckPadding(id, left, top, right, bottom) end;
gl.setFontBckPadding = setFontBckPadding;

--- Sets glyph spacing factor for font instance, specified by id.
--- @param id number
--- @param factor number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFontGlyphSpacingFactor
function setFontGlyphSpacingFactor(id, factor) end;
gl.setFontGlyphSpacingFactor = setFontGlyphSpacingFactor;

--- Enables/disables Unicode glyphs support for the font instance (id).
--- @param id number
--- @param unicode boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setFontUnicode
function setFontUnicode(id, unicode) end;
gl.setFontUnicode = setFontUnicode;

--- Saves current font instance configuration on stack.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#saveFontState
function saveFontState(id) end;
gl.saveFontState = saveFontState;

--- Restores previously saved font instance configuration.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#restoreFontState
function restoreFontState(id) end;
gl.restoreFontState = restoreFontState;

--- Enables or disables special mode for text rendering.
--- @param enabled boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setRenderTextPixelAligned
function setRenderTextPixelAligned(enabled) end;
gl.setRenderTextPixelAligned = setRenderTextPixelAligned;

--- Draws text string at specified position x, y using font instance, specified
--- by numeric identifier id.
--- @param id number
--- @param x number
--- @param y number
--- @param text string
--- @param size string
--- @param isBold boolean
--- @param isItalic boolean
--- @param alignment TextAlignment
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawText
function drawText(id, x, y, text, size, isBold, isItalic, alignment, color) end;
gl.drawText = drawText;

--- Draws text string at specified position x, y using font instance, specified
--- by numeric identifier id.
--- @param id number
--- @param x number
--- @param y number
--- @param text string
--- @param alignment TextAlignment
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawTextI
function drawTextI(id, x, y, text, alignment, color) end;
gl.drawTextI = drawTextI;

--- Draws text string at specified position x, y using font instance, specified
--- by numeric identifier id.
--- @param id number
--- @param x number
--- @param y number
--- @param cx number
--- @param cy number
--- @param angle number
--- @param text string
--- @param size string
--- @param isBold boolean
--- @param isItalic boolean
--- @param alignment TextAlignment
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawRotatedText
function drawRotatedText(id, x, y, cx, cy, angle, text, size, isBold, isItalic, alignment, color) end;
gl.drawRotatedText = drawRotatedText;

--- Draws text string at specified position x, y using font instance, specified
--- by numeric identifier id.
--- @param id number
--- @param x number
--- @param y number
--- @param cx number
--- @param cy number
--- @param angle number
--- @param text string
--- @param alignment TextAlignment
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawRotatedTextI
function drawRotatedTextI(id, x, y, cx, cy, angle, text, alignment, color) end;
gl.drawRotatedTextI = drawRotatedTextI;

--- Measures text string using font instance, specified by numeric identifier id.
--- @param id number
--- @param text string
--- @param size number
--- @param isBold boolean
--- @param isItalic boolean
--- @return number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#measureText
function measureText(id, text, size, isBold, isItalic) end;
gl.measureText = measureText;

--- Measures text string using font instance, specified by numeric identifier id.
--- @param id number
--- @param text string
--- @param size number
--- @param isBold boolean
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#measureTextGlyphs
function measureTextGlyphs(id, text, size, isBold) end;
gl.measureTextGlyphs = measureTextGlyphs;

--- Measures text string using font instance, specified by numeric identifier id.
--- @param id number
--- @param text string
--- @return number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#measureTextI
function measureTextI(id, text) end;
gl.measureTextI = measureTextI;

--- Measures text string using font instance, specified by numeric identifier id.
--- @param id number
--- @param text string
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#measureTextGlyphsI
function measureTextGlyphsI(id, text) end;
gl.measureTextGlyphsI = measureTextGlyphsI;

--- Loads texture from data block.
--- @param data string
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @overload fun(data:string):number
--- @overload fun(data:string, width:number, height:number):number
--- @return number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#loadImageFromMemory
function loadImageFromMemory(data, x, y, width, height) end;
gl.loadImageFromMemory = loadImageFromMemory;

--- Loads texture from data block.
--- @param data string
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @overload fun(data:string):number
--- @overload fun(data:string, width:number, height:number):number
--- @return number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#loadImageFromMemory
function loadTextureFromMemory(data, x, y, width, height) end;
gl.loadTextureFromMemory = loadTextureFromMemory;

--- Unloads texture, specified by id.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#unloadImage
function unloadImage(id) end;
gl.unloadImage = unloadImage;

--- Unloads texture, specified by id.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#unloadImage
function unloadTexture(id) end;
gl.unloadTexture = unloadTexture;

--- Unloads font, specified by id.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#unloadFont
function unloadFont(id) end;
gl.unloadFont = unloadFont;

--- Draws texture used as glyphs storage for specified font
--- @param id number
--- @param x number
--- @param y number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawFontTexture
function drawFontTexture(id, x, y) end;
gl.drawFontTexture = drawFontTexture;

--- Returns string with information about font instance
--- @param id number
--- @return string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getFontInfo
function getFontInfo(id) end;
gl.getFontInfo = getFontInfo;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class ShaderTypeID

SHADER_TYPE_VERTEX = nil
SHADER_TYPE_FRAGMENT = nil
SHADER_TYPE_GEOMETRY = nil

--- @class ShaderUniformType

TYPE_INT = nil
TYPE_FLOAT = nil
TYPE_INT_ARRAY = nil
TYPE_FLOAT_ARRAY = nil
TYPE_SAMPLER = nil

--- Creates new empty shader program and returns its numeric identifier id.
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#createShaderProgram
function createShaderProgram() end;
gl.createShaderProgram = createShaderProgram;

--- Deletes shader program, specified by numeric identifier id.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#deleteShaderProgram
function deleteShaderProgram(id) end;
gl.deleteShaderProgram = deleteShaderProgram;

--- Links shader program, specified by numeric identifier id.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#linkShaderProgram
function linkShaderProgram(id) end;
gl.linkShaderProgram = linkShaderProgram;

--- Sets shader uniform variables with different types.
--- @param shaderID number
--- @param name string
--- @param type ShaderUniformType
--- @param data number | table
--- @param textureID number
--- @param textureUnit number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setShaderUniform
function setShaderUniform(shaderID, name, type, data, textureID, textureUnit) end;
gl.setShaderUniform = setShaderUniform;

--- Start using shader program, specified by numeric identifier id, for rendering.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#useShaderProgram
function useShaderProgram(id) end;
gl.useShaderProgram = useShaderProgram;

--- Stops shader program usage.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#stopShaderProgram
function stopShaderProgram() end;
gl.stopShaderProgram = stopShaderProgram;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- @class BlendFunctionID

BLEND_SOURCE_COLOR = nil
BLEND_ONE_MINUS_SOURCE_COLOR = nil
BLEND_SOURCE_ALPHA = nil
BLEND_ONE_MINUS_SOURCE_ALPHA = nil
BLEND_DESTINATION_ALPHA = nil
BLEND_ONE_MINUS_DESTINATION_ALPHA = nil
BLEND_DESTINATION_COLOR = nil
BLEND_ONE_MINUS_DESTINATION_COLOR = nil
BLEND_SOURCE_ALPHA_SATURATE = nil
BLEND_CONSTANT_COLOR = nil
BLEND_ONE_MINUS_CONSTANT_COLOR = nil
BLEND_CONSTANT_ALPHA = nil
BLEND_ONE_MINUS_CONSTANT_ALPHA = nil

--- @class BlendEquationID

BLEND_EQUATION_ADD = nil
BLEND_EQUATION_MIN = nil
BLEND_EQUATION_MAX = nil
BLEND_EQUATION_SUBTRACT = nil
BLEND_EQUATION_REVERSE_SUBTRACT = nil

--- Sets current blending functions for source and destination - sourceBlend and destBlend.
--- @param sourceBlend BlendFunctionID
--- @param destBlend BlendFunctionID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setBlendFunction
function setBlendFunction(sourceBlend, destBlend) end;
gl.setBlendFunction = setBlendFunction;

--- Sets current blending functions separately for RGB components and for alpha component.
--- @param sourceBlendRGB BlendFunctionID
--- @param destBlendRGB BlendFunctionID
--- @param sourceBlendAlpha BlendFunctionID
--- @param destBlendAlpha BlendFunctionID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setBlendFunctionSeparate
function setBlendFunctionSeparate(sourceBlendRGB, destBlendRGB, sourceBlendAlpha, destBlendAlpha) end;
gl.setBlendFunctionSeparate = setBlendFunctionSeparate;

--- Sets current blending equation, specified by identifier id.
--- @param id BlendEquationID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setBlendFunctionSeparate
function setBlendEquation(id) end;
gl.setBlendEquation = setBlendEquation;

--- Sets current blending equations separately for RGB components and for alpha component
--- - equationIDRGB and equationIDAlpha.
--- @param equationIDRGB BlendEquationID
--- @param equationIDAlpha BlendEquationID
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setBlendEquationSeparate
function setBlendEquationSeparate(equationIDRGB, equationIDAlpha) end;
gl.setBlendEquationSeparate = setBlendEquationSeparate;

--- Sets current blend color.
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setBlendColor
function setBlendColor(color) end;
gl.setBlendColor = setBlendColor;

--- Sets blending options to defaults.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#resetBlending
function resetBlending() end;
gl.resetBlending = resetBlending;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Setup current clipping area by rectangle position, defined by x, y, width and height.
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setClipArea
function setClipArea(x, y, width, height) end;
gl.setClipArea = setClipArea;

--- Resets current clip area.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#resetClipArea
function resetClipArea() end;
gl.resetClipArea = resetClipArea;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Enables masking for current mask level and prepares drawing context to draw mask shape.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawMaskStart
function drawMaskStart() end;
gl.drawMaskStart = drawMaskStart;

--- Prepares drawing context to draw under mask.
--- @param invertMaskLogic boolean
--- @overload fun():void
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawUnderMask
function drawUnderMask(invertMaskLogic) end;
gl.drawUnderMask = drawUnderMask;

--- Restores drawing context and previous drawing state, and disables masking.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawMaskEnd
function drawMaskEnd() end;
gl.drawMaskEnd = drawMaskEnd;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Saves current transformation matrix on the stack.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#saveGraphicsContext
function saveGraphicsContext() end;
gl.saveGraphicsContext = saveGraphicsContext;

--- Restores previous transformation matrix.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#restoreGraphicsContext
function restoreGraphicsContext() end;
gl.restoreGraphicsContext = restoreGraphicsContext;

--- Multiplies current transformation matrix on translation matrix, specified by translation
--- coordinates x, y.
--- @param x number
--- @param y number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setTranslateTransform
function setTranslateTransform(x, y) end;
gl.setTranslateTransform = setTranslateTransform;

--- Multiplies current transformation matrix on rotation matrix to rotate current context
--- on angle degrees.
--- @param angle number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setRotateTransform
function setRotateTransform(angle) end;
gl.setRotateTransform = setRotateTransform;

--- Multiplies current transformation matrix on scaling matrix, specified by scaling factors
--- scaleX, scaleY.
--- @param scaleX number
--- @param scaleY number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setScaleTransform
function setScaleTransform(scaleX, scaleY) end;
gl.setScaleTransform = setScaleTransform;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Returns true in case if SASL now draws in lit stage, and returns false otherwise.
--- @return boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#isLitStage
function isLitStage() end;
gl.isLitStage = isLitStage;

--- Returns true in case if SASL now draws in non-lit stage, and returns false otherwise.
--- @return boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#isNonLitStage
function isNonLitStage() end;
gl.isNonLitStage = isNonLitStage;

--- Returns true in case if SASL now draws before X-Plane, and returns false otherwise.
--- @return boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#isPanelBeforeStage
function isPanelBeforeStage() end;
gl.isPanelBeforeStage = isPanelBeforeStage;

--- Returns true in case if SASL now draws after X-Plane, and returns false otherwise.
--- @return boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#isPanelAfterStage
function isPanelAfterStage() end;
gl.isPanelAfterStage = isPanelAfterStage;

--- Starts telemetry recording (info about processed vertices and batches)
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#startGraphicsTelemetry
function startGraphicsTelemetry() end;
gl.startGraphicsTelemetry = startGraphicsTelemetry

--- Stops telemetry recording and returns amount of vertices and batches since start of record.
--- @return number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#stopGraphicsTelemetry
function stopGraphicsTelemetry() end;
gl.stopGraphicsTelemetry = stopGraphicsTelemetry

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- [DEPRECATED] Draws 3D line between x1, y1, z1 and x2, y2, z2 points with specified color in
--- OpenGL local 3D coordinates.
--- @param x1 number
--- @param y1 number
--- @param z1 number
--- @param x2 number
--- @param y2 number
--- @param z2 number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawLine3D
function drawLine3D(x1, y1, z1, x2, y2, z2, color) end;
gl.drawLine3D = drawLine3D;

--- [DEPRECATED] Draws 3D triangle, specified by x1, y1, z1 and x2, y2, z2 and x3, y3, z3 points with
--- specified color in OpenGL local 3D coordinates.
--- @param x1 number
--- @param y1 number
--- @param z1 number
--- @param x2 number
--- @param y2 number
--- @param z2 number
--- @param x3 number
--- @param y3 number
--- @param z3 number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawTriangle3D
function drawTriangle3D(x1, y1, z1, x2, y2, z2, x3, y3, z3, color) end;
gl.drawTriangle3D = drawTriangle3D;

--- [DEPRECATED] Draws 3D circle, specified by center and circle parameters
--- specified color in OpenGL local 3D coordinates.
--- @param x number
--- @param y number
--- @param z number
--- @param radius number
--- @param pitch number
--- @param yaw number
--- @param isFilled boolean
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawCircle3D
function drawCircle3D(x, y, z, radius, pitch, yaw, isFilled, color) end;
gl.drawCircle3D = drawCircle3D;

--- [DEPRECATED] Draws 3D angle, centered at x, y, z and angular width angle, with specified length,
--- made out of rays count.
--- @param x number
--- @param y number
--- @param z number
--- @param angle number
--- @param length number
--- @param rays number
--- @param pitch number
--- @param yaw number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawAngle3D
function drawAngle3D(x, y, z, angle, length, rays, pitch, yaw, color) end;
gl.drawAngle3D = drawAngle3D;

--- [DEPRECATED] Draws standing 3D cone at x, y, z with radius and height.
--- @param x number
--- @param y number
--- @param z number
--- @param radius number
--- @param height number
--- @param color Color
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#drawStandingCone3D
function drawStandingCone3D(x, y, z, radius, height, color) end;
gl.drawStandingCone3D = drawStandingCone3D;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- [DEPRECATED] Saves current transformation matrix on the stack.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#saveGraphicsState3D
function saveGraphicsState3D() end;
gl.saveGraphicsState3D = saveGraphicsState3D;

--- [DEPRECATED] Restores previous transformation matrix state.
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#restoreGraphicsContext3D
function restoreGraphicsContext3D() end;
gl.restoreGraphicsContext3D = restoreGraphicsContext3D;

--- [DEPRECATED] Multiplies current transformation matrix on translation matrix, specified by translation
--- coordinates x, y, z.
--- @param x number
--- @param y number
--- @param z number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setTranslateTransform3D
function setTranslateTransform3D(x, y, z) end;
gl.setTranslateTransform3D = setTranslateTransform3D;

--- [DEPRECATED] Multiplies current transformation matrix on rotation matrix around X axis, specified by
--- angle in degrees.
--- @param angle number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setRotateTransformX3D
function setRotateTransformX3D(angle) end;
gl.setRotateTransformX3D = setRotateTransformX3D;

--- [DEPRECATED] Multiplies current transformation matrix on rotation matrix around Y axis, specified by
--- angle in degrees.
--- @param angle number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setRotateTransformY3D
function setRotateTransformY3D(angle) end;
gl.setRotateTransformY3D = setRotateTransformY3D;

--- [DEPRECATED] Multiplies current transformation matrix on rotation matrix around vector, specified by
--- x, y and z coordinates.
--- @param angle number
--- @param x number
--- @param y number
--- @param z number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setRotateTransform3D
function setRotateTransform3D(angle, x, y, z) end;
gl.setRotateTransform3D = setRotateTransform3D;

--- [DEPRECATED] Multiplies current transformation matrix on scaling matrix, specified by scaling factors
--- x, y and z.
--- @param x number
--- @param y number
--- @param z number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setScaleTransform3D
function setScaleTransform3D(x, y, z) end;
gl.setScaleTransform3D = setScaleTransform3D;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Loads wave sample (.wav format) into memory from file, specified by fileName.
--- @param fileName string
--- @param isNeedTimer boolean
--- @param isNeedReversed boolean
--- @overload fun(fileName:string):number
--- @overload fun(fileName:string, isNeedTimer:boolean):number
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#loadSample
function loadSample(fileName, isNeedTimer, isNeedReversed) end;
al.loadSample = loadSample;

--- Unloads sample, specified by numeric identifier id.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#unloadSample
function unloadSample(id) end;
al.unloadSample = unloadSample;

--- @class SoundEnvironment

SOUND_INTERNAL = nil
SOUND_EXTERNAL = nil
SOUND_EVERYWHERE = nil

--- Starts playing sample with specified id.
--- @param id number
--- @param isLooping boolean
--- @overload fun(id:number, isLooping:boolean):void
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#playSample
function playSample(id, isLooping) end;
al.playSample = playSample;

--- Stops playing sample with specified numeric id.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#stopSample
function stopSample(id) end;
al.stopSample = stopSample;

--- Pauses playing sample with specified numeric id.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#pauseSample
function pauseSample(id) end;
al.pauseSample = pauseSample;

--- Sets sample playback position to zero.
--- @param id number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#rewindSample
function rewindSample(id) end;
al.rewindSample = rewindSample;

--- Returns true if sample, specified by id is playing right now and false otherwise.
--- @param id number
--- @return boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#isSamplePlaying
function isSamplePlaying(id) end;
al.isSamplePlaying = isSamplePlaying;

--- Returns remaining time of playing for sample, specified by numeric identifier id, if the
--- sample is playing right now.
--- @param id number
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getSamplePlayingRemaining
function getSamplePlayingRemaining(id) end;
al.getSamplePlayingRemaining = getSamplePlayingRemaining;

--- Sets gain of sample, specified by numeric identifier id.
--- @param id number
--- @param gain number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setSampleGain
function setSampleGain(id, gain) end;
al.setSampleGain = setSampleGain;

--- Adjusts gain of all samples in SASL sound system.
--- @param gain number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setMasterGain
function setMasterGain(gain) end;
al.setMasterGain = setMasterGain;

--- Sets minimum gain of sample, specified by numeric identifier id.
--- @param id number
--- @param minGain number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setMinimumSampleGain
function setMinimumSampleGain(id, minGain) end;
al.setMinimumSampleGain = setMinimumSampleGain;

--- Sets maximum gain of sample, specified by numeric identifier id.
--- @param id number
--- @param maxGain number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setMaximumSampleGain
function setMaximumSampleGain(id, maxGain) end;
al.setMaximumSampleGain = setMaximumSampleGain;

--- Sets pitch (frequency) of sample, specified by numeric identifier id.
--- @param id number
--- @param pitch number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setSamplePitch
function setSamplePitch(id, pitch) end;
al.setSamplePitch = setSamplePitch;

--- Sets current playback point position for sample, specified with numeric identifier id.
--- @param id number
--- @param offset number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setSampleOffset
function setSampleOffset(id, offset) end;
al.setSampleOffset = setSampleOffset;

--- Returns current playback point position for sample, specified with numeric identifier id.
--- @param id number
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getSampleOffset
function getSampleOffset(id) end;
al.getSampleOffset = getSampleOffset;

--- Returns total duration of the sample (in seconds), specified with numeric identifier id.
--- @param id number
--- @return number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getSampleDuration
function getSampleDuration(id) end;
al.getSampleDuration = getSampleDuration;

--- Sets 3D position of sample, specified by numeric identifier id.
--- @param id number
--- @param x number
--- @param y number
--- @param z number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setSamplePosition
function setSamplePosition(id, x, y, z) end;
al.setSamplePosition = setSamplePosition;

--- Returns 3D position of sample, specified by numeric identifier id.
--- @param id number
--- @return number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getSamplePosition
function getSamplePosition(id) end;
al.getSamplePosition = getSamplePosition;

--- Sets direction vector of sample, specified by numeric identifier id.
--- @param id number
--- @param x number
--- @param y number
--- @param z number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setSampleDirection
function setSampleDirection(id, x, y, z) end;
al.setSampleDirection = setSampleDirection;

--- Returns direction vector of sample, specified by numeric identifier id.
--- @param id number
--- @return number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getSampleDirection
function getSampleDirection(id) end;
al.getSampleDirection = getSampleDirection;

--- Sets spatial velocity vector for sample, specified by numeric identifier id.
--- @param id number
--- @param x number
--- @param y number
--- @param z number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setSampleVelocity
function setSampleVelocity(id, x, y, z) end;
al.setSampleVelocity = setSampleVelocity;

--- Returns spatial velocity vector for sample, specified by numeric identifier id.
--- @param id number
--- @return number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getSampleVelocity
function getSampleVelocity(id) end;
al.getSampleVelocity = getSampleVelocity;

--- Sets sound cone parameters for sample, specified by numeric identifier id.
--- @param id number
--- @param outerGain number
--- @param innerAngle number
--- @param outerAngle number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setSampleCone
function setSampleCone(id, outerGain, innerAngle, outerAngle) end;
al.setSampleCone = setSampleCone;

--- Returns sound cone parameters for sample, specified by numeric identifier id.
--- @param id number
--- @return number, number, number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getSampleCone
function getSampleCone(id) end;
al.getSampleCone = getSampleCone;

--- Sets sound environment option for sample, specified by numeric identifier id.
--- @param id number
--- @param env SoundEnvironment
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setSampleEnv
function setSampleEnv(id, env) end;
al.setSampleEnv = setSampleEnv;

--- Returns sound environment value for sample, specified by numeric identifier id.
--- @param id number
--- @return SoundEnvironment
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getSampleEnv
function getSampleEnv(id) end;
al.getSampleEnv = getSampleEnv;

--- Sets attachment point for sample, specified by numeric identifier id.
--- @param id number
--- @param isRelative boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setSampleRelative
function setSampleRelative(id, isRelative) end;
al.setSampleRelative = setSampleRelative;

--- Returns attachment point identifier for sample, specified by numeric identifier id.
--- @param id number
--- @return boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#getSampleRelative
function getSampleRelative(id) end;
al.getSampleRelative = getSampleRelative;

--- Sets maximum distance, at which sample can be heard.
--- @param id number
--- @param distance number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setSampleMaxDistance
function setSampleMaxDistance(id, distance) end;
al.setSampleMaxDistance = setSampleMaxDistance;

--- Sets computational rolloff factor for sample, specified by id.
--- @param id number
--- @param factor number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setSampleRolloffFactor
function setSampleRolloffFactor(id, factor) end;
al.setSampleRolloffFactor = setSampleRolloffFactor;

--- Sets reference distance for sample, specified by id.
--- @param id number
--- @param distance number
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#setSampleRefDistance
function setSampleRefDistance(id, distance) end;
al.setSampleRefDistance = setSampleRefDistance;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Defines internal component property with specified name and assigns inValue value to it.
--- @param name string
--- @param inValue any
--- @return Property
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#defineProperty
function defineProperty(name, inValue) end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Synchronously start process, specified by path.
--- @param path string
--- @param args string
--- @param toStdIn string
--- @param stdOutToString boolean
--- @param stdErrToString boolean
--- @return boolean, number, number, number, number, string, string
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#startProcessSync
function startProcessSync(path, args, toStdIn, stdOutToString, stdErrToString) end
sasl.startProcessSync = startProcessSync;

--- Asynchronously start process, specified by path.
--- @param path string
--- @param args string
--- @param toStdIn string
--- @param stdOutToString boolean
--- @param stdErrToString boolean
--- @param callback fun(status:boolean, pOut:number, outSize:number, pErr:number, errSize:number, inOutString:string, inErrString:string):void
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#startProcessAsync
function startProcessAsync(path, args, toStdIn, stdOutToString, stdErrToString, callback) end
sasl.startProcessAsync = startProcessAsync;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Reads file specified by pathToFile using data format specification.
--- @param pathToFile string
--- @param format string
--- @return table
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#readConfig
function readConfig(pathToFile, format) end
sasl.readConfig = readConfig;

--- Converts table t to the data in specified format and writes data to file pathToFile.
--- @param pathToFile string
--- @param format string
--- @param t table
--- @return boolean
--- @see reference
--- : https://1-sim.com/files/SASL3Manual.pdf#writeConfig
function writeConfig(pathToFile, format, t) end
sasl.writeConfig = writeConfig;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------