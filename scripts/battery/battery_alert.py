import time
import subprocess

while 1:
    batt = subprocess.check_output(['python', '/home/ari/System/scripts/battery/battery_check.py'])
    batt = int(batt)
    if batt >= 80:
        maxbatt = "notify-send --expire-time=1200000 'Battery reached 80%'"
        time.sleep(100*60)
    if batt <= 10:
        minbatt = "notify-send --urgency=critical 'Battery below 10%'"
        time.sleep(35*60)
    time.sleep(20)

