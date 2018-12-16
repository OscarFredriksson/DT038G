#!/usr/bin/python

import _thread
import time

def print_thread(threadname, delay):
   while True:
      print(threadname)
      time.sleep(delay)

try:
   _thread.start_new_thread(print_thread, ("Tråd1", 2, ) )
   _thread.start_new_thread(print_thread, ("Tråd2", 4, ) )
except:
   print("Error: unable to start thread")

while True:
   pass
