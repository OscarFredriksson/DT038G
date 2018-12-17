#!/usr/bin/python

import _thread
import time

filename = "test.txt"
#file = open(filename, "w")
#file.close()

def print_thread(threadname, delay, filename):
   i = 0
   file = open(filename, "a")
   while True:
      time.sleep(delay)
      print("writing: ", sep="")
      print(i)
      file.write(str(i))
      file.write(" ")
      i += 1

def read_thread(threadname, delay, filename):
   while True:
      time.sleep(delay)
      file = open(filename, "r")
      print("Reading:", sep="")
      print(file.read())


try:
   _thread.start_new_thread(print_thread,("Tråd1", 1, filename) )
   _thread.start_new_thread(read_thread, ("Tråd2", 4, filename) )
except:
   print("Error: unable to start thread")

while True:
   pass
