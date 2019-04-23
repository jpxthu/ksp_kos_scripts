wait 30.
RunPath("/launch/launch_into_apoapsis", 80000).
wait 1.
RunPath("/docking/docking", 1000, 0.5, 150, 5, "p1", "p0", 12).
