## NCDebug {#PackageNCDebug}

Members are:

* [NCDebug](#NCDebug)

### NCDebug {#NCDebug}

`NCDebug[level, message]` prints the objects `message` if level is higher than the current `DebugLevel` option.

Use `SetOptions[NCDebug, DebugLevel -> level]` to set up the current
debug level.

Available options are:

- `DebugLevel` (0): current debug level;
- `DebugLogFile` (`$Ouput`): current file to which messages are printed.
