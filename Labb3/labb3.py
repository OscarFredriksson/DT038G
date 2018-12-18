#!/usr/bin/python

from threading import Thread
from threading import Lock
import time
import datetime
from random import randint

resource = ""
readers = 0
writers = 0
resource_lock = Lock()
read_lock = Lock()
edit_readers_lock = Lock()
edit_writers_lock = Lock()

def acquire_write_lock():
      edit_writers_lock.acquire()
      
      global writers
      writers += 1
      if writers == 1:
         read_lock.acquire()

      edit_writers_lock.release()
      resource_lock.acquire()


def release_write_lock():
   edit_writers_lock.acquire()
   resource_lock.release()
   
   global writers
   writers -= 1
   if writers == 0:
      read_lock.release()
   
   edit_writers_lock.release()
   

def acquire_read_lock():   
      read_lock.acquire()
      edit_readers_lock.acquire()
      
      global readers
      readers += 1
      if readers == 1:
         resource_lock.acquire()

      edit_readers_lock.release()
      read_lock.release()


def release_read_lock():
   edit_readers_lock.acquire()

   global readers
   readers -= 1
   if readers == 0:
      resource_lock.release()
   
   edit_readers_lock.release()

   
def write_thread1():
   for i in range(1000):
      acquire_write_lock()
      
      #time.sleep(1)

      print("Writer1 writing...")
      now = datetime.datetime.now()
      global resource
      resource = str(now.year) + "-" + str(now.month) + "-" + str(now.day) + " " + str(now.hour) + ":" + str(now.minute) + ":" + str(now.second)
      print("finised writing!")

      release_write_lock()

      

def write_thread2():
   for i in range(1000):
      acquire_write_lock()

      #time.sleep(1)

      print("Writer2 writing...")
      now = datetime.datetime.now()
      global resource
      resource = str(now.hour) + ":" + str(now.minute) + ":" + str(now.second) + " " + str(now.year) + "-" + str(now.month) + "-" + str(now.day)
      print("finised writing!")

      release_write_lock()

def read_thread():
   for i in range(10):
      acquire_read_lock()  

      #time.sleep(1)

      global readers
      global resource
      print("Reading: ", resource, " alongside ", readers-1, " other readers.")
               
      release_read_lock()


Writer1 = Thread(target=write_thread1)
Writer2 = Thread(target=write_thread2)

Reader1 = Thread(target=read_thread)
Reader2 = Thread(target=read_thread)
Reader3 = Thread(target=read_thread)
Reader4 = Thread(target=read_thread)


Writer1.start()
Writer2.start()

Reader1.start()
Reader2.start()
Reader3.start()
Reader4.start()

      
