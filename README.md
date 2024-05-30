# Brownian Motion PHYS2020 project

Gitlab repository for PHYS2020 Simulation project Semester 1. Authored by Krishna Karthik.

## Description
This project includes a fully vectorised implementation of a molecular dynamics Brownian motion simulation in MATLAB. The project contains 3 function files, computeAcceleration.m, animation.m, and nbodysimulation.m. `computeAcceleration` takes in positions, masses, and Lennard-Jones parameters as inputs, and then uses the 6-12 Lennard-Jones potential to compute the forces between particles. It then divides by respective masses to compute the accelerations of each particle in the simulation.

`computeAcceleration` is implemented in a fully vectorised way, avoiding the typical nested for-loops seen in naive MD simulations. `nbodysimulation` then uses computeAcceleration to compute the accelerations of the particles and numerically integrate for each timestep. It then returns the position matrices for animation. Then, when called with the correct parameters, animation.m draws the computed positions from `nbodysimulation` and animates them. 

<a href="url"><img src="https://github.com/krishnakbvis/MATLAB-Brownian-Motion/assets/124866933/8698cfb0-683c-4cc2-b77b-784eb27b420d" align="left" height="350" width="350">

<a href="url"><img src="https://github.com/krishnakbvis/MATLAB-Brownian-Motion/blob/master/Brownian%20motion%20eg%202.png?raw=true" align="left" height="350" width="350">


### computeAcceleration.m

computeAcceleration is a fully vectorised function that takes in a parameter for particle x-y positions `pos`, their respective `masses`, and Lennard-Jones parameters `sigmas`, `epsilon`, `A`, and `B`. 

$$V_{LJ}(r) = 4\epsilon \left[\left( A\frac{\sigma}{r}\right)^{12} -  B\left(\frac{\sigma}{r}\right)^6\right]$$

We can compute forces using the Newtonian relation 

$$\mathbf{F} = -\nabla V$$

$$\mathbf{F} = 4{\epsilon}\cdot\left(\dfrac{6B{\sigma}^6}{r^7}-\dfrac{12A{\sigma}^{12}}{r^{13}}\right)$$

To compute this interaction force between each body, consider the n-by-n matrices containing the x and y separations between each body. In computeforces, this is `dx` and `dy`. Instead of using a for-loop to iterate through each body, which is of `O(n^2)` complexity, we can simply calculate `dx = x' - x`, where `x` is an n-by-1 matrix, and `x'` is its transpose. MATLAB uses matrix broadcasting to extend `x'` and `x`, so the result will be an n-by-n matrix of separations. 

Using `dx` and `dy`, we can calculate the x and y components of the unit vectors between particles, the inverse $r^7$ and $r^13$ values in the Lennard-Jones force, and the separation `sep`. We can then calculate the x and y components of forces by multiplying by unit vectors. Let `F` be the n-by-n matrix of forces between particles, and `unitX` and `unitY` by the unit vector component matrices. Then,

```
    Fx = (unitX .* forces);
    Fy = (unitY .* forces);
```
To find the total forces on each particle, we sum each row. Then, to compute accelerations, we divide element-wise by their masses. This vectorised approach solves force computation in far less than `O(n)` time, and makes our simulation far less than `O(n^2)` time-complex.



### animation.m

To render fast animations, the 2D MATLAB `plot` function is used. The particle undergoing Brownian motion has a higher marker size. Since `plot` is vectorised, we can almost instantly display all bodies before moving to the next timestep. Between each frame, we need a slight delay, so a for loop is still required. However, the vectorisation of `plot` makes animation very fast, which scales well with a higher molecule count. 


### nbodysimulation.m

`nbodysimulation` uses `computeAcceleration` to get the accelerations of the bodies. Then, it numerically integrates these accelerations using a vectorised Stormer-Verlet method. Additionally, this code contains some key collision physics, which reverses velocities accordingly if masses collide with the container walls. 

### main.m

`main` executes `nbodysimulation` to produce the positions, and feeds it to `animate` which then animates these positions. 


## Project status
- create a histogram from the brownian particle's position dataset 
