@echo off
if (%1) == () (
 goto ERROR
)
if (%2) == () (
 goto ERROR
)
if (%3) == () (
 set RunList=
) else (
 set RunList=/runlist:%3
)

set NunitCategorySelector=%1
set NunitCategorySelector=%NunitCategorySelector:^=%
set ResultFileName=%2
set NUnitBin=..\NUnit\nunit-console-x86
set NUnitProject=..\..\NUnit\All.nunit

set NUnitResultPath=..\..\Results\
mkdir %NUnitResultPath%
set NUnitResultFile=%NUnitResultPath%%ResultFileName%
set NunitConsoleLogFilename=%NUnitResultPath%NUnitConsoleLog.txt
echo %NUnitBin% %NUnitProject% /include:%NunitCategorySelector% /result:%ResultFileName% %RunList%
%NUnitBin% %NUnitProject% /include:%NunitCategorySelector% /result:%ResultFileName% %RunList% >%NunitConsoleLogFilename%
if not exist %NUnitResultFile% if exist %ResultFileName% copy %ResultFileName% %NUnitResultFile% /y
goto EXIT

:ERROR
echo Invalid arguments: NunitCategorySelector or ResultFileName

:EXIT
