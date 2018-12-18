#!/usr/bin/python

from threading import Thread
from threading import Lock
import time
import datetime

resource = ""
readers = 0
read_lock = Lock()
write_lock = Lock()

def acquire_write_lock():
   read_lock.acquire()
   write_lock.acquire()


def release_write_lock():
   #print("Releasing write lock...")
   write_lock.release()
   #print("done!")
   read_lock.release()
   

def acquire_read_lock():
   global readers
   
   read_lock.acquire()
   if readers == 0:
      print("Write_locked...")
      write_lock.acquire()
      print("Freed!")

   read_lock.release()

def release_read_lock():
   global readers
   if readers == 0:
      write_lock.release()
   


def write_thread1():
      acquire_write_lock()

      print("writing...")
      now = datetime.datetime.now()
      global resource
      resource = str(now.year) + "-" + str(now.month) + "-" + str(now.day) + " " + str(now.hour) + ":" + str(now.minute) + ":" + str(now.second)
      time.sleep(1)
      print("finised writing!")

      release_write_lock()
      
      

def write_thread2():
      acquire_write_lock()

      print("writing...")
      now = datetime.datetime.now()
      global resource
      resource = str(now.hour) + ":" + str(now.minute) + ":" + str(now.second) + " " + str(now.year) + "-" + str(now.month) + "-" + str(now.day)
      time.sleep(1)
      print("finised writing!")

      release_write_lock()
      
def read_thread():
      acquire_read_lock()      

      global readers
      readers += 1

      global resource
      print("Reading: ", resource, " alongside ", readers-1, " other readers.")
      time.sleep(1)
      
      readers -= 1
      release_read_lock()

      
      
      

for i in range(5):
   Thread(target=write_thread1).start()
   Thread(target=read_thread).start()
   Thread(target=read_thread).start()
   Thread(target=read_thread).start()
   
   Thread(target=write_thread2).start()
   Thread(target=read_thread).start()
   Thread(target=read_thread).start()
   Thread(target=read_thread).start()
