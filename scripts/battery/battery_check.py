import subprocess
import re

e = subprocess.check_output(['upower -d'], shell=True)

e = e.decode().split("\n")


e = e[:-1]

saved_line = ""
good_part_found = 0

for line in e:
    if "DisplayDevice" in line:
        good_part_found = 1
    if good_part_found == 1:
        saved_line = saved_line + line + "\n"

for line in e:
    if "percentage" in line:
            e = line

e = e.split(" ")

e = e[-1]

e = e[:5]

e = e + "%"

d = e[:3]

if "." in d:
    d = d[:-1]


d = re.sub('[^0-9]', '', d)


print(d)

