#NoEnv
#Include settings.ahk
SetKeyDelay, 0
; v0.5

started := A_NowUTC
if (%resetSounds%)
  SoundPlay, A_ScriptDir\..\media\reset.wav
saved := False
FileDelete,%4%
FileAppend, [%A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%] Starting Reset `n, log.log

ControlSend, ahk_parent, {Blind}{Shift down}{Tab}{Shift up}{Enter}, ahk_pid %1%

sleep, 1000
while (True) {
  WinGetTitle, title, ahk_pid %1%
  if (InStr(title, " - "))
    break
}

while (True) {
  FileDelete, %4%
  if (ErrorLevel == 0) {
    ControlSend,, {Blind}{Shift}, ahk_pid %1%
    ExitApp
  }
  numLines := 0
  Loop, Read, %2%
  {
    numLines += 1
  }
  saved := False
  Loop, Read, %2%
  {
    if ((numLines - A_Index) < 5)
    {
      FileAppend, %A_LoopReadLine%`n, log.log
      if (InStr(A_LoopReadLine, "Loaded 0") || (InStr(A_LoopReadLine, "Saving chunks for level 'ServerLevel") && InStr(A_LoopReadLine, "minecraft:the_end"))) {
        saved := True
        FileAppend, [%A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%] Found Save `n, log.log
        break
      }
    }
  }
  if (saved || A_Index > %maxLoops%)
    break
}

FileAppend,,%5%
sleep, %beforePauseDelay%
ControlSend,, {Blind}{F3 Down}{Esc}{F3 Up}, ahk_pid %1%
FileDelete,%5%
if (performanceMethod == "F")
  sleep, %beforeFreezeDelay%
FileAppend,, %3%
ControlSend,, {Blind}{Shift}, ahk_pid %1%
ExitApp
