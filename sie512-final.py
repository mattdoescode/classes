# soil moisture levels

# number of nodes

# users add or remove nodes

# pauseable program

# The algorithms I’d like to simulate would be pathfinding (energy saving, shortest path),
# neighborhood management (density of nodes vs memory), auto assigning node role and node
# time syncing (nodes send data at staggering determined times, allowing the router to go sleep).
# I will gladly add or remove any at your discretion.

# Visual of map / with nodes + coordinates
# plot showing current soil moisture levels
# state / attribue of each node with
# Object node

# add and remove nodes

from opensimplex import OpenSimplex
# https://pypi.org/project/opensimplex/
import numpy
import pygame
import time

tmp = OpenSimplex(seed=5847)

CONSTmapSize = 500, 500

#color array of points
heights = numpy.zeros(CONSTmapSize[0]*CONSTmapSize[1], dtype=(float,3))
#values of said points before color conversion
themap = numpy.zeros((CONSTmapSize[0], CONSTmapSize[1]))

#convert from 1 number range to another
def convert_range(min, max, newMin, newMax, oldValue):
    oldRange = max - min
    newRange = newMax - newMin
    newValue = (((oldValue - min) * newRange) / oldRange) + newMin
    return newValue

#create terrain
print("Generating terrain.")
for x in range(CONSTmapSize[0]):
    for y in range(CONSTmapSize[0]):
        nx = x/CONSTmapSize[0] - 0.5
        ny = y/CONSTmapSize[1] - 0.5

        # zoom in or out
        frequency = 4

        nx = nx * frequency
        ny = ny * frequency

        # add detail "octaves"
        themap[x][y] = convert_range(0, 2, 0, 255, 1 * tmp.noise2d(1 * nx, 1 * ny) +
                                     0.5 * tmp.noise2d(2 * nx, 2 * ny) + 0.25 * tmp.noise2d(6 * nx, 6 * ny) + 1)

        # print(themap[x][y])

print("Terrain Created")

# colors
water = (0, 0, 255)
sand = (210, 180, 140)
lightGrass = (112, 130, 56)
heavyGrass = (11, 102, 35)
rock = (139, 137, 137)
snow = (255, 250, 255)

#what pixel to what color
def computeHeights():
    print("Starting to compute Terrain")
    elem = 0
    for x in range(CONSTmapSize[0]):
        for y in range(CONSTmapSize[0]):
            if themap[x][y] <= waterLevel:
                color = water
            elif themap[x][y] <= 100:
                color = sand
            elif themap[x][y] <= 140:
                color = lightGrass
            elif themap[x][y] <= 200:
                color = heavyGrass
            elif themap[x][y] <= 235:
                color = rock
            else:
                color = snow
            
            heights[elem] = color
            elem = elem + 1
    print("Computed Height Map")

waterLevel = 180
computeHeights()

def screenshot():
    time_taken = time.asctime(time.localtime(time.time()))
    time_taken = time_taken.replace(" ", "_")
    time_taken = time_taken.replace(":", "-")
    save_file = "screenshots/" + time_taken + ".png"
    pygame.image.save(screen, save_file)
    print("screen saved")
    return save_file

def showRaw():
    elem = 0
    for x in range(CONSTmapSize[0]):
        for y in range(CONSTmapSize[0]):    
            screen.set_at((x, y), (heights[elem]))
            elem = elem + 1

def loadImage(name):
    screen.blit(pygame.image.load(name),(0,0))
    

def showScreenCap(name):
    print(type(toshow))

pygame.init()
screen = pygame.display.set_mode([CONSTmapSize[0], CONSTmapSize[1]])

running = True
paused = False
changedTerrain = True
clock = pygame.time.Clock()
newScreenCap = ""

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            quit()
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_p:
                paused = not paused
            if event.key == pygame.K_m:
                #CHECK LOGIC HERE
                step = 20
                if waterLevel <= step:
                  waterLevel = 0
                  changedTerrain = True
                else:
                    waterLevel = waterLevel - step
                    changedTerrain = True
                print(waterLevel)

    if(not paused):
        if changedTerrain:
            showRaw()
            computeHeights()
            newScreenCap = screenshot()
            loadImage(newScreenCap)
            # toShow = loadImage(newScreenCap)
            # showScreenCap(toShow)
            changedTerrain = False
        else:
            loadImage(newScreenCap)

        pygame.display.flip()

    clock.tick(30)