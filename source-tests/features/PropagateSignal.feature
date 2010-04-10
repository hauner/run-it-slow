 
Feature: propagate signal

As a user
I want slow to propagate signals to its command
so that the command receives the signal


Scenario: kill process
  Given a command argument
  When the user runs slow
  And  kills it with ctrl+c
  Then it should propagate ctrl+c too the command
