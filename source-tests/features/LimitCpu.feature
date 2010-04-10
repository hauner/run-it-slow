 
Feature: limit cpu

As a user
I want slow to run a given command
and limit the commands cpu usage (including any sub processes)

Scenario: limit process cpu
  Given a command argument
  When the user runs slow
  Then it should limit the commands cpu usage to 50%

Scenario: limit process group cpu
  Given a command argument that spawns other processes
  When the user runs slow
  Then it should limit the commands cpu usage to 50%
