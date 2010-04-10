 
Feature: spawn process

As a user
I want slow to spawn a command given as a command line argument
so that the command runs as child process of slow 

Scenario: spawn process
  Given a command argument
  When the user runs slow
  Then the command should be spawned as a child process
