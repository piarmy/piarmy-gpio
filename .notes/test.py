import RPi.GPIO as GPIO  
import time

red        = 26
yellow     = 19
green      = 21

iterations = 10  # The number of times to blink  
interval   = .25   # The length of time to blink on or off

GPIO.setmode(GPIO.BCM)  
GPIO.setwarnings(False)  
GPIO.setup(red, GPIO.OUT)
GPIO.setup(yellow, GPIO.OUT)
GPIO.setup(green, GPIO.OUT)

# The parameters to "range" are inclusive and exclusive, respectively,
#  so to go from 1 to 10 we have to use 1 and 11 (add 1 to the max)
for x in range(1, iterations+1):

    print "Loop %d: LED on" % (x)
    GPIO.output(red, GPIO.HIGH)
    GPIO.output(yellow, GPIO.HIGH)
    GPIO.output(green, GPIO.HIGH)
    time.sleep(interval)

    print "Loop %d: LED off" % (x)
    GPIO.output(red, GPIO.LOW)
    GPIO.output(yellow, GPIO.LOW)
    GPIO.output(green, GPIO.LOW)
    time.sleep(interval)