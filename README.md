# indoor-navigation
Documentation and code for the indoor navigation system based on the DW1000 chip.

This mostly holds a [Processing](https://processing.org/tutorials/) project that plots the location of a tag surrounded by 3 anchors. 2 of the anchors are simulated, the third can be configured to take input from a serial port, or can be simulated as well.

Here's a snapshot of what it should look like when running:

![Processing visualization](https://github.com/aareano/indoor-navigation/raw/master/demo.png)

Press the arrow keys to rotate the grid along each of the axes. Press X, Y, and Z to toggle the circles around each of the beacons. A circle represents the current distance the tag is from the beacon. The tag is the white circle and represents the user. It's location is (unreliably) calculated in `sketch.pde`.

---

This project is heavily inspired by [Wayne Holder](https://sites.google.com/site/wayneholder/uwb-ranging-with-the-decawave-dwm1000---part-ii) and uses [thotro's code](https://github.com/thotro/arduino-dw1000) for the anchors and tags.
