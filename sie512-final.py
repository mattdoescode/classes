# Perlin noise to generate terrain 

# soil moisture levels 

# number of nodes 

# users add or remove nodes


# pauseable program 

# The algorithms I’d like to simulate would be pathfinding (energy saving, shortest path),
# neighborhood management (density of nodes vs memory), auto assigning node role and node
# time syncing (nodes send data at staggering determined times, allowing the router to go sleep).
# I will gladly add or remove any at your discretion.

#Visual of map / with nodes + coordinates 
# plot showing current soil moisture levels 
#state / attribue of each node with 
# Object node 
# range, battery life, sleep settings, role, detected neighbors 

# add and remove nodes

from opensimplex import OpenSimplex
import numpy
import pygame

tmp = OpenSimplex(seed = 0)

CONSTmapSize = 1000,1000
themap = numpy.zeros((CONSTmapSize[0], CONSTmapSize[1]))

def convert_range(min, max, newMin, newMax, oldValue):
    oldRange = max - min
    newRange = newMax - newMin
    newValue = (((oldValue - min) * newRange) / oldRange) + newMin
    return newValue

for x in range(CONSTmapSize[0]):
    for y in range(CONSTmapSize[0]):
        nx = x/CONSTmapSize[0] - 0.5 
        ny = y/CONSTmapSize[1] - 0.5

        #zoom in or out
        frequency = 4

        nx = nx * frequency
        ny = ny * frequency

        #add detail "octaves"
        themap[x][y] = convert_range(0,2,0,255, 1 * tmp.noise2d(1 * nx, 1 * ny) + 0.5 * tmp.noise2d(2 * nx, 2 * ny) + 0.25 * tmp.noise2d(6 * nx, 6 * ny) + 1)

        #print(themap[x][y])

pygame.init()

screen = pygame.display.set_mode([CONSTmapSize[0], CONSTmapSize[1]])

running = True
paused = False


#display everything 
#keep state and track
while running:
    while not paused:
        # Did the user click the window close button?
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        # Fill the background with white
        for x in range(CONSTmapSize[0]):
            for y in range(CONSTmapSize[0]):
                color = 0

                if themap[x][y] <= 50:
                    color = (0,0,255)
                elif themap[x][y] <= 70:
                    color = (210,180,140)
                elif themap[x][y] <= 140:
                    color = (112, 130, 56)
                elif themap[x][y] <= 200:
                    color = (11, 102, 35)
                elif themap[x][y] <= 220:
                    color = (139, 137, 137)
                else:
                  color = (255, 250, 255)
                
                
                screen.set_at((x, y), (color))

        # Flip the display
        pygame.display.flip()

# Done! Time to quit.
pygame.quit()