#!/usr/bin/python

from threading import Thread
from threading import Lock
import time
import datetime
from random import randint

resource = ""
readers = 0
writers = 0
write_lock = Lock()
resource_lock = Lock()

def acquire_write_lock():
      global writers
      writers += 1
      if(writers == 1):
            resource_lock.acquire()

      #print("locking...")
      write_lock.acquire()


def release_write_lock():
   #print("Releasing write lock...")
   write_lock.release()
   #print("done!")
   global writers
   writers -= 1
   if(writers == 0):
      resource_lock.release()
   

def acquire_read_lock():   
      resource_lock.acquire()
      
      global readers
      readers += 1
      if readers == 1:
            #print("Write_locked...")
            write_lock.acquire()
            #print("Freed!")

      resource_lock.release()

def release_read_lock():
   global readers
   readers -= 1
   if readers == 0:
      write_lock.release()
   


def write_thread1():
      while(True):
            #for i in range(3):
            acquire_write_lock()
            #time.sleep(1)

            print("writing...")
            now = datetime.datetime.now()
            global resource
            resource = str(now.year) + "-" + str(now.month) + "-" + str(now.day) + " " + str(now.hour) + ":" + str(now.minute) + ":" + str(now.second)
            print("finised writing!")

            release_write_lock()

      

def write_thread2():
      while(True):
            #for i in range(3):
            acquire_write_lock()
            #print("writing...")

            #time.sleep(1)

            print("writing...")
            now = datetime.datetime.now()
            global resource
            resource = str(now.hour) + ":" + str(now.minute) + ":" + str(now.second) + " " + str(now.year) + "-" + str(now.month) + "-" + str(now.day)
            print("finised writing!")

            release_write_lock()

def read_thread():
      while(True):
            #for i in range(3):
            acquire_read_lock()  

            #time.sleep(1)    

            global readers
            #time.sleep(2)
            global resource
            print("Reading: ", resource, " alongside ", readers-1, " other readers.")
                  
            release_read_lock()


Writer1 = Thread(target=write_thread1)
Writer2 = Thread(target=write_thread2)

Reader1 = Thread(target=read_thread)
Reader2 = Thread(target=read_thread)
Reader3 = Thread(target=read_thread)

#while(True):
#Writer1.start()
Writer2.start()
      #time.sleep(2)

Reader1.start()
Reader2.start()
Reader3.start()

      
