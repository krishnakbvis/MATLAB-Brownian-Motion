# Brownian Motion PHYS2020 project

Gitlab repository for PHYS2020 Simulation project Semester 1. Authored by Krishna Karthik.

## Description
This project includes a fully vectorised implementation of a molecular dynamics Brownian motion simulation in MATLAB. The project contains 3 function files, computeAcceleration.m, animation.m, and nbodysimulation.m. `computeAcceleration` takes in positions, masses, and Lennard-Jones parameters as inputs, and then uses the 6-12 Lennard-Jones potential to compute the forces between particles. It then divides by respective masses to compute the accelerations of each particle in the simulation.

`computeAcceleration` is implemented in a fully vectorised way, avoiding the typical nested for-loops seen in naive MD simulations. `nbodysimulation` then uses computeAcceleration to compute the accelerations of the particles and numerically integrate for each timestep. It then returns the position matrices for animation. Then, when called with the correct parameters, animation.m draws the computed positions from `nbodysimulation` and animates them. 


### computeAcceleration.m

computeAcceleration is a fully vectorised function that takes in a parameter for particle x-y positions `pos`, their respective `masses`, and Lennard-Jones parameters `sigmas`, `epsilon`, `A`, and `B`. 

$$V_{LJ}(r) = 4\epsilon \left[\left( \frac{\sigma}{r}\right)^12 \left(\frac{\sigma}{r}\right)^6\right]$$






### animation.m


### nbodysimulation.m

### main.m



## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
